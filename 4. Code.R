library(dplyr)
library(tidyr)
library(HiddenMarkov)
library(ggplot2)
library(writexl)

# 1. Mevsimsellikten ar??nd??rma fonksiyonu
deseasonalize <- function(x) {
  ts_obj <- ts(x, frequency = 12)
  stl_obj <- stl(ts_obj, s.window = "periodic")
  return(as.numeric(x - stl_obj$time.series[, "seasonal"]))
}

# 2. 9 ??l ????in Model B (Ar??nd??r??lm???? Seride HMM) Analizi
hmm_results_list <- list()

for (prov in unique(panel_df$province)) {
  sub_df <- panel_df %>% filter(province == prov)
  
  # Model B: Mevsimsel etkiden ar??nd??r??lm???? maksimum s??cakl??k
  x_deseason <- deseasonalize(sub_df$T2M_MAX)
  
  # HMM Parametreleri
  mean_init <- c(mean(x_deseason) - sd(x_deseason), mean(x_deseason) + sd(x_deseason))
  sd_init   <- c(sd(x_deseason)/2, sd(x_deseason)/2)
  hmm_obj   <- dthmm(x_deseason, Pi = matrix(c(0.9, 0.1, 0.1, 0.9), 2, 2), 
                     delta = c(0.5, 0.5), dist = "norm", 
                     pm = list(mean = mean_init, sd = sd_init))
  
  fit <- BaumWelch(hmm_obj, control = list(
    tol = 1e-5, maxiter = 100, prt = FALSE, posdiff = FALSE, converge = expression(diff < tol)
  ))
  
  sub_df$Deseason_Value <- x_deseason
  sub_df$Climate_Regime <- as.factor(Viterbi(fit))
  hmm_results_list[[prov]] <- sub_df
}

all_hmm_panel <- bind_rows(hmm_results_list)

# Excel ????kt??s??
write_xlsx(all_hmm_panel, "HMM_Model_B_Regimes_All_Provinces.xlsx")

# 3. Uluslararas?? Akademik Standartlarda 9 ??l Panel Grafi??i
p_academic_regimes <- ggplot(all_hmm_panel, aes(x = date, y = Deseason_Value, color = Climate_Regime)) +
  geom_point(size = 0.6, alpha = 0.6) +
  geom_hline(yintercept = mean(all_hmm_panel$Deseason_Value, na.rm = TRUE), 
             linetype = "dashed", color = "gray30", linewidth = 0.5) +
  facet_wrap(~ province, ncol = 3, scales = "free_y") +
  scale_color_manual(
    values = c("#2b5c8f", "#d95f02"), 
    labels = c("State 1 (Normal / Cool Regime)", "State 2 (Anomalous / Warm Regime)")
  ) +
  labs(
    title = "Hidden Markov Model (HMM) Climate Regimes (1990???2025)",
    subtitle = "Deseasonalized Maximum Temperature States Across Southeastern Anatolia",
    x = "Years",
    y = "Deseasonalized Max Temperature Anomaly (??C)",
    color = "Identified Regimes"
  ) +
  theme_bw(base_size = 11) +
  theme(
    plot.title = element_text(face = "bold", size = 14, hjust = 0.5, color = "#1a1a1a"),
    plot.subtitle = element_text(size = 10, hjust = 0.5, color = "gray40"),
    strip.text = element_text(face = "bold", size = 11),
    strip.background = element_rect(fill = "#f2f2f2", color = "black", linewidth = 0.6),
    axis.text = element_text(color = "black"),
    legend.position = "bottom",
    legend.title = element_text(face = "bold", size = 10),
    panel.grid.minor = element_blank(),
    panel.border = element_rect(color = "black", fill = NA, linewidth = 0.7)
  )

print(p_academic_regimes)

# Y??ksek ????z??n??rl??kl?? Kay??t (300 DPI - Makale Kalitesi)
ggsave("Figure_8_HMM_Academic_Regimes_All_Provinces.png", plot = p_academic_regimes, width = 12, height = 8.5, dpi = 300)

message("9 il i??in akademik rejim grafi??i ve Excel raporu ba??ar??yla olu??turuldu!")