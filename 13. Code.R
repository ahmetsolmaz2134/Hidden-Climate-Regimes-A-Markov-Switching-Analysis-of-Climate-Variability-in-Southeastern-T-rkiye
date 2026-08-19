library(dplyr)
library(tidyr)
library(HiddenMarkov)
library(writexl)
library(ggplot2)

vars_to_model <- c("T2M_MAX", "T2M_MIN", "PRECTOTCORR", "RH2M")
most_likely_list <- list()

message("9 il ve 4 de??i??ken i??in en olas?? rejim (Viterbi yoluyla) serileri ????kar??l??yor...")

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
      # Viterbi algoritmas?? ile her ay i??in en olas?? gizli rejim dizisi
      raw_states <- Viterbi(fit)
      estimated_means <- fit$pm$mean
      mean_order <- order(estimated_means)
      
      # Ham rejimleri ampirik ortalamalar??na g??re yeniden s??ralama (1 = Low, 2 = Normal, 3 = High)
      mapped_states <- match(raw_states, mean_order)
      
      sub_data_clean$Most_Likely_Regime <- factor(
        mapped_states,
        levels = c(1, 2, 3),
        labels = c("R1 (Low)", "R2 (Normal)", "R3 (High)")
      )
      sub_data_clean$Variable <- v
      
      most_likely_list[[paste(prov, v, sep = "_")]] <- sub_data_clean
    }
  }
}

final_most_likely_df <- bind_rows(most_likely_list)

# Excel ????kt??s?? (9 ilin t??m zaman serisi rejim etiketleri)
write_xlsx(
  list("Most_Likely_Regimes_TimeSeries" = final_most_likely_df),
  "Markov_Switching_Most_Likely_Regimes_All_Provinces.xlsx"
)

message("T??m iller i??in en olas?? rejim serileri Excel'e ba??ar??yla kaydedildi!")

# --- AKADEM??K G??RSELLE??T??RME: 9 ??lin Tamam?? ????in Rejim Da????l??m Grafi??i (T2M_MAX) ---
p_ml_all <- ggplot(final_most_likely_df %>% filter(Variable == "T2M_MAX"), 
                   aes(x = date, y = T2M_MAX, color = Most_Likely_Regime)) +
  geom_point(size = 0.6, alpha = 0.8) +
  facet_wrap(~ province, ncol = 3, scales = "free_y") +
  scale_color_manual(
    values = c("#2b5c8f", "#1b9e77", "#d95f02"),
    labels = c("R1: Low Regime", "R2: Normal Regime", "R3: High Regime")
  ) +
  labs(
    title = "Time Series Segmented by Most Likely Regime: Maximum Temperature",
    subtitle = "Optimal Viterbi path classification across all 9 provinces (1990???2025)",
    x = "Years",
    y = "Maximum Temperature (??C)",
    color = "Regime Categories"
  ) +
  theme_bw(base_size = 11) +
  theme(
    plot.title = element_text(face = "bold", size = 13, hjust = 0.5),
    plot.subtitle = element_text(size = 9.5, hjust = 0.5, color = "gray40"),
    strip.text = element_text(face = "bold", size = 10),
    strip.background = element_rect(fill = "#f2f2f2", color = "black", linewidth = 0.6),
    axis.text = element_text(color = "black"),
    legend.position = "bottom",
    legend.title = element_text(face = "bold", size = 10),
    panel.grid.minor = element_blank(),
    panel.border = element_rect(color = "black", fill = NA, linewidth = 0.7)
  )

print(p_ml_all)
ggsave("Figure_17_Most_Likely_Regimes_All_Provinces.png", plot = p_ml_all, width = 12, height = 8.5, dpi = 300)
message("Figure_17_Most_Likely_Regimes_All_Provinces.png ba??ar??yla kaydedildi!")