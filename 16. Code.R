library(dplyr)
library(tidyr)
library(HiddenMarkov)
library(writexl)
library(ggplot2)

vars_to_model <- c("T2M_MAX", "T2M_MIN", "PRECTOTCORR", "RH2M")
empirical_dur_list <- list()

message("9 il ve 4 de??i??ken i??in ger??ekle??en rejim s??releri (Ortalama ve Maksimum) hesaplan??yor...")

for (prov in unique(panel_df$province)) {
  for (v in vars_to_model) {
    
    sub_data <- panel_df %>% filter(province == prov)
    x_vals <- sub_data[[v]]
    
    if(any(is.na(x_vals))) {
      valid_idx <- !is.na(x_vals)
      sub_data_clean <- sub_data[valid_idx, ]
      x_vals <- x_vals[valid_idx]
    } else {
      sub_data_clean <- sub_data
    }
    
    if(length(x_vals) < 40) next 
    
    k <- 3 # 3 Rejimli yap??
    mean_init <- seq(min(x_vals), max(x_vals), length.out = k)
    sd_init   <- rep(sd(x_vals)/k, k)
    Pi_init   <- matrix(0.1/(k-1), nrow = k, ncol = k)
    diag(Pi_init) <- 0.9
    Pi_init   <- t(apply(Pi_init, 1, function(x) x / sum(x)))
    delta_init <- rep(1/k, k)
    
    hmm_obj <- dthmm(x = x_vals, Pi = Pi_init, delta = delta_init, 
                     dist = "norm", pm = list(mean = mean_init, sd = sd_init))
    
    fit <- tryCatch({
      BaumWelch(hmm_obj, control = list(
        tol = 1e-5, maxiter = 150, prt = FALSE, posdiff = FALSE, converge = expression(diff < tol)
      ))
    }, error = function(e) NULL)
    
    if(!is.null(fit)) {
      raw_states <- Viterbi(fit)
      estimated_means <- fit$pm$mean
      mean_order <- order(estimated_means)
      mapped_states <- match(raw_states, mean_order)
      
      # Run-Length Encoding (RLE) ile ard??????k rejim bloklar??n??n uzunluklar??
      rle_res <- rle(mapped_states)
      rle_df <- data.frame(
        Regime_Code = rle_res$values,
        Length = rle_res$lengths
      )
      
      # ??l baz??nda her rejim i??in Ortalama ve Maksimum g??zlenen s??reler
      summary_rle <- rle_df %>%
        group_by(Regime_Code) %>%
        summarise(
          Mean_Duration_Months = round(mean(Length), 2),
          Max_Duration_Months  = max(Length),
          Total_Events         = n(),
          .groups = "drop"
        ) %>%
        mutate(
          Province = prov,
          Variable = v,
          Regime = case_when(
            Regime_Code == 1 ~ "R1 (Low / Cool-Dry)",
            Regime_Code == 2 ~ "R2 (Normal)",
            Regime_Code == 3 ~ "R3 (High / Hot-Wet)"
          )
        ) %>%
        select(Province, Variable, Regime, Mean_Duration_Months, Max_Duration_Months, Total_Events)
      
      empirical_dur_list[[paste(prov, v, sep = "_")]] <- summary_rle
    }
  }
}

final_empirical_df <- bind_rows(empirical_dur_list)

# Excel ????kt??s?? (??stedi??in format?? eksiksiz sunan ana tablo)
write_xlsx(
  list("Empirical_Durations_Summary" = final_empirical_df),
  "Markov_Switching_Empirical_Durations_Table.xlsx"
)

message("Ger??ekle??en rejim s??releri tablosu haz??rland?? ve 'Markov_Switching_Empirical_Durations_Table.xlsx' olarak kaydedildi!")

# --- AKADEM??K G??RSELLE??T??RME: 9 ??lin T2M_MAX ????in Ortalama ve Maksimum S??re Kar????la??t??rmas?? ---
plot_data_long <- final_empirical_df %>%
  filter(Variable == "T2M_MAX", Regime == "R3 (High / Hot-Wet)") %>%
  select(Province, Mean_Duration_Months, Max_Duration_Months) %>%
  pivot_longer(cols = c(Mean_Duration_Months, Max_Duration_Months), 
               names_to = "Duration_Type", values_to = "Months")

p_comp <- ggplot(plot_data_long, aes(x = Province, y = Months, fill = Duration_Type)) +
  geom_bar(stat = "identity", position = "dodge", color = "black", linewidth = 0.4) +
  scale_fill_manual(
    values = c("#2b5c8f", "#d95f02"),
    labels = c("Maximum Duration (Months)", "Mean Duration (Months)")
  ) +
  labs(
    title = "Empirical Durations of High Temperature Regimes (R3)",
    subtitle = "Comparison of mean and maximum continuous active months across all 9 provinces (1990???2025)",
    x = "Provinces",
    y = "Duration (Months)",
    fill = "Metric Type"
  ) +
  theme_bw(base_size = 11) +
  theme(
    plot.title = element_text(face = "bold", size = 12, hjust = 0.5),
    plot.subtitle = element_text(size = 9, hjust = 0.5, color = "gray40"),
    axis.text.x = element_text(angle = 30, hjust = 1, face = "bold", color = "black", size = 10),
    axis.text.y = element_text(color = "black", size = 10),
    legend.position = "bottom",
    legend.title = element_text(face = "bold", size = 10),
    panel.grid.minor = element_blank(),
    panel.border = element_rect(color = "black", fill = NA, linewidth = 0.7)
  )

print(p_comp)
ggsave("Figure_21_High_Regime_Durations_Comparison.png", plot = p_comp, width = 11, height = 6.5, dpi = 300)
message("Figure_21_High_Regime_Durations_Comparison.png ba??ar??yla kaydedildi!")