library(dplyr)
library(tidyr)
library(HiddenMarkov)
library(writexl)
library(ggplot2)

vars_to_model <- c("T2M_MAX", "T2M_MIN", "PRECTOTCORR", "RH2M")
freq_results_list <- list()

message("9 il ve 4 de??i??ken i??in rejim s??kl??klar?? (% Frequency) hesaplan??yor...")

for (prov in unique(panel_df$province)) {
  for (v in vars_to_model) {
    
    sub_data <- panel_df %>% filter(province == prov)
    x_vals <- sub_data[[v]]
    
    if(any(is.na(x_vals))) {
      valid_idx <- !is.na(x_vals)
      x_vals <- x_vals[valid_idx]
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
      
      # Frekans (Y??zde) Hesaplama
      total_months <- length(mapped_states)
      freq_table <- table(factor(mapped_states, levels = 1:3))
      
      freq_df <- data.frame(
        Province = prov,
        Variable = v,
        Regime = c("R1 (Low)", "R2 (Normal)", "R3 (High)"),
        Count_Months = as.numeric(freq_table),
        Total_Months = total_months
      ) %>%
        mutate(Frequency_Percentage = round((Count_Months / Total_Months) * 100, 2))
      
      freq_results_list[[paste(prov, v, sep = "_")]] <- freq_df
    }
  }
}

final_freq_df <- bind_rows(freq_results_list)

# Excel ????kt??s?? (Rejim s??kl??klar?? ve ay say??lar?? tablosu)
write_xlsx(
  list("Regime_Frequencies" = final_freq_df),
  "Markov_Switching_Regime_Frequencies.xlsx"
)

message("Rejim s??kl??klar?? Excel dosyas??na kaydedildi: 'Markov_Switching_Regime_Frequencies.xlsx'")

# --- AKADEM??K G??RSELLE??T??RME: Y??????l??ml?? S??tun Grafi??i (%100 Stacked Bar Chart) ---
# En y??ksek s??cakl??klar (T2M_MAX) ??zerinden oransal da????l??m
plot_freq_data <- final_freq_df %>% filter(Variable == "T2M_MAX")

p_freq <- ggplot(plot_freq_data, aes(x = Province, y = Frequency_Percentage, fill = Regime)) +
  geom_bar(stat = "identity", position = "stack", color = "black", linewidth = 0.4) +
  geom_text(aes(label = sprintf("%.1f%%", Frequency_Percentage)), 
            position = position_stack(vjust = 0.5), size = 3.5, color = "white", fontface = "bold") +
  scale_fill_manual(
    values = c("#2b5c8f", "#1b9e77", "#d95f02"),
    labels = c("R1: Low Regime", "R2: Normal Regime", "R3: High Regime")
  ) +
  labs(
    title = "Frequency of Climatic Regimes: Maximum Temperature",
    subtitle = "Percentage of total time spent in each environmental state (1990???2025)",
    x = "Provinces",
    y = "Frequency (%)",
    fill = "Regime Categories"
  ) +
  theme_bw(base_size = 11) +
  theme(
    plot.title = element_text(face = "bold", size = 13, hjust = 0.5),
    plot.subtitle = element_text(size = 10, hjust = 0.5, color = "gray40"),
    axis.text.x = element_text(angle = 30, hjust = 1, face = "bold", color = "black", size = 11),
    axis.text.y = element_text(color = "black", size = 10),
    legend.position = "bottom",
    legend.title = element_text(face = "bold", size = 10),
    panel.grid.major.x = element_blank(),
    panel.border = element_rect(color = "black", fill = NA, linewidth = 0.7)
  )

print(p_freq)
ggsave("Figure_22_Regime_Frequencies_All_Provinces.png", plot = p_freq, width = 11, height = 7, dpi = 300)
message("Figure_22_Regime_Frequencies_All_Provinces.png ba??ar??yla kaydedildi!")