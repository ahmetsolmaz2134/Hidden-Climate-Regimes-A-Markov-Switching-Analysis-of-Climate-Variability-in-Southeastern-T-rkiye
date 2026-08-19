library(dplyr)
library(tidyr)
library(HiddenMarkov)
library(writexl)
library(ggplot2)

vars_to_model <- c("T2M_MAX", "T2M_MIN", "PRECTOTCORR", "RH2M")
transition_matrix_list <- list()
transition_summary_list <- list()

message("9 il ve 4 de??i??ken i??in Markov Ge??i?? Olas??l??k Matrisleri hesaplan??yor...")

for (prov in unique(panel_df$province)) {
  for (v in vars_to_model) {
    
    sub_data <- panel_df %>% filter(province == prov)
    x_vals <- sub_data[[v]]
    
    if(any(is.na(x_vals))) {
      x_vals <- na.omit(x_vals)
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
      estimated_means <- fit$pm$mean
      mean_order <- order(estimated_means)
      
      # Ge??i?? matrisini ampirik ortalamalara g??re yeniden s??ralama (R1, R2, R3)
      sorted_pi <- fit$Pi[mean_order, mean_order]
      
      # 1. Detayl?? Matris Tablosu Verisi
      mat_df <- data.frame(
        Province = prov,
        Variable = v,
        From_Regime = rep(c("R1 (Low)", "R2 (Normal)", "R3 (High)"), each = 3),
        To_Regime   = rep(c("R1 (Low)", "R2 (Normal)", "R3 (High)"), times = 3),
        Probability = as.vector(sorted_pi)
      )
      transition_matrix_list[[paste(prov, v, sep = "_")]] <- mat_df
      
      # 2. ??zet Metrikler ve Ortalama Kal???? S??releri (Ayl??k)
      transition_summary_list[[paste(prov, v, sep = "_")]] <- data.frame(
        Province = prov,
        Variable = v,
        P_11 = sorted_pi[1,1], P_12 = sorted_pi[1,2], P_13 = sorted_pi[1,3],
        P_21 = sorted_pi[2,1], P_22 = sorted_pi[2,2], P_23 = sorted_pi[2,3],
        P_31 = sorted_pi[3,1], P_32 = sorted_pi[3,2], P_33 = sorted_pi[3,3],
        Duration_R1_Months = 1 / (1 - sorted_pi[1,1]),
        Duration_R2_Months = 1 / (1 - sorted_pi[2,2]),
        Duration_R3_Months = 1 / (1 - sorted_pi[3,3])
      )
    }
  }
}

final_matrix_df <- bind_rows(transition_matrix_list)
final_summary_df <- bind_rows(transition_summary_list)

# Excel ????kt??s?? (9 ilin t??m ge??i?? matrisleri ve kal???? s??releri)
write_xlsx(
  list(
    "Transition_Probabilities_Matrix" = final_matrix_df,
    "Transition_Summary_Durations"   = final_summary_df
  ),
  "Markov_Switching_Transition_Matrices_All_Provinces.xlsx"
)

message("T??m iller i??in ge??i?? matrisleri hesapland?? ve Excel dosyas?? kaydedildi!")

# --- AKADEM??K G??RSELLE??T??RME: 9 ??lin Tamam?? ????in Is?? Haritas?? Paneli (T2M_MAX) ---
heatmap_all_data <- final_matrix_df %>% filter(Variable == "T2M_MAX")

p_heatmap_all <- ggplot(heatmap_all_data, aes(x = To_Regime, y = From_Regime, fill = Probability)) +
  geom_tile(color = "white", linewidth = 0.6) +
  geom_text(aes(label = sprintf("%.2f", Probability)), color = "black", fontface = "bold", size = 3) +
  facet_wrap(~ Province, ncol = 3) +
  scale_fill_gradient(low = "#edf8fb", high = "#2b5c8f", limits = c(0, 1)) +
  labs(
    title = "Markov Transition Probability Matrix Heatmaps: Maximum Temperature (All Provinces)",
    subtitle = "Comparative regime transition dynamics across 9 provinces (1990???2025)",
    x = "To Regime (Next Month)",
    y = "From Regime (Current Month)",
    fill = "Probability"
  ) +
  theme_bw(base_size = 11) +
  theme(
    plot.title = element_text(face = "bold", size = 12, hjust = 0.5),
    plot.subtitle = element_text(size = 9, hjust = 0.5, color = "gray40"),
    strip.text = element_text(face = "bold", size = 10),
    strip.background = element_rect(fill = "#f2f2f2", color = "black", linewidth = 0.6),
    axis.text.x = element_text(angle = 25, hjust = 1, size = 8, color = "black"),
    axis.text.y = element_text(size = 8, color = "black"),
    panel.grid = element_blank(),
    legend.position = "right"
  )

print(p_heatmap_all)
ggsave("Figure_18_Transition_Matrix_Heatmap_All_Provinces.png", plot = p_heatmap_all, width = 12, height = 9, dpi = 300)
message("Figure_18_Transition_Matrix_Heatmap_All_Provinces.png ba??ar??yla kaydedildi!")