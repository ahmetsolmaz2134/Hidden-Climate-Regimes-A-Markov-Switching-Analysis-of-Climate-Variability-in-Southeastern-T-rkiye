library(dplyr)
library(writexl)
library(ggplot2)

# 9 il i??in T2M_MIN (Minimum S??cakl??k) B??lgesel Kar????la??t??rma Matrisi
prov_comparison_tmin <- panel_df %>%
  group_by(province) %>%
  summarise(
    Mean_Min_Temp = mean(T2M_MIN, na.rm = TRUE),
    SD_Min_Temp = sd(T2M_MIN, na.rm = TRUE),
    Extreme_Cold_Freq = mean(T2M_MIN < quantile(T2M_MIN, 0.25, na.rm = TRUE)) * 100,
    Min_Absolute = min(T2M_MIN, na.rm = TRUE),
    Max_Absolute = max(T2M_MIN, na.rm = TRUE)
  ) %>%
  arrange(desc(Mean_Min_Temp))

# Excel ????kt??s??
write_xlsx(list("Inter_Provincial_TMIN" = prov_comparison_tmin), "Analysis_19_Inter_Provincial_TMIN_Comparison.xlsx")

# Akademik Kar????la??t??rma Grafi??i (T2M_MIN)
p_comp_tmin <- ggplot(prov_comparison_tmin, aes(x = reorder(province, Mean_Min_Temp), y = Mean_Min_Temp, fill = Mean_Min_Temp)) +
  geom_bar(stat = "identity", width = 0.7, color = "black") +
  coord_flip() +
  scale_fill_gradient(low = "#2c7bb6", high = "#fdae61") +
  labs(
    title = "Inter-Provincial Comparison of Minimum Temperature Regimes",
    subtitle = "Mean Minimum Temperatures Across the 9 Provinces (1990???2025)",
    x = "Provinces",
    y = "Mean Minimum Temperature (??C)",
    fill = "Mean Min Temp (??C)"
  ) +
  theme_bw(base_size = 12) +
  theme(
    plot.title = element_text(face = "bold", size = 14),
    axis.text = element_text(face = "bold", color = "black"),
    legend.position = "right"
  )

print(p_comp_tmin)
ggsave("Figure_25_Inter_Provincial_TMIN_Comparison.png", plot = p_comp_tmin, width = 10, height = 6, dpi = 300)
message("Analiz 19 (T2M_MIN) ba??ar??yla tamamland?? ve Figure 25 kaydedildi!")