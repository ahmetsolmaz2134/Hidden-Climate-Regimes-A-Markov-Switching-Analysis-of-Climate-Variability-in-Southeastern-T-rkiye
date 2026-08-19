library(dplyr)
library(tidyr)
library(ggplot2)
library(writexl)

# 1. Her ilin kendi iklimsel da????l??m??na g??re Z-skoru ile standardize edilmesi
standardized_df <- panel_df %>%
  group_by(province) %>%
  mutate(
    T2M_MAX_Std = (T2M_MAX - mean(T2M_MAX, na.rm = TRUE)) / sd(T2M_MAX, na.rm = TRUE),
    T2M_MIN_Std = (T2M_MIN - mean(T2M_MIN, na.rm = TRUE)) / sd(T2M_MIN, na.rm = TRUE),
    PRECTOT_Std = (PRECTOTCORR - mean(PRECTOTCORR, na.rm = TRUE)) / sd(PRECTOTCORR, na.rm = TRUE),
    RH2M_Std    = (RH2M - mean(RH2M, na.rm = TRUE)) / sd(RH2M, na.rm = TRUE)
  ) %>%
  ungroup()

# 2. Excel ????kt??s?? Alma (Standardize Edilmi?? Panel Verisi)
write_xlsx(standardized_df, "Standardized_Climate_Panel_1990_2025.xlsx")

# 3. Akademik G??rselle??tirme: Standardize Edilmi?? Maksimum S??cakl??k Anomalileri (9 ??l)
p_std_timeseries <- ggplot(standardized_df, aes(x = date, y = T2M_MAX_Std)) +
  # Ortalama ??izgisi (0) ve %95 g??ven aral?????? e??ikleri (??1.96)
  geom_hline(yintercept = 0, linetype = "dashed", color = "black", linewidth = 0.5) +
  geom_hline(yintercept = c(1.96, -1.96), linetype = "dotted", color = "red", linewidth = 0.6) +
  geom_line(color = "#2b5c8f", linewidth = 0.35, alpha = 0.8) +
  geom_smooth(method = "loess", color = "#d95f02", se = FALSE, linewidth = 0.9) +
  facet_wrap(~ province, ncol = 3, scales = "free_y") +
  labs(
    title = "Standardized Maximum Temperature Anomalies (1990???2025)",
    subtitle = "Z-Score Transformation by Province (Red dotted lines indicate ??1.96 significance threshold)",
    x = "Years",
    y = "Standardized Anomaly (Z-Score)"
  ) +
  theme_bw(base_size = 11) +
  theme(
    plot.title = element_text(face = "bold", size = 13, hjust = 0.5, color = "#1a1a1a"),
    plot.subtitle = element_text(size = 9.5, hjust = 0.5, color = "gray40"),
    strip.text = element_text(face = "bold", size = 10),
    strip.background = element_rect(fill = "#f2f2f2", color = "black", linewidth = 0.6),
    axis.text = element_text(color = "black"),
    panel.grid.minor = element_blank(),
    panel.border = element_rect(color = "black", fill = NA, linewidth = 0.7)
  )

print(p_std_timeseries)

# 4. Y??ksek ????z??n??rl??kl?? Kay??t (300 DPI - Makale Kalitesi)
ggsave("Figure_9_Standardized_Anomalies_All_Provinces.png", plot = p_std_timeseries, width = 12, height = 8.5, dpi = 300)

message("Standardizasyon analizi ba??ar??yla tamamland??, Excel dosyas?? ve 'Figure_9' kaydedildi!")