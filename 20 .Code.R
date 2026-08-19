library(dplyr)
library(writexl)
library(ggplot2)

# 1. T??m b??lgenin ortak (global) d??????k ve y??ksek ba????l nem e??iklerini belirleyelim
global_low_rh <- quantile(panel_df$RH2M, 0.33, na.rm = TRUE)
global_high_rh <- quantile(panel_df$RH2M, 0.66, na.rm = TRUE)

# 2. Ortak e??iklere g??re t??m veri setini s??n??fland??ral??m
humidity_analysis <- panel_df %>%
  mutate(
    Humidity_Regime = case_when(
      RH2M <= global_low_rh ~ "Low Humidity",
      RH2M > global_low_rh & RH2M <= global_high_rh ~ "Normal Humidity",
      RH2M > global_high_rh ~ "High Humidity"
    )
  )

# 3. ??llere g??re y??zdelik da????l??mlar?? hesaplayal??m
humidity_summary <- humidity_analysis %>%
  group_by(province, Humidity_Regime) %>%
  summarise(Count = n(), .groups = 'drop') %>%
  group_by(province) %>%
  mutate(Percentage = (Count / sum(Count)) * 100)

# Excel ????kt??s??
write_xlsx(list("Global_Humidity_Regimes" = humidity_summary), "Analysis_21_Global_Humidity_Regimes.xlsx")

# 4. Akademik G??rselle??tirme (Ba????l Nem Rejimleri Da????l??m??)
p_humidity <- ggplot(humidity_summary, aes(x = province, y = Percentage, fill = Humidity_Regime)) +
  geom_bar(stat = "identity", position = "stack", color = "black", width = 0.7) +
  scale_fill_manual(values = c("Low Humidity" = "#d95f02", 
                               "Normal Humidity" = "#fee08b", 
                               "High Humidity" = "#2b83ba")) +
  labs(
    title = "Regional Distribution of Relative Humidity Regimes (Global Thresholds)",
    subtitle = "Comparative analysis of RH2M states across 9 provinces (1990???2025)",
    x = "Provinces",
    y = "Percentage Share (%)",
    fill = "Humidity Regime"
  ) +
  theme_bw(base_size = 12) +
  theme(
    plot.title = element_text(face = "bold", size = 13),
    axis.text.x = element_text(angle = 35, hjust = 1, face = "bold", color = "black"),
    legend.position = "right"
  )

print(p_humidity)
ggsave("Figure_27_Global_Humidity_Distribution.png", plot = p_humidity, width = 11, height = 6, dpi = 300)
message("Analiz 21 (Ba????l Nem) ba??ar??yla tamamland?? ve Figure 27 kaydedildi!")