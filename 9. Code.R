library(dplyr)
library(tidyr)
library(HiddenMarkov)
library(writexl)
library(ggplot2)

vars_to_model <- c("T2M_MAX", "T2M_MIN", "PRECTOTCORR", "RH2M")
ms_4reg_results_list <- list()
transition_4reg_summary_list <- list()

message("9 il ve 4 de??i??ken i??in 4 Rejimli tarafs??z Markov-Switching modeli ??al????t??r??l??yor...")

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
    
    if(length(x_vals) < 40) next 
    
    # 4 Rejim ????in Tarafs??z Ba??lang???? Parametreleri (??eyreklik Da????l??m)
    mean_init <- c(
      mean(x_vals) - 1.0 * sd(x_vals), 
      mean(x_vals) - 0.3 * sd(x_vals), 
      mean(x_vals) + 0.3 * sd(x_vals), 
      mean(x_vals) + 1.0 * sd(x_vals)
    )
    sd_init   <- rep(sd(x_vals)/3, 4)
    Pi_init   <- matrix(0.1, nrow = 4, ncol = 4)
    diag(Pi_init) <- 0.7  # K????egen a????rl??kl?? kal??c??l??k
    # Sat??r toplamlar??n?? 1'e e??itleme
    Pi_init <- t(apply(Pi_init, 1, function(x) x / sum(x)))
    delta_init <- rep(0.25, 4)
    
    hmm_obj <- dthmm(x = x_vals, Pi = Pi_init, delta = delta_init, 
                     dist = "norm", pm = list(mean = mean_init, sd = sd_init))
    
    # Model optimizasyonu (Daha y??ksek iterasyon pay?? ile)
    fit_hmm <- tryCatch({
      BaumWelch(hmm_obj, control = list(
        tol = 1e-5, maxiter = 200, prt = FALSE, posdiff = FALSE, converge = expression(diff < tol)
      ))
    }, error = function(e) NULL)
    
    if(!is.null(fit_hmm)) {
      # 1. Modelin tahmin etti??i ham rejim serisi
      raw_regimes <- Viterbi(fit_hmm)
      
      # 2. Tahmin edilen rejim ortalamalar??na g??re s??ralama ve isimlendirme
      estimated_means <- fit_hmm$pm$mean
      mean_order <- order(estimated_means) # En d??????kten en y??ksek ortalamaya s??ral?? indexler
      
      # Ham rejimleri ampirik ortalamalar??na g??re 1'den 4'e yeniden kodlama
      mapped_regimes <- match(raw_regimes, mean_order)
      
      sub_data_clean$Regime_4State_Labeled <- factor(
        mapped_regimes, 
        levels = c(1, 2, 3, 4), 
        labels = c("Low", "Normal", "Warm", "Extreme Hot")
      )
      sub_data_clean$Variable <- v
      
      key_name <- paste(prov, v, sep = "_")
      ms_4reg_results_list[[key_name]] <- sub_data_clean
      
      # Ge??i?? matrisini s??ralamaya g??re d??zenleme ve kal???? s??releri
      sorted_pi <- fit_hmm$Pi[mean_order, mean_order]
      
      transition_4reg_summary_list[[key_name]] <- data.frame(
        Province = prov,
        Variable = v,
        Mean_State1 = estimated_means[mean_order[1]],
        Mean_State2 = estimated_means[mean_order[2]],
        Mean_State3 = estimated_means[mean_order[3]],
        Mean_State4 = estimated_means[mean_order[4]],
        Duration_Low_Months         = 1 / (1 - sorted_pi[1,1]),
        Duration_Normal_Months      = 1 / (1 - sorted_pi[2,2]),
        Duration_Warm_Months        = 1 / (1 - sorted_pi[3,3]),
        Duration_ExtremeHot_Months  = 1 / (1 - sorted_pi[4,4])
      )
    }
  }
}

final_ms_4reg_df <- bind_rows(ms_4reg_results_list)
transition_4reg_df <- bind_rows(transition_4reg_summary_list)

# Excel ????kt??s??
write_xlsx(
  list(
    "Empirical_Parameters_Duration_4S" = transition_4reg_df,
    "Empirical_Regimes_TimeSeries_4S" = final_ms_4reg_df
  ), 
  "Markov_Switching_Empirical_4Regime_Analysis.xlsx"
)

message("4 Rejimli ampirik model ba??ar??yla tamamland?? ve Excel raporu olu??turuldu!")

# --- AKADEM??K G??RSELLE??T??RME (Ampirik Etiketli 4 Rejim Paneli - T2M_MAX) ---
p_ms_4reg_empirical <- ggplot(final_ms_4reg_df %>% filter(Variable == "T2M_MAX"), aes(x = date, y = T2M_MAX, color = Regime_4State_Labeled)) +
  geom_point(size = 0.6, alpha = 0.75) +
  facet_wrap(~ province, ncol = 3, scales = "free_y") +
  scale_color_manual(
    values = c("#2b5c8f", "#74add1", "#fdae61", "#d73027"), 
    labels = c("State 1: Low", "State 2: Normal", "State 3: Warm", "State 4: Extreme Hot")
  ) +
  labs(
    title = "Empirically Derived 4-Regime Markov States: Maximum Temperature",
    subtitle = "Post-hoc classification: Low -> Normal -> Warm -> Extreme Hot (Southeastern Anatolia)",
    x = "Years", 
    y = "Maximum Temperature (??C)", 
    color = "4-State Regimes"
  ) +
  theme_bw(base_size = 11) +
  theme(
    plot.title = element_text(face = "bold", size = 13, hjust = 0.5, color = "#1a1a1a"),
    plot.subtitle = element_text(size = 9.5, hjust = 0.5, color = "gray40"),
    strip.text = element_text(face = "bold", size = 10),
    strip.background = element_rect(fill = "#f2f2f2", color = "black", linewidth = 0.6),
    axis.text = element_text(color = "black"),
    legend.position = "bottom",
    legend.title = element_text(face = "bold", size = 10),
    panel.grid.minor = element_blank(),
    panel.border = element_rect(color = "black", fill = NA, linewidth = 0.7)
  )

print(p_ms_4reg_empirical)
ggsave("Figure_13_Empirical_4Regime_T2M_MAX.png", plot = p_ms_4reg_empirical, width = 12, height = 8.5, dpi = 300)

message("Figure_13_Empirical_4Regime_T2M_MAX.png ba??ar??yla kaydedildi!")