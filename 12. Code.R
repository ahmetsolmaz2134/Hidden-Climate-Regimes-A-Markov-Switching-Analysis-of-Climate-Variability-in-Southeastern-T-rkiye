library(dplyr)
library(tidyr)
library(HiddenMarkov)
library(writexl)
library(ggplot2)

vars_to_model <- c("T2M_MAX", "T2M_MIN", "PRECTOTCORR", "RH2M")
probs_results_list <- list()

message("9 il ve 4 de??i??ken i??in filtrelenmi?? ve yumu??at??lm???? rejim olas??l??klar?? hesaplan??yor...")

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
      fb <- Estep(fit$x, fit$Pi, fit$delta, fit$distn, fit$pm)
      prob_matrix <- fb$u # Rejim olas??l??klar?? matrisi (N x K)
      
      estimated_means <- fit$pm$mean
      mean_order <- order(estimated_means)
      
      # Olas??l??klar?? ampirik rejim s??ras??na (1=Low, 2=Normal, 3=High) g??re d??zenleme
      ordered_probs <- prob_matrix[, mean_order]
      
      sub_data_clean$Prob_Low    <- ordered_probs[, 1]
      sub_data_clean$Prob_Normal <- ordered_probs[, 2]
      sub_data_clean$Prob_High   <- ordered_probs[, 3]
      sub_data_clean$Variable    <- v
      
      probs_results_list[[paste(prov, v, sep = "_")]] <- sub_data_clean
    }
  }
}

final_probs_df <- bind_rows(probs_results_list)

# Excel ????kt??s?? (9 ilin tamam??n??n rejim olas??l??klar??)
write_xlsx(
  list("Regime_Probabilities_TimeSeries" = final_probs_df),
  "Markov_Switching_Regime_Probabilities_All_Provinces.xlsx"
)

message("T??m illerin rejim olas??l??klar?? hesapland?? ve Excel dosyas?? kaydedildi!")

# --- AKADEM??K G??RSELLE??T??RME: 9 ??lin Tamam?? ????in Olas??l??k Paneli (T2M_MAX) ---
all_prov_plot_data <- final_probs_df %>%
  filter(Variable == "T2M_MAX") %>%
  select(province, date, Prob_Low, Prob_Normal, Prob_High) %>%
  pivot_longer(cols = starts_with("Prob_"), names_to = "Regime", values_to = "Probability")

p_probs_all <- ggplot(all_prov_plot_data, aes(x = date, y = Probability, fill = Regime)) +
  geom_area(position = "stack", alpha = 0.85) +
  facet_wrap(~ province, ncol = 3, scales = "free_x") +
  scale_fill_manual(
    values = c("#2b5c8f", "#1b9e77", "#d95f02"),
    labels = c("P(Low Regime)", "P(Normal Regime)", "P(High Regime)")
  ) +
  labs(
    title = "Smoothed Regime Probabilities over Time: Maximum Temperature (All Provinces)",
    subtitle = "Comparative temporal evolution of regime assignment certainty (1990???2025)",
    x = "Years",
    y = "Posterior Probability",
    fill = "Regime Probabilities"
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

print(p_probs_all)
ggsave("Figure_16_Regime_Probabilities_All_Provinces.png", plot = p_probs_all, width = 12, height = 8.5, dpi = 300)
message("Figure_16_Regime_Probabilities_All_Provinces.png ba??ar??yla kaydedildi!")