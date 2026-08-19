# Hidden Climate Regimes: A Markov-Switching Analysis of Climate Variability in Southeastern Türkiye

**Author:** Ahmet Solmaz
**Study Region:** Southeastern Türkiye
**Programming Environment:** R
**Primary Method:** Markov-Switching Models

---

## 1. Overview

Climate variability is commonly investigated through linear trends, anomalies, correlation structures, and extreme-event indices. However, climate variables may not behave as a single homogeneous statistical process. Instead, their temporal behavior can shift between distinct and persistent states or **climate regimes**.

This project, developed by **Ahmet Solmaz**, investigates the temporal dynamics of climate variability in Southeastern Türkiye using a **Markov-switching modeling framework**.

The central objective is to identify statistically distinguishable climate regimes and determine how frequently and persistently the regional climate system transitions between these states.

Rather than asking only whether temperature or precipitation has increased or decreased, the study addresses a different question:

> **Does the statistical behavior of the climate system change between distinct regimes, and how do the probabilities of transitioning between these regimes evolve over time?**

---

## 2. Research Objectives

The main objectives are to:

* identify hidden climate regimes within the observed climate time series;
* estimate the statistical characteristics of each regime;
* quantify transition probabilities between climate regimes;
* determine the persistence and duration of individual regimes;
* compare alternative Markov-switching specifications;
* investigate whether warm, dry, humid, or otherwise anomalous states have become more persistent;
* examine temporal changes in the structure of climate variability in Southeastern Türkiye.

---

## 3. Study Region

The study focuses on **Southeastern Türkiye**, a climatically sensitive region characterized by strong seasonal contrasts, high summer temperatures, relatively dry conditions, and substantial spatial and temporal climate variability.

The region is particularly relevant for climate-regime analysis because changes in temperature, precipitation, atmospheric moisture, and surface energy conditions may alter the persistence and frequency of different climate states.

The analysis is conducted at the regional or station/grid level depending on the structure of the available dataset.

---

## 4. Data

The project is designed primarily around climate time-series data obtained from **NASA POWER** and/or comparable gridded or station-based climate datasets.

Potential variables include:

* Maximum Air Temperature (Tmax)
* Minimum Air Temperature (Tmin)
* Precipitation
* Relative Humidity
* Wind Speed
* Surface Solar Radiation

The final set of variables will depend on data quality, temporal completeness, and the statistical suitability of each variable for Markov-switching analysis.

### Temporal Resolution

The analysis can be performed using:

* monthly data for long-term climate-regime analysis;
* daily data for higher-resolution regime detection where available.

The selected temporal resolution will be kept consistent throughout the main modeling framework.

---

## 5. Methodological Framework

The methodological framework consists of the following stages:

```text
Climate Data
     ↓
Data Quality Control
     ↓
Exploratory Time-Series Analysis
     ↓
Standardization / Transformation
     ↓
Stationarity Assessment
     ↓
Markov-Switching Model Estimation
     ↓
2-Regime / 3-Regime / 4-Regime Comparison
     ↓
AIC / BIC / Log-Likelihood Evaluation
     ↓
Regime Identification
     ↓
Transition Probability Analysis
     ↓
Regime Persistence and Duration
     ↓
Temporal Interpretation
```

---

## 6. Markov-Switching Model

The central methodological component of the study is the **Markov-switching model**.

Let the observed climate variable at time (t) be represented by:

[
Y_t = \mu_{S_t} + \epsilon_t
]

where:

* (Y_t) represents the observed climate variable;
* (\mu_{S_t}) represents the mean associated with the current climate regime;
* (S_t) represents the unobserved regime at time (t);
* (\epsilon_t) represents the model residual.

The latent regime (S_t) evolves according to a Markov process.

Thus, the probability of the current regime depends on the previous regime:

[
P(S_t=j|S_{t-1}=i)=p_{ij}
]

where (p_{ij}) represents the probability of transitioning from regime (i) to regime (j).

---

## 7. Alternative Regime Specifications

To avoid imposing an arbitrary number of climate states, alternative model specifications will be evaluated.

### Two-Regime Model

A simple structure such as:

* Regime 1: relatively normal/cool conditions
* Regime 2: relatively warm conditions

### Three-Regime Model

A potentially more detailed structure:

* Regime 1: relatively cool/normal
* Regime 2: warm
* Regime 3: extremely warm

For precipitation or moisture-related variables, regimes may instead represent relatively wet, normal, and dry conditions.

### Four-Regime Model

Where statistically justified:

* cool/wet
* normal
* warm/dry
* extreme warm/dry

The final interpretation of regimes will be based on the estimated statistical characteristics rather than predetermined labels.

---

## 8. Model Selection

Alternative model specifications will be compared using information criteria and likelihood-based measures.

The principal criteria include:

* Akaike Information Criterion (AIC)
* Bayesian Information Criterion (BIC)
* Log-Likelihood

The preferred model will be selected based on statistical performance, interpretability, and model diagnostics.

A lower AIC or BIC indicates a more favorable balance between model fit and model complexity.

---

## 9. Regime Characteristics

For each detected climate regime, the following characteristics will be calculated:

* Mean
* Variance
* Standard deviation
* Frequency
* Relative occurrence
* Mean duration
* Maximum duration
* Minimum duration
* Persistence probability
* Transition probability

This allows each statistically identified regime to be interpreted climatologically.

---

## 10. Transition Probability Matrix

A major output of the project will be the estimated transition probability matrix.

For a three-regime model:

| From / To | Regime 1 | Regime 2 | Regime 3 |
| --------- | -------: | -------: | -------: |
| Regime 1  | (p_{11}) | (p_{12}) | (p_{13}) |
| Regime 2  | (p_{21}) | (p_{22}) | (p_{23}) |
| Regime 3  | (p_{31}) | (p_{32}) | (p_{33}) |

The diagonal elements represent the probability of remaining within the same regime.

High diagonal probabilities indicate strong regime persistence.

---

## 11. Regime Persistence and Duration

Regime persistence is one of the most important components of the analysis.

For each regime, the study will estimate:

* probability of remaining in the same regime;
* expected duration;
* observed duration;
* frequency of transitions;
* persistence relative to other regimes.

This makes it possible to determine whether potentially unfavorable climate states are becoming more persistent.

For example, an increase in the persistence of a warm regime would indicate a change not merely in mean temperature but in the **temporal structure of climate variability**.

---

## 12. Temporal Evolution of Climate Regimes

The study will investigate whether the distribution of climate regimes changes over time.

Potential periods include:

* 1990–2000
* 2001–2010
* 2011–2020
* 2021–2025

The exact periods will depend on the final dataset.

Comparisons will focus on:

* regime frequency;
* regime persistence;
* transition probabilities;
* mean regime duration;
* frequency of warm/dry states;
* frequency of cool/wet states.

---

## 13. Statistical Diagnostics

Model adequacy will be evaluated using:

* residual diagnostics;
* autocorrelation analysis;
* residual distribution;
* likelihood comparison;
* information criteria;
* regime classification probabilities;
* sensitivity to alternative model specifications.

The objective is to ensure that identified regimes represent statistically meaningful structures rather than artifacts of model specification.

---

## 14. Expected Figures

The repository will include graphical outputs generated entirely in R.

### Figure 1. Climate Time Series

![Climate Time Series](figures/climate_time_series.png)

### Figure 2. Standardized Climate Anomalies

![Climate Anomalies](figures/climate_anomalies.png)

### Figure 3. Markov-Switching Regime Classification

![Regime Classification](figures/regime_classification.png)

### Figure 4. Smoothed Regime Probabilities

![Regime Probabilities](figures/regime_probabilities.png)

### Figure 5. Transition Probability Matrix

![Transition Matrix](figures/transition_matrix.png)

### Figure 6. Regime Duration

![Regime Duration](figures/regime_duration.png)

### Figure 7. Regime Frequency Through Time

![Regime Frequency](figures/regime_frequency.png)

### Figure 8. Model Comparison

![Model Comparison](figures/model_comparison.png)

### Figure 9. Residual Diagnostics

![Residual Diagnostics](figures/residual_diagnostics.png)

### Figure 10. Temporal Evolution of Regime Probabilities

![Temporal Regime Evolution](figures/temporal_regime_evolution.png)

> Figure filenames will be updated according to the final R workflow and repository structure.

---

## 15. Main Results

The numerical results will be reported after completion of the Markov-switching estimation.

The final analysis will report:

* the optimal number of climate regimes;
* estimated regime means;
* regime variances;
* regime frequencies;
* transition probabilities;
* expected regime durations;
* persistence characteristics;
* temporal changes in regime occurrence;
* model-selection statistics.

### Principal Result

The central result of the study will be expressed in terms of whether the climate system exhibits statistically distinguishable regimes and whether the probability and persistence of these regimes have changed through time.

---

## 16. Scientific Contribution

The main contribution of this project is methodological.

Instead of treating climate variability as a single continuous process, the study conceptualizes the regional climate system as a **dynamic stochastic process capable of switching between distinct statistical states**.

This framework provides information that conventional trend analysis cannot directly provide.

For example:

**Trend analysis asks:**

> Is temperature increasing?

**Markov-switching analysis asks:**

> How often does the system enter a warm regime, how long does it remain there, and what is the probability that it transitions into an even warmer regime?

This distinction provides a different perspective on regional climate variability.

---

## 17. Reproducibility

All statistical analyses and visualizations are conducted in **R**.

The repository is structured to support reproducibility:

```text
Hidden-Climate-Regimes/
│
├── data/
│   ├── raw/
│   └── processed/
│
├── R/
│   ├── 01_data_preparation.R
│   ├── 02_exploratory_analysis.R
│   ├── 03_stationarity.R
│   ├── 04_markov_switching.R
│   ├── 05_model_comparison.R
│   ├── 06_regime_analysis.R
│   └── 07_visualization.R
│
├── figures/
│
├── results/
│   ├── tables/
│   └── model_outputs/
│
├── README.md
└── LICENSE
```

---

## 18. Software and Packages

The analysis will be implemented using R and relevant packages for:

* time-series analysis;
* statistical modeling;
* Markov-switching estimation;
* data manipulation;
* visualization;
* model diagnostics.

Potential R packages include:

```r
tidyverse
lubridate
zoo
xts
MSwM
depmixS4
ggplot2
dplyr
forecast
tseries
```

The final package list will be determined by the implemented model specification.

---

## 19. Research Questions

The project is designed around the following research questions:

1. **How many statistically distinguishable climate regimes can be identified in Southeastern Türkiye?**

2. **What are the statistical characteristics of each climate regime?**

3. **How persistent are the identified regimes?**

4. **What are the probabilities of transition between different climate states?**

5. **Have the frequencies and durations of warm or dry regimes changed over time?**

6. **Has the persistence of unfavorable climate regimes increased during the recent period?**

7. **Does a Markov-switching framework provide additional information beyond conventional climate trend analysis?**

---

## 20. Conclusion

This project investigates climate variability in Southeastern Türkiye from a **regime-switching perspective**.

The central premise is that climate variability should not necessarily be interpreted as a single stable statistical process. Different periods may exhibit substantially different means, variances, persistence characteristics, and transition probabilities.

By applying Markov-switching models, this research aims to identify these hidden states and quantify the dynamics connecting them.

The study therefore moves beyond the conventional question of whether climate variables are increasing or decreasing and instead investigates:

> **How does the climate system move between different statistical regimes, how persistent are these regimes, and has this behavior changed over time?**

---

## Author

**Ahmet Solmaz**

Geography and Climate Research
Türkiye

---

## License

This project is intended for academic and research purposes.

If the dataset, code, or results are reused, please provide appropriate attribution to the author.

**© Ahmet Solmaz**
