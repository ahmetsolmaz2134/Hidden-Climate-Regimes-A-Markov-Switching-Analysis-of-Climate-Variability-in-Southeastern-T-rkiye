# Grafik 2: PRECTOTCORR Zaman Serisi / Facet Grafi??i
p_precip <- ggplot(panel_df, aes(x = date, y = PRECTOTCORR)) +
  geom_line(color = "#2b5c8f", linewidth = 0.4, alpha = 0.7) +
  geom_smooth(method = "loess", color = "#d95f02", se = FALSE, linewidth = 1) +
  facet_wrap(~ province, scales = "free_y", ncol = 3) +
  labs(
    title = "Monthly Corrected Precipitation Trends (1990???2025)",
    subtitle = "Southeastern Anatolia Region (Blue: Monthly Data, Orange: LOESS Trend)",
    x = "Years",
    y = "Precipitation (mm/day)"
  ) +
  theme_bw(base_size = 11) +
  theme(
    plot.title = element_text(face = "bold", size = 14, hjust = 0.5),
    plot.subtitle = element_text(size = 10, hjust = 0.5, color = "gray40"),
    strip.text = element_text(face = "bold", size = 11),
    strip.background = element_rect(fill = "#f0f0f0", color = "black"),
    axis.text = element_text(color = "black"),
    panel.grid.minor = element_blank()
  )

print(p_precip)

# Y??ksek ????z??n??rl??kl?? kaydetme
ggsave("Figure_2_Precipitation_Trends.png", plot = p_precip, width = 12, height = 8, dpi = 300)