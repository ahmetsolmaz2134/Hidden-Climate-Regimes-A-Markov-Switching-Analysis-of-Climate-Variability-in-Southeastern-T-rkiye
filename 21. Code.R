library(dplyr)
library(tidyr)
library(writexl)
library(ggplot2)

# 1. 4 de??i??ken i??in de kritik/a????r?? rejim e??iklerini global olarak belirleyelim
tmax_thresh <- quantile(panel_df$T2M_MAX, 0.66, na.rm = TRUE)
tmin_thresh <- quantile(panel_df$T2M_MIN, 0.66, na.rm = TRUE)
precip_low_thresh <- quantile(panel_df$PRECTOTCORR, 0.33, na.rm = TRUE)
rh_low_thresh <- quantile(panel_df$RH2M, 0.33, na.rm = TRUE)

# 2. Her il i??in her bir rejimin y??zde frekans??n?? hesaplayal??m
multi_var_comparison <- panel_df %>%
  group_by(province) %>%
  summarise(
    High_Tmax_Freq = mean(T2M_MAX >= tmax_thresh, na.rm = TRUE) * 100,
    High_Tmin_Freq = mean(T2M_MIN >= tmin_thresh, na.rm = TRUE) * 100,
    Low_Precip_Freq = mean(PRECTOTCORR <= precip_low_thresh, na.rm = TRUE) * 100,
    Low_Humidity_Freq = mean(RH2M <= rh_low_thresh, na.rm = TRUE) * 100,
    .groups = 'drop'
  )

# 3. Grafi??e uygun olmas?? i??in veriyi 'long' forma ??evirelim
multi_var_long <- multi_var_comparison %>%
  pivot_longer(
    cols = ends_with("_Freq"),
    names_to = "Regime_Type",
    values_to = "Percentage"
  ) %>%
  mutate(Regime_Type = case_when(
    Regime_Type == "High_Tmax_Freq" ~ "High Tmax (Hot Regime)",
    Regime_Type == "High_Tmin_Freq" ~ "High Tmin (Warm Night)",
    Regime_Type == "Low_Precip_Freq" ~ "Low Precipitation (Dry)",
    Regime_Type == "Low_Humidity_Freq" ~ "Low Humidity (Arid)"
  ))

# Excel ????kt??s??
write_xlsx(list("Multi_Variable_Regime_Comparison" = multi_var_comparison), "Analysis_22_Multi_Variable_Comparison.xlsx")

# 4. 4'l?? Kar????la??t??rma Grafi??i (Grouped Bar Chart)
p_multi <- ggplot(multi_var_long, aes(x = province, y = Percentage, fill = Regime_Type)) +
  geom_bar(stat = "identity", position = position_dodge(width = 0.8), width = 0.7, color = "black") +
  scale_fill_manual(values = c(
    "High Tmax (Hot Regime)" = "#d73027",
    "High Tmin (Warm Night)" = "#fc8d59",
    "Low Precipitation (Dry)" = "#fee08b",
    "Low Humidity (Arid)" = "#4575b4"
  )) +
  labs(
    title = "Multi-Variable Regime Comparison Across 9 Provinces",
    subtitle = "Comparative frequency of extreme thermal, precipitation, and humidity states (1990???2025)",
    x = "Provinces",
    y = "Frequency / Occurrence (%)",
    fill = "Regime Type"
  ) +
  theme_bw(base_size = 12) +
  theme(
    plot.title = element_text(face = "bold", size = 13),
    axis.text.x = element_text(angle = 35, hjust = 1, face = "bold", color = "black"),
    legend.position = "bottom",
    legend.title = element_blank()
  )

print(p_multi)
ggsave("Figure_28_Multi_Variable_Regime_Comparison.png", plot = p_multi, width = 12, height = 7, dpi = 300)
message("Analiz 22 (4'l?? Kar????la??t??rma) ba??ar??yla d??zeltildi ve Figure 28 kaydedildi!")