library(dplyr)
library(tidyr)
library(HiddenMarkov)
library(writexl)
library(ggplot2)

# Analiz edilecek de??i??kenler
vars_to_model <- c("T2M_MAX", "T2M_MIN", "PRECTOTCORR", "RH2M")
ms_results_list <- list()
transition_summary_list <- list()

message("9 il ve 4 de??i??ken i??in 2 rejimli Markov-Switching modelleri kuruluyor...")

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
    
    # Ba??lang???? parametreleri (2 rejimli yap?? i??in)
    mean_init <- c(mean(x_vals) - sd(x_vals), mean(x_vals) + sd(x_vals))
    sd_init   <- c(sd(x_vals)/2, sd(x_vals)/2)
    Pi_init   <- matrix(c(0.9, 0.1, 0.1, 0.9), nrow = 2, byrow = TRUE)
    delta_init <- c(0.5, 0.5)
    
    hmm_obj <- dthmm(x = x_vals, Pi = Pi_init, delta = delta_init, 
                     dist = "norm", pm = list(mean = mean_init, sd = sd_init))
    
    # Baum-Welch algoritmas?? ile rejim optimizasyonu
    fit_hmm <- tryCatch({
      BaumWelch(hmm_obj, control = list(
        tol = 1e-5, maxiter = 100, prt = FALSE, posdiff = FALSE, converge = expression(diff < tol)
      ))
    }, error = function(e) NULL)
    
    if(!is.null(fit_hmm)) {
      sub_data_clean$Regime <- Viterbi(fit_hmm)
      sub_data_clean$Variable <- v
      
      key_name <- paste(prov, v, sep = "_")
      ms_results_list[[key_name]] <- sub_data_clean
      
      # Ge??i?? Olas??l??klar?? Matrisi ve Rejimde Kal???? S??releri (Expected Duration)
      pi_mat <- fit_hmm$Pi
      transition_summary_list[[key_name]] <- data.frame(
        Province = prov,
        Variable = v,
        P11 = pi_mat[1,1], # Rejim 1'de kalma olas??l??????
        P12 = pi_mat[1,2], # Rejim 1'den Rejim 2'ye ge??i??
        P21 = pi_mat[2,1], # Rejim 2'den Rejim 1'e ge??i??
        P22 = pi_mat[2,2], # Rejim 2'de kalma olas??l?????? (S??reklilik / Persistence)
        Expected_Duration_State1_Months = 1 / (1 - pi_mat[1,1]),
        Expected_Duration_State2_Months = 1 / (1 - pi_mat[2,2])
      )
    }
  }
}

final_ms_df <- bind_rows(ms_results_list)
transition_df <- bind_rows(transition_summary_list)

# Excel Dosyas?? Olarak Kaydetme (??oklu Sekme / Sheets)
write_xlsx(
  list(
    "Transition_Probabilities" = transition_df,
    "Regime_States_TimeSeries" = final_ms_df
  ), 
  "Markov_Switching_2Regime_Analysis_1990_2025.xlsx"
)

message("Markov-Switching analizleri tamamland?? ve Excel raporu olu??turuldu!")

# --- AKADEM??K G??RSELLE??T??RME (T2M_MAX i??in 9 ??l Rejim Da????l??m??) ---
p_ms_t2m <- ggplot(final_ms_df %>% filter(Variable == "T2M_MAX"), aes(x = date, y = T2M_MAX, color = as.factor(Regime))) +
  geom_point(size = 0.6, alpha = 0.7) +
  facet_wrap(~ province, ncol = 3, scales = "free_y") +
  scale_color_manual(
    values = c("#2b5c8f", "#d95f02"), 
    labels = c("State 1 (Normal / Cool Regime)", "State 2 (Anomalous / Warm Regime)")
  ) +
  labs(
    title = "2-Regime Markov-Switching Model States: Maximum Temperature (1990???2025)",
    subtitle = "Southeastern Anatolia Region (9 Provinces)",
    x = "Years", 
    y = "Maximum Temperature (??C)", 
    color = "Markov Regimes"
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

print(p_ms_t2m)

# Y??ksek ????z??n??rl??kl?? Kay??t (300 DPI)
ggsave("Figure_10_Markov_Switching_T2M_MAX.png", plot = p_ms_t2m, width = 12, height = 8.5, dpi = 300)

message("Figure_10_Markov_Switching_T2M_MAX.png ba??ar??yla kaydedildi!")