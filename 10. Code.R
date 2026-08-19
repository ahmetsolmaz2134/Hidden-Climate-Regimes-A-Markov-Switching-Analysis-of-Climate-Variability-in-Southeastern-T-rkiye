library(dplyr)
library(tidyr)
library(HiddenMarkov)
library(writexl)
library(ggplot2)

vars_to_model <- c("T2M_MAX", "T2M_MIN", "PRECTOTCORR", "RH2M")
model_selection_list <- list()

message("9 il ve 4 de??i??ken i??in 2, 3 ve 4 rejimli modellerin AIC, BIC ve Log-Likelihood kar????la??t??rmas?? yap??l??yor...")

for (prov in unique(panel_df$province)) {
  for (v in vars_to_model) {
    
    sub_data <- panel_df %>% filter(province == prov)
    x_vals <- sub_data[[v]]
    
    if(any(is.na(x_vals))) {
      x_vals <- na.omit(x_vals)
    }
    if(length(x_vals) < 40) next 
    
    n_obs <- length(x_vals)
    
    # Yard??mc?? HMM fitting fonksiyonu (K rejimli)
    fit_k_regime <- function(k) {
      set.seed(123)
      # Rejim say??s??na g??re ba??lang???? ortalamalar??
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
      
      if(is.null(fit)) return(NULL)
      
      # Log-Likelihood hesaplama (HiddenMarkov logL genellikle fit nesnesindedir veya hesaplan??r)
      # Alternatif olarak normal da????l??m yo??unluklar??ndan logL t??retilir:
      ll <- fit$logL
      if(is.null(ll) || is.na(ll)) {
        # Yakla????k logL hesab??
        ll <- sum(dnorm(x_vals, mean = fit$pm$mean[Viterbi(fit)], sd = fit$pm$sd[Viterbi(fit)], log = TRUE))
      }
      
      # Serbest parametre say??s?? (K*(K-1) ge??i?? + K ortalama + K varyans)
      num_params <- (k * (k - 1)) + (2 * k)
      
      # AIC ve BIC form??lleri
      aic_val <- -2 * ll + 2 * num_params
      bic_val <- -2 * ll + log(n_obs) * num_params
      
      return(list(logLik = ll, AIC = aic_val, BIC = bic_val, fit = fit))
    }
    
    # 2, 3 ve 4 Rejimli Modelleri ??al????t??rma
    res2 <- fit_k_regime(2)
    res3 <- fit_k_regime(3)
    res4 <- fit_k_regime(4)
    
    # Sonu??lar?? toplama ve BIC'ye g??re en iyiyi se??me
    bic_vals <- c(
      `2-Regime` = ifelse(!is.null(res2), res2$BIC, NA),
      `3-Regime` = ifelse(!is.null(res3), res3$BIC, NA),
      `4-Regime` = ifelse(!is.null(res4), res4$BIC, NA)
    )
    
    if(all(is.na(bic_vals))) next
    
    best_model_name <- names(bic_vals)[which.min(bic_vals)]
    
    model_selection_list[[paste(prov, v, sep = "_")]] <- data.frame(
      Province       = prov,
      Variable       = v,
      LL_2Regime     = ifelse(!is.null(res2), res2$logLik, NA),
      AIC_2Regime    = ifelse(!is.null(res2), res2$AIC, NA),
      BIC_2Regime    = ifelse(!is.null(res2), res2$BIC, NA),
      LL_3Regime     = ifelse(!is.null(res3), res3$logLik, NA),
      AIC_3Regime    = ifelse(!is.null(res3), res3$AIC, NA),
      BIC_3Regime    = ifelse(!is.null(res3), res3$BIC, NA),
      LL_4Regime     = ifelse(!is.null(res4), res4$logLik, NA),
      AIC_4Regime    = ifelse(!is.null(res4), res4$AIC, NA),
      BIC_4Regime    = ifelse(!is.null(res4), res4$BIC, NA),
      Selected_Model = best_model_name
    )
  }
}

model_selection_df <- bind_rows(model_selection_list)

# Excel Raporu Kayd??
write_xlsx(
  list("Model_Selection_Criteria" = model_selection_df),
  "Markov_Model_Selection_AIC_BIC.xlsx"
)

message("Model se??imi analizi tamamland?? ve 'Markov_Model_Selection_AIC_BIC.xlsx' kaydedildi!")

# --- AKADEM??K G??RSELLE??T??RME: BIC Kar????la??t??rma Grafi??i (T2M_MAX i??in) ---
bic_plot_data <- model_selection_df %>% 
  filter(Variable == "T2M_MAX") %>%
  select(Province, BIC_2Regime, BIC_3Regime, BIC_4Regime) %>%
  pivot_longer(cols = starts_with("BIC"), names_to = "Model", values_to = "BIC_Value")

p_bic <- ggplot(bic_plot_data, aes(x = Province, y = BIC_Value, fill = Model)) +
  geom_col(position = "dodge", alpha = 0.85, width = 0.7) +
  scale_fill_manual(
    values = c("#2b5c8f", "#1b9e77", "#d95f02"),
    labels = c("2-Regime BIC", "3-Regime BIC", "4-Regime BIC")
  ) +
  labs(
    title = "Bayesian Information Criterion (BIC) Comparison across Provinces",
    subtitle = "Lower BIC indicates the statistically optimal regime model for Maximum Temperature",
    x = "Provinces",
    y = "BIC Score",
    fill = "Models"
  ) +
  theme_bw(base_size = 11) +
  theme(
    plot.title = element_text(face = "bold", size = 13, hjust = 0.5),
    plot.subtitle = element_text(size = 9.5, hjust = 0.5, color = "gray40"),
    axis.text.x = element_text(angle = 30, hjust = 1, face = "bold"),
    legend.position = "bottom",
    panel.grid.minor = element_blank()
  )

print(p_bic)
ggsave("Figure_14_BIC_Model_Selection.png", plot = p_bic, width = 11, height = 6.5, dpi = 300)
message("Figure_14_BIC_Model_Selection.png ba??ar??yla kaydedildi!")