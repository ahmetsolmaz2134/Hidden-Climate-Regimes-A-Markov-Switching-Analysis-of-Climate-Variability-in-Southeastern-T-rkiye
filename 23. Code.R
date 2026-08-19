library(dplyr)
library(writexl)
library(ggplot2)

# 1. ??ok de??i??kenli standartla??t??rma ve bile??ik stres indeksi (Z-score tabanl??)
multivariate_data <- panel_df %>%
  select(province, YEAR, MO, T2M_MAX, T2M_MIN, PRECTOTCORR, RH2M) %>%
  na.omit() %>%
  group_by(province) %>%
  mutate(
    z_tmax = scale(T2M_MAX),
    z_tmin = scale(T2M_MIN),
    z_precip = scale(PRECTOTCORR),
    z_rh = scale(RH2M),
    # ??ok de??i??kenli A????r?? Stres ??ndeksi (S??cakl??klar ve nem/ya?????? a???????? bir arada)
    Multivariate_Stress_Index = (z_tmax + z_tmin - z_precip - z_rh) / 4
  ) %>%
  ungroup()

# 2. ??llere g??re ??ok de??i??kenli rejim durumlar??n??n hesaplanmas??
# ??ndeksin ??st %75'lik dilimi "Extreme Multivariate Regime" olarak s??n??fland??r??l??r
stress_threshold <- quantile(multivariate_data$Multivariate_Stress_Index, 0.75, na.rm = TRUE)

mv_results <- multivariate_data %>%
  mutate(Extreme_State = Multivariate_Stress_Index >= stress_threshold) %>%
  group_by(province) %>%
  summarise(
    Freq_Extreme_Regime = mean(Extreme_State, na.rm = TRUE) * 100,
    Mean_Stress_Score = mean(Multivariate_Stress_Index, na.rm = TRUE),
    .groups = 'drop'
  ) %>%
  arrange(desc(Freq_Extreme_Regime))

# 3. Excel ????kt??s??
write_xlsx(list("Multivariate_Regime_Analysis" = mv_results), "Analysis_24_Multivariate_Regime_Results.xlsx")

# 4. Akademik G??rselle??tirme (Figure 30)
p_mv_safe <- ggplot(mv_results, aes(x = reorder(province, Freq_Extreme_Regime), y = Freq_Extreme_Regime, fill = Freq_Extreme_Regime)) +
  geom_bar(stat = "identity", width = 0.7, color = "black") +
  coord_flip() +
  scale_fill_gradient(low = "#fee08b", high = "#d73027") +
  labs(
    title = "Multivariate Integrated Regime Analysis: Extreme Stress Frequency",
    subtitle = "Simultaneous integration of Tmax, Tmin, Precipitation, and Relative Humidity (1990???2025)",
    x = "Provinces",
    y = "Extreme Multivariate Regime Frequency (%)",
    fill = "Frequency (%)"
  ) +
  theme_bw(base_size = 12) +
  theme(
    plot.title = element_text(face = "bold", size = 13),
    axis.text = element_text(face = "bold", color = "black"),
    legend.position = "right"
  )

print(p_mv_safe)
ggsave("Figure_30_Multivariate_Integrated_Results.png", plot = p_mv_safe, width = 10, height = 6, dpi = 300)
message("Analiz 24 ba??ar??yla tamamland??! Hi??bir d???? paket hatas?? almadan Excel ve Figure 30 ??retildi.")