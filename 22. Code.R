library(dplyr)
library(writexl)
library(ggplot2)

# 1. Tarih ve ay de??i??kenini garantiye alal??m
panel_df <- panel_df %>%
  mutate(
    date_dt = as.Date(date),
    month = as.numeric(format(date_dt, "%m"))
  ) %>%
  arrange(province, date_dt)

# 2. AY BAZLI E????KLER: Her ilin her ay?? kendi i??inde de??erlendirilir 
# (??rn: Ocak ay?? kendi oca????na, Temmuz ay?? kendi temmuzuna g??re k??yaslan??r)
panel_monthly_thresh <- panel_df %>%
  group_by(province, month) %>%
  mutate(
    tmax_m_thresh = quantile(T2M_MAX, 0.66, na.rm = TRUE),
    precip_m_thresh = quantile(PRECTOTCORR, 0.33, na.rm = TRUE),
    rh_m_thresh = quantile(RH2M, 0.33, na.rm = TRUE)
  ) %>%
  ungroup() %>%
  mutate(
    High_Tmax = T2M_MAX >= tmax_m_thresh,
    Low_Precip = PRECTOTCORR <= precip_m_thresh,
    Low_RH = RH2M <= rh_m_thresh,
    Triple_Compound = High_Tmax & Low_Precip & Low_RH
  )

# 3. Ard??????k s??releri hesaplayan fonksiyon
calc_spell_stats <- function(x) {
  r <- rle(x)
  true_lengths <- r$lengths[r$values == TRUE]
  if(length(true_lengths) == 0) {
    return(c(Mean_Duration = 0, Max_Duration = 0))
  }
  c(
    Mean_Duration = mean(true_lengths),
    Max_Duration = max(true_lengths)
  )
}

# 4. ??llere g??re ger??ek s??kl??k ve s??re istatistikleri
compound_stats_monthly <- panel_monthly_thresh %>%
  group_by(province) %>%
  summarise(
    Frequency_Pct = mean(Triple_Compound, na.rm = TRUE) * 100,
    Mean_Spell_Months = calc_spell_stats(Triple_Compound)["Mean_Duration"],
    Max_Spell_Months = calc_spell_stats(Triple_Compound)["Max_Duration"],
    .groups = 'drop'
  ) %>%
  arrange(desc(Frequency_Pct))

# Excel ????kt??s??
write_xlsx(list("Monthly_Triple_Compound" = compound_stats_monthly), "Analysis_23_Monthly_Triple_Compound.xlsx")

# 5. Do??ru ve Kar????la??t??rmal?? Grafik
p_compound_monthly <- ggplot(compound_stats_monthly, aes(x = reorder(province, Frequency_Pct), y = Frequency_Pct, fill = Frequency_Pct)) +
  geom_bar(stat = "identity", width = 0.7, color = "black") +
  coord_flip() +
  scale_fill_gradient(low = "#fee08b", high = "#d73027") +
  labs(
    title = "Monthly Climatology-Based Triple Compound Hot-Dry Frequency",
    subtitle = "Simultaneous anomalies of High Tmax, Low Precipitation, and Low Humidity (1990???2025)",
    x = "Provinces",
    y = "Compound Frequency (%)",
    fill = "Frequency (%)"
  ) +
  theme_bw(base_size = 12) +
  theme(
    plot.title = element_text(face = "bold", size = 13),
    axis.text = element_text(face = "bold", color = "black"),
    legend.position = "right"
  )

print(p_compound_monthly)
ggsave("Figure_29_Monthly_Triple_Compound.png", plot = p_compound_monthly, width = 10, height = 6, dpi = 300)
message("Analiz 23, ay bazl?? climatology normallerine g??re ba??ar??yla g??ncellendi!")