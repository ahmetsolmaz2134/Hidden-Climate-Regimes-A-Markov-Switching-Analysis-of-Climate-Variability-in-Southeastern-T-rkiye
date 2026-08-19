library(dplyr)
library(tidyr)
library(HiddenMarkov)
library(writexl)
library(ggplot2)

vars_to_model <- c("T2M_MAX", "T2M_MIN", "PRECTOTCORR", "RH2M")
ms_3reg_results_list <- list()
transition_3reg_summary_list <- list()

message("9 il ve 4 de??i??ken i??in 3 Rejimli Markov-Switching modelleri kuruluyor...")

for (prov in unique(panel_df$province)) {
  for (v in vars_to_model) {
    
    sub_data <- panel_df %>% filter(province == prov) %>% select(province, date, YEAR, MO, all_of(v))
    x_vals <- sub_data[[v]]
    
    # Eksik veri kontrol??
    if(any(is.na(x_vals))) {
      valid_idx <- !is.na(x_vals)
      sub_data_clean <- sub_data[valid_idx, ]
      x_vals <- x_vals[valid_idx]
    } else {
      sub_data_clean <- sub_data
    }
    
    if(length(x_vals) < 30) next 
    
    # 3 Rejim ????in Ba??lang???? Parametreleri (D??????k, Orta, Y??ksek)
    mean_init <- c(mean(x_vals) - sd(x_vals), mean(x_vals), mean(x_vals) + sd(x_vals))
    sd_init   <- c(sd(x_vals)/2, sd(x_vals)/2, sd(x_vals)/2)
    
    # 3x3 Ge??i?? Matrisi (K????egen odakl?? y??ksek kal??c??l??k varsay??m??)
    Pi_init <- matrix(c(
      0.8, 0.1, 0.1,
      0.1, 0.8, 0.1,
      0.1, 0.1, 0.8
    ), nrow = 3, byrow = TRUE)
    
    delta_init <- c(1/3, 1/3, 1/3)
    
    hmm_obj <- dthmm(x = x_vals, Pi = Pi_init, delta = delta_init, 
                     dist = "norm", pm = list(mean = mean_init, sd = sd_init))
    
    # Baum-Welch optimizasyonu
    fit_hmm <- tryCatch({
      BaumWelch(hmm_obj, control = list(
        tol = 1e-5, maxiter = 100, prt = FALSE, posdiff = FALSE, converge = expression(diff < tol)
      ))
    }, error = function(e) NULL)
    
    if(!is.null(fit_hmm)) {
      sub_data_clean$Regime_3State <- Viterbi(fit_hmm)
      sub_data_clean$Variable <- v
      
      key_name <- paste(prov, v, sep = "_")
      ms_3reg_results_list[[key_name]] <- sub_data_clean
      
      # 3 Rejim i??in Kal???? S??releri (Expected Duration)
      pi_mat <- fit_hmm$Pi
      transition_3reg_summary_list[[key_name]] <- data.frame(
        Province = prov,
        Variable = v,
        State1_Duration_Months = 1 / (1 - pi_mat[1,1]),
        State2_Duration_Months = 1 / (1 - pi_mat[2,2]),
        State3_Duration_Months = 1 / (1 - pi_mat[3,3])
      )
    }
  }
}

final_ms_3reg_df <- bind_rows(ms_3reg_results_list)
transition_3reg_df <- bind_rows(transition_3reg_summary_list)

# Excel Dosyas?? Olarak Kaydetme (??oklu Sekme)
write_xlsx(
  list(
    "Transition_Durations_3State" = transition_3reg_df,
    "Regime_States_3State_TimeSeries" = final_ms_3reg_df
  ), 
  "Markov_Switching_3Regime_Analysis_1990_2025.xlsx"
)

message("3 Rejimli Markov-Switching analizi tamamland?? ve Excel dosyas?? kaydedildi!")

# --- AKADEM??K G??RSELLE??T??RME (T2M_MAX i??in 3 Rejim Paneli) ---
p_ms_3reg <- ggplot(final_ms_3reg_df %>% filter(Variable == "T2M_MAX"), aes(x = date, y = T2M_MAX, color = as.factor(Regime_3State))) +
  geom_point(size = 0.6, alpha = 0.7) +
  facet_wrap(~ province, ncol = 3, scales = "free_y") +
  scale_color_manual(
    values = c("#2b5c8f", "#1b9e77", "#d95f02"), 
    labels = c("State 1 (Cool / Low Regime)", "State 2 (Normal / Transition Regime)", "State 3 (Warm / Extreme Regime)")
  ) +
  labs(
    title = "3-Regime Markov-Switching Model States: Maximum Temperature (1990???2025)",
    subtitle = "Southeastern Anatolia Region (9 Provinces)",
    x = "Years", 
    y = "Maximum Temperature (??C)", 
    color = "3-State Regimes"
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

print(p_ms_3reg)

# Y??ksek ????z??n??rl??kl?? Kay??t (300 DPI)
ggsave("Figure_11_Markov_Switching_3Regime_T2M_MAX.png", plot = p_ms_3reg, width = 12, height = 8.5, dpi = 300)

message("Figure_11_Markov_Switching_3Regime_T2M_MAX.png ba??ar??yla kaydedildi!")