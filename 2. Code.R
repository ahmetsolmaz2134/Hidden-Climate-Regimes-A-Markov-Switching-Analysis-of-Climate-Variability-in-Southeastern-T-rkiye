library(ggplot2)
library(dplyr)
library(tidyr)
library(writexl)
library(zoo)

# --- 1. TANIMLAYICI ??STAT??ST??KLER VE EXCEL ??IKTISI ---
desc_stats <- panel_df %>%
  group_by(province) %>%
  summarise(
    across(
      c(T2M_MAX, T2M_MIN, PRECTOTCORR, RH2M),
      list(
        Mean       = ~mean(.x, na.rm = TRUE),
        Median     = ~median(.x, na.rm = TRUE),
        Min        = ~min(.x, na.rm = TRUE),
        Max        = ~max(.x, na.rm = TRUE),
        StdDev     = ~sd(.x, na.rm = TRUE),
        Variance   = ~var(.x, na.rm = TRUE),
        Skewness   = ~e1071::skewness(.x, na.rm = TRUE),
        Kurtosis   = ~e1071::kurtosis(.x, na.rm = TRUE),
        Q1         = ~quantile(.x, 0.25, na.rm = TRUE),
        Q3         = ~quantile(.x, 0.75, na.rm = TRUE),
        IQR        = ~IQR(.x, na.rm = TRUE),
        CV_Percent = ~(sd(.x, na.rm = TRUE) / mean(.x, na.rm = TRUE)) * 100
      ),
      .names = "{.col}_{.fn}"
    )
  )

write_xlsx(desc_stats, "Southeastern_Anatolia_Descriptive_Statistics_1990_2025.xlsx")


# --- 2. UZUN D??NEM DAVRANI?? METR??KLER?? VE EXCEL ??IKTISI ---
long_term_summary <- panel_df %>%
  group_by(province) %>%
  summarise(
    Mean_T2M_MAX = mean(T2M_MAX, na.rm = TRUE),
    Mean_Precip  = mean(PRECTOTCORR, na.rm = TRUE),
    Volatility_T2M_MAX = sd(T2M_MAX, na.rm = TRUE),
    Volatility_Precip  = sd(PRECTOTCORR, na.rm = TRUE),
    Persistence_T2M_MAX = cor(head(T2M_MAX, -1), tail(T2M_MAX, -1), use = "complete.obs"),
    Persistence_Precip  = cor(head(PRECTOTCORR, -1), tail(PRECTOTCORR, -1), use = "complete.obs")
  )

write_xlsx(long_term_summary, "Southeastern_Anatolia_LongTerm_Behavior_Metrics.xlsx")


# --- 3. AKADEM??K GRAF??KLER??N OLU??TURULMASI VE KAYDED??LMES?? ---

# Grafik 1: T2M_MAX Boxplot
p_box_t2m <- ggplot(panel_df, aes(x = reorder(province, T2M_MAX, FUN = median), y = T2M_MAX, fill = province)) +
  geom_boxplot(alpha = 0.85, outlier.size = 1.2, outlier.alpha = 0.4, linewidth = 0.6) +
  labs(title = "Monthly Maximum Temperature Distribution (1990???2025)", subtitle = "Southeastern Anatolia Region, Turkey", x = "Provinces", y = "Maximum Temperature (??C)", fill = "Province") +
  theme_minimal(base_size = 13) +
  theme(plot.title = element_text(face = "bold", size = 15, hjust = 0.5), plot.subtitle = element_text(size = 12, hjust = 0.5, color = "gray40"), axis.text.x = element_text(angle = 30, hjust = 1, face = "bold"), legend.position = "none") +
  scale_fill_viridis_d(option = "plasma")
ggsave("Figure_1_T2M_MAX_Boxplot.png", plot = p_box_t2m, width = 10, height = 6, dpi = 300)

# Grafik 2: Precipitation Trends (Facet)
p_precip <- ggplot(panel_df, aes(x = date, y = PRECTOTCORR)) +
  geom_line(color = "#2b5c8f", linewidth = 0.4, alpha = 0.7) +
  geom_smooth(method = "loess", color = "#d95f02", se = FALSE, linewidth = 1) +
  facet_wrap(~ province, scales = "free_y", ncol = 3) +
  labs(title = "Monthly Corrected Precipitation Trends (1990???2025)", subtitle = "Southeastern Anatolia Region", x = "Years", y = "Precipitation (mm/day)") +
  theme_bw(base_size = 11) +
  theme(plot.title = element_text(face = "bold", size = 14, hjust = 0.5), strip.text = element_text(face = "bold"))
ggsave("Figure_2_Precipitation_Trends.png", plot = p_precip, width = 12, height = 8, dpi = 300)

# Grafik 3: Long-Term Behavior & Thermal Anomalies
p_longterm <- ggplot(panel_df, aes(x = date, y = T2M_MAX)) +
  geom_line(color = "gray60", alpha = 0.6, linewidth = 0.3) +
  geom_smooth(method = "loess", span = 0.2, color = "#b2182b", linewidth = 1) +
  facet_wrap(~ province, scales = "free_y", ncol = 3) +
  labs(title = "Long-Term Behavior and Thermal Anomalies (1990???2025)", subtitle = "Monthly Maximum Temperature with LOESS Trend", x = "Years", y = "Maximum Temperature (??C)") +
  theme_bw(base_size = 11) +
  theme(plot.title = element_text(face = "bold", size = 13, hjust = 0.5), strip.text = element_text(face = "bold"))
ggsave("Figure_3_LongTerm_Behavior_T2M.png", plot = p_longterm, width = 12, height = 8, dpi = 300)

# Grafik 4: Seasonality Cycle
panel_df$Month_Name <- factor(format(panel_df$date, "%b"), levels = c("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"))
p_seasonality <- ggplot(panel_df, aes(x = Month_Name, y = T2M_MAX, fill = Month_Name)) +
  geom_boxplot(alpha = 0.8, outlier.size = 0.8, outlier.alpha = 0.3) +
  facet_wrap(~ province, ncol = 3) +
  labs(title = "Monthly Seasonality of Maximum Temperatures (1990???2025)", subtitle = "Intra-annual distribution across 9 provinces", x = "Months", y = "Maximum Temperature (??C)") +
  theme_minimal(base_size = 11) +
  theme(plot.title = element_text(face = "bold", size = 13, hjust = 0.5), axis.text.x = element_text(angle = 45, hjust = 1, face = "bold"), legend.position = "none") +
  scale_fill_viridis_d(option = "plasma")
ggsave("Figure_4_Seasonality_Cycle.png", plot = p_seasonality, width = 12, height = 8, dpi = 300)

# Grafik 5: Precipitation Fluctuations
p_fluctuation <- ggplot(panel_df, aes(x = date, y = PRECTOTCORR)) +
  geom_col(aes(fill = PRECTOTCORR > mean(PRECTOTCORR, na.rm = TRUE)), width = 30, alpha = 0.7) +
  scale_fill_manual(values = c("#d95f02", "#2b5c8f"), labels = c("Dry Period", "Wet Period")) +
  facet_wrap(~ province, ncol = 3, scales = "free_y") +
  labs(title = "Precipitation Fluctuations and Extreme Dry/Wet Epochs (1990???2025)", subtitle = "Monthly anomalies relative to long-term mean", x = "Years", y = "Precipitation (mm/day)", fill = "Condition") +
  theme_bw(base_size = 11) +
  theme(plot.title = element_text(face = "bold", size = 13, hjust = 0.5), legend.position = "bottom")
ggsave("Figure_5_Precipitation_Fluctuations.png", plot = p_fluctuation, width = 12, height = 8, dpi = 300)

message("T??m Excel raporlar?? ve 5 akademik grafik ba??ar??yla olu??turuldu ve kaydedildi!")