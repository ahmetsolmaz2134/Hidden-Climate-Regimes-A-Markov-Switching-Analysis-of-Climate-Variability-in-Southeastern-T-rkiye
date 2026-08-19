library(dplyr)
library(tidyr)
library(HiddenMarkov)
library(writexl)
library(ggplot2)

vars_to_model <- c("T2M_MAX", "T2M_MIN", "PRECTOTCORR", "RH2M")
regime_params_list <- list()

message("Se??ilen modeller ??zerinden rejim istatistikleri (Ortalama, SS, Varyans, G??ven Aral??????) ????kar??l??yor...")

for (prov in unique(panel_df$province)) {
  for (v in vars_to_model) {
    
    sub_data <- panel_df %>% filter(province == prov)
    x_vals <- sub_data[[v]]
    
    if(any(is.na(x_vals))) {
      x_vals <- na.omit(x_vals)
    }
    if(length(x_vals) < 40) next 
    
    # Burada varsay??lan olarak en stabil sonu?? veren 3 Rejimli yap??y?? baz al??yoruz 
    # (Dilerseniz ??nceki ad??mda se??ilen optimal K de??erini de buraya dinamik ba??layabilirsiniz)
    k <- 3 
    
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
      estimated_sds   <- fit$pm$sd
      
      # Rejimleri ortalamalar??na g??re s??ralama (1 = Low, 2 = Normal, 3 = High)
      mean_order <- order(estimated_means)
      
      sorted_means <- estimated_means[mean_order]
      sorted_sds   <- estimated_sds[mean_order]
      
      # Her rejimdeki g??zlem say??lar?? (N) ??zerinden %95 G??ven Aral?????? hesab??
      sub_data_clean <- sub_data %>% mutate(Raw_State = raw_states, Sorted_State = match(raw_states, mean_order))
      
      for (i in 1:k) {
        regime_data <- sub_data_clean %>% filter(Sorted_State == i) %>% pull(all_of(v))
        n_i <- length(regime_data)
        mean_i <- sorted_means[i]
        sd_i   <- sorted_sds[i]
        var_i  <- sd_i^2
        
        # %95 G??ven Aral?????? (z = 1.96)
        se_i <- sd_i / sqrt(max(n_i, 1))
        ci_lower <- mean_i - 1.96 * se_i
        ci_upper <- mean_i + 1.96 * se_i
        
        regime_name <- switch(i, "1" = "R1 (Low)", "2" = "R2 (Normal)", "3" = "R3 (High)", "4" = "R4 (Extreme)")
        
        regime_params_list[[paste(prov, v, regime_name, sep = "_")]] <- data.frame(
          Province       = prov,
          Variable       = v,
          Regime         = regime_name,
          N_Observations = n_i,
          Mean           = mean_i,
          Std_Dev        = sd_i,
          Variance       = var_i,
          CI_95_Lower    = ci_lower,
          CI_95_Upper    = ci_upper
        )
      }
    }
  }
}

regime_params_df <- bind_rows(regime_params_list)

# Excel ????kt??s??
write_xlsx(
  list("Regime_Statistical_Parameters" = regime_params_df),
  "Markov_Switching_Regime_Statistics.xlsx"
)

message("Rejim parametreleri ????kar??ld?? ve 'Markov_Switching_Regime_Statistics.xlsx' kaydedildi!")

# --- AKADEM??K G??RSELLE??T??RME: Rejim Ortalama ve G??ven Aral??klar?? (T2M_MAX i??in) ---
p_params <- ggplot(regime_params_df %>% filter(Variable == "T2M_MAX"), aes(x = Regime, y = Mean, color = Regime)) +
  geom_point(size = 3.5) +
  geom_errorbar(aes(ymin = CI_95_Lower, ymax = CI_95_Upper), width = 0.2, linewidth = 0.8) +
  facet_wrap(~ Province, ncol = 3, scales = "free_y") +
  scale_color_manual(values = c("#2b5c8f", "#1b9e77", "#d95f02")) +
  labs(
    title = "Estimated Regime Means and 95% Confidence Intervals: Maximum Temperature",
    subtitle = "Physical characterization of environmental regimes across provinces",
    x = "Regimes",
    y = "Mean Maximum Temperature (??C)",
    color = "Regimes"
  ) +
  theme_bw(base_size = 11) +
  theme(
    plot.title = element_text(face = "bold", size = 13, hjust = 0.5),
    plot.subtitle = element_text(size = 9.5, hjust = 0.5, color = "gray40"),
    strip.text = element_text(face = "bold", size = 10),
    strip.background = element_rect(fill = "#f2f2f2", color = "black", linewidth = 0.6),
    axis.text.x = element_text(face = "bold", angle = 20, hjust = 1),
    axis.text = element_text(color = "black"),
    legend.position = "none",
    panel.grid.minor = element_blank()
  )

print(p_params)
ggsave("Figure_15_Regime_Means_Confidence_Intervals.png", plot = p_params, width = 12, height = 8.5, dpi = 300)
message("Figure_15_Regime_Means_Confidence_Intervals.png ba??ar??yla kaydedildi!")