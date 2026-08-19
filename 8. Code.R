library(dplyr)
library(tidyr)
library(HiddenMarkov)
library(writexl)
library(ggplot2)

vars_to_model <- c("T2M_MAX", "T2M_MIN", "PRECTOTCORR", "RH2M")
ms_3reg_results_list <- list()
transition_3reg_summary_list <- list()

message("9 il ve 4 de??i??ken i??in 3 Rejimli tarafs??z Markov-Switching modeli ??al????t??r??l??yor...")

for (prov in unique(panel_df$province)) {
  for (v in vars_to_model) {
    
    sub_data <- panel_df %>% filter(province == prov) %>% select(province, date, YEAR, MO, all_of(v))
    x_vals <- sub_data[[v]]
    
    if(any(is.na(x_vals))) {
      valid_idx <- !is.na(x_vals)
      sub_data_clean <- sub_data[valid_idx, ]
      x_vals <- x_vals[valid_idx]
    } else {
      sub_data_clean <- sub_data
    }
    
    if(length(x_vals) < 30) next 
    
    # Tarafs??z ba??lang???? parametreleri
    mean_init <- c(mean(x_vals) - 0.5*sd(x_vals), mean(x_vals), mean(x_vals) + 0.5*sd(x_vals))
    sd_init   <- c(sd(x_vals)/3, sd(x_vals)/3, sd(x_vals)/3)
    Pi_init   <- matrix(1/3, nrow = 3, ncol = 3)
    delta_init <- c(1/3, 1/3, 1/3)
    
    hmm_obj <- dthmm(x = x_vals, Pi = Pi_init, delta = delta_init, 
                     dist = "norm", pm = list(mean = mean_init, sd = sd_init))
    
    # Model optimizasyonu
    fit_hmm <- tryCatch({
      BaumWelch(hmm_obj, control = list(
        tol = 1e-5, maxiter = 150, prt = FALSE, posdiff = FALSE, converge = expression(diff < tol)
      ))
    }, error = function(e) NULL)
    
    if(!is.null(fit_hmm)) {
      # 1. Modelin tahmin etti??i ham rejim serisi
      raw_regimes <- Viterbi(fit_hmm)
      
      # 2. Tahmin edilen rejim ortalamalar??na g??re s??ralama ve isimlendirme
      estimated_means <- fit_hmm$pm$mean
      mean_order <- order(estimated_means) # En d??????kten en y??ksek ortalamaya s??ral?? indexler
      
      # Ham rejimleri ampirik ortalamalar??na g??re yeniden kodlama
      mapped_regimes <- match(raw_regimes, mean_order)
      
      sub_data_clean$Regime_3State_Labeled <- factor(
        mapped_regimes, 
        levels = c(1, 2, 3), 
        labels = c("Low", "Normal", "High")
      )
      sub_data_clean$Variable <- v
      
      key_name <- paste(prov, v, sep = "_")
      ms_3reg_results_list[[key_name]] <- sub_data_clean
      
      # Ge??i?? matrisini s??ralamaya g??re d??zenleme
      sorted_pi <- fit_hmm$Pi[mean_order, mean_order]
      
      transition_3reg_summary_list[[key_name]] <- data.frame(
        Province = prov,
        Variable = v,
        Estimated_Mean_Low = estimated_means[mean_order[1]],
        Estimated_Mean_Normal = estimated_means[mean_order[2]],
        Estimated_Mean_High = estimated_means[mean_order[3]],
        Duration_Low_Months = 1 / (1 - sorted_pi[1,1]),
        Duration_Normal_Months = 1 / (1 - sorted_pi[2,2]),
        Duration_High_Months = 1 / (1 - sorted_pi[3,3])
      )
    }
  }
}

final_ms_3reg_df <- bind_rows(ms_3reg_results_list)
transition_3reg_df <- bind_rows(transition_3reg_summary_list)

# Excel ????kt??s??
write_xlsx(
  list(
    "Empirical_Parameters_Duration" = transition_3reg_df,
    "Empirical_Regimes_TimeSeries" = final_ms_3reg_df
  ), 
  "Markov_Switching_Empirical_3Regime_Analysis.xlsx"
)

message("3 Rejimli ampirik model ba??ar??yla tamamland?? ve Excel raporu olu??turuldu!")

# --- AKADEM??K G??RSELLE??T??RME (Ampirik Etiketli 3 Rejim Paneli) ---
p_ms_empirical <- ggplot(final_ms_3reg_df %>% filter(Variable == "T2M_MAX"), aes(x = date, y = T2M_MAX, color = Regime_3State_Labeled)) +
  geom_point(size = 0.6, alpha = 0.7) +
  facet_wrap(~ province, ncol = 3, scales = "free_y") +
  scale_color_manual(
    values = c("#2b5c8f", "#1b9e77", "#d95f02"), 
    labels = c("State 1: Low", "State 2: Normal", "State 3: High")
  ) +
  labs(
    title = "Empirically Derived 3-Regime Markov States: Maximum Temperature",
    subtitle = "Classified post-hoc by estimated model means (Southeastern Anatolia)",
    x = "Years", 
    y = "Maximum Temperature (??C)", 
    color = "Empirical Regimes"
  ) +
  theme_bw(base_size = 11) +
  theme(
    plot.title = element_text(face = "bold", size = 13, hjust = 0.5, color = "#1a1a1a"),
    plot.subtitle = element_text(size = 10, hjust = 0.5, color = "gray40"),
    strip.text = element_text(face = "bold", size = 10),
    strip.background = element_rect(fill = "#f2f2f2", color = "black", linewidth = 0.6),
    axis.text = element_text(color = "black"),
    legend.position = "bottom",
    legend.title = element_text(face = "bold", size = 10),
    panel.grid.minor = element_blank(),
    panel.border = element_rect(color = "black", fill = NA, linewidth = 0.7)
  )

print(p_ms_empirical)
ggsave("Figure_12_Empirical_3Regime_T2M_MAX.png", plot = p_ms_empirical, width = 12, height = 8.5, dpi = 300)

message("Figure_12_Empirical_3Regime_T2M_MAX.png ba??ar??yla kaydedildi!")