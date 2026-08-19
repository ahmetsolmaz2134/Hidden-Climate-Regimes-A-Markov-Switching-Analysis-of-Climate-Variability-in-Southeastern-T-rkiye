library(dplyr)
library(writexl)
library(ggplot2)

# 1. T??m b??lgenin ortak (global) d??????k ve y??ksek ya?????? e??iklerini belirleyelim
global_low <- quantile(panel_df$PRECTOTCORR, 0.33, na.rm = TRUE)
global_high <- quantile(panel_df$PRECTOTCORR, 0.66, na.rm = TRUE)

# 2. Bu ortak e??iklere g??re t??m veri setini s??n??fland??ral??m
precip_analysis <- panel_df %>%
  mutate(
    Precip_Regime = case_when(
      PRECTOTCORR <= global_low ~ "Low Precipitation",
      PRECTOTCORR > global_low & PRECTOTCORR <= global_high ~ "Normal Precipitation",
      PRECTOTCORR > global_high ~ "High Precipitation"
    )
  )

# 3. ??llere g??re y??zdelik da????l??mlar?? hesaplayal??m (Art??k ger??ek farklar g??r??necek)
precip_summary <- precip_analysis %>%
  group_by(province, Precip_Regime) %>%
  summarise(Count = n(), .groups = 'drop') %>%
  group_by(province) %>%
  mutate(Percentage = (Count / sum(Count)) * 100)

# Excel ????kt??s??
write_xlsx(list("Global_Precip_Regimes" = precip_summary), "Analysis_20_Global_Precipitation_Regimes.xlsx")

# 4. Dinamik ve Ger??ek??i Akademik G??rselle??tirme
p_precip_global <- ggplot(precip_summary, aes(x = province, y = Percentage, fill = Precip_Regime)) +
  geom_bar(stat = "identity", position = "stack", color = "black", width = 0.7) +
  scale_fill_manual(values = c("Low Precipitation" = "#d73027", 
                               "Normal Precipitation" = "#fee08b", 
                               "High Precipitation" = "#41ab5d")) +
  labs(
    title = "Regional Distribution of Precipitation Regimes (Global Thresholds)",
    subtitle = "Comparative analysis showing true spatial contrasts across 9 provinces",
    x = "Provinces",
    y = "Percentage Share (%)",
    fill = "Precipitation Regime"
  ) +
  theme_bw(base_size = 12) +
  theme(
    plot.title = element_text(face = "bold", size = 13),
    axis.text.x = element_text(angle = 35, hjust = 1, face = "bold", color = "black"),
    legend.position = "right"
  )

print(p_precip_global)
ggsave("Figure_26_Global_Precipitation_Distribution.png", plot = p_precip_global, width = 11, height = 6, dpi = 300)
message("Ger??ek b??lgesel da????l??m grafi??i ve Excel ????kt??s?? haz??r!")