library(dplyr)
library(tidyr)
library(HiddenMarkov)
library(writexl)
library(ggplot2)

vars_to_model <- c("T2M_MAX", "T2M_MIN", "PRECTOTCORR", "RH2M")
duration_results_list <- list()

message("9 il ve 4 de??i??ken i??in rejim kal??c??l?????? ve beklenen s??reler hesaplan??yor...")

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
      
      # Matrisi s??ralama (R1, R2, R3)
      sorted_pi <- fit$Pi[mean_order, mean_order]
      
      # K????egen olas??l??klar (p11, p22, p33)
      p11 <- sorted_pi[1,1]
      p22 <- sorted_pi[2,2]
      p33 <- sorted_pi[3,3]
      
      # Beklenen s??reler (Ayl??k cinsinden: Di = 1 / (1 - pii))
      d1 <- 1 / (1 - p11)
      d2 <- 1 / (1 - p22)
      d3 <- 1 / (1 - p33)
      
      dur_df <- data.frame(
        Province = prov,
        Variable = v,
        Regime   = c("R1 (Low)", "R2 (Normal)", "R3 (High)"),
        P_ii     = c(p11, p22, p33),
        Expected_Duration_Months = c(d1, d2, d3)
      )
      
      duration_results_list[[paste(prov, v, sep = "_")]] <- dur_df
    }
  }
}

final_duration_df <- bind_rows(duration_results_list)

# Excel ????kt??s?? (T??m illerin rejim kal??c??l??k ve s??re tablosu)
write_xlsx(
  list("Regime_Expected_Durations" = final_duration_df),
  "Markov_Switching_Expected_Durations_All_Provinces.xlsx"
)

message("T??m iller i??in rejim kal??c??l??k s??releri hesapland?? ve Excel dosyas?? kaydedildi!")

# --- AKADEM??K G??RSELLE??T??RME: 9 ??lin Tamam?? ????in Beklenen S??reler (T2M_MAX) ---
duration_plot_data <- final_duration_df %>% filter(Variable == "T2M_MAX")

p_dur <- ggplot(duration_plot_data, aes(x = Province, y = Expected_Duration_Months, fill = Regime)) +
  geom_bar(stat = "identity", position = "dodge", color = "black", linewidth = 0.4) +
  scale_fill_manual(
    values = c("#2b5c8f", "#1b9e77", "#d95f02"),
    labels = c("R1: Low Regime", "R2: Normal Regime", "R3: High Regime")
  ) +
  labs(
    title = "Expected Duration of Climatic Regimes in Months: Maximum Temperature",
    subtitle = "Persistence analysis of environmental states across all 9 provinces (1990???2025)",
    x = "Provinces",
    y = "Expected Duration (Months)",
    fill = "Regime Categories"
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

print(p_dur)
ggsave("Figure_19_Expected_Durations_All_Provinces.png", plot = p_dur, width = 11, height = 6.5, dpi = 300)
message("Figure_19_Expected_Durations_All_Provinces.png ba??ar??yla kaydedildi!")