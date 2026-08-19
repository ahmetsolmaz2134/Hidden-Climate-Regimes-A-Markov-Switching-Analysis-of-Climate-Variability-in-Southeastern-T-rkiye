library(ggplot2)
library(dplyr)
library(tidyr)

# 1. ACF ve PACF verilerini uzun formata ??evirme ve hesaplama
all_acf_pacf <- data.frame()

for (prov in unique(panel_df$province)) {
  x <- panel_df %>% filter(province == prov) %>% pull(T2M_MAX) %>% na.omit()
  
  # ACF ve PACF hesaplamalar??
  acf_obj <- acf(x, lag.max = 24, plot = FALSE)
  pacf_obj <- pacf(x, lag.max = 24, plot = FALSE)
  
  temp_df <- data.frame(
    Province = prov,
    Lag = 1:24,
    ACF = as.numeric(acf_obj$acf[-1]),
    PACF = as.numeric(pacf_obj$acf)
  )
  all_acf_pacf <- rbind(all_acf_pacf, temp_df)
}

# 2. ACF Tekli Panel Grafik (T??m ??ller)
p_acf_all <- ggplot(all_acf_pacf, aes(x = Lag, y = ACF)) +
  geom_hline(yintercept = 0, linetype = "solid", color = "black") +
  geom_segment(aes(xend = Lag, yend = 0), color = "#2b5c8f", linewidth = 1.2) +
  geom_hline(yintercept = c(0.1, -0.1), linetype = "dashed", color = "red", alpha = 0.5) + # G??ven aral??????
  facet_wrap(~ Province, ncol = 3) +
  labs(title = "Comparative Autocorrelation Function (ACF) - T2M_MAX",
       subtitle = "Memory structure of max temperature (1990???2025)",
       x = "Lag (Months)", y = "ACF Coefficient") +
  theme_bw(base_size = 12) +
  theme(plot.title = element_text(face = "bold", hjust = 0.5),
        strip.text = element_text(face = "bold"))

ggsave("Figure_6_ACF_All_Provinces.png", plot = p_acf_all, width = 12, height = 9, dpi = 300)

# 3. PACF Tekli Panel Grafik (T??m ??ller)
p_pacf_all <- ggplot(all_acf_pacf, aes(x = Lag, y = PACF)) +
  geom_hline(yintercept = 0, linetype = "solid", color = "black") +
  geom_segment(aes(xend = Lag, yend = 0), color = "#d95f02", linewidth = 1.2) +
  geom_hline(yintercept = c(0.1, -0.1), linetype = "dashed", color = "red", alpha = 0.5) +
  facet_wrap(~ Province, ncol = 3) +
  labs(title = "Comparative Partial Autocorrelation Function (PACF) - T2M_MAX",
       subtitle = "Direct lag dependencies of max temperature (1990???2025)",
       x = "Lag (Months)", y = "PACF Coefficient") +
  theme_bw(base_size = 12) +
  theme(plot.title = element_text(face = "bold", hjust = 0.5),
        strip.text = element_text(face = "bold"))

ggsave("Figure_7_PACF_All_Provinces.png", plot = p_pacf_all, width = 12, height = 9, dpi = 300)

message("T??m illerin ACF ve PACF analizleri tek panel grafikte birle??tirildi ve kaydedildi!")