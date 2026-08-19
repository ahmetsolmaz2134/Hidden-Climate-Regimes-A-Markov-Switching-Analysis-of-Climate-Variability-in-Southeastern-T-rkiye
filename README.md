# Hidden Climate Regimes: A Markov-Switching Analysis of Climate Variability in Southeastern Türkiye

**Author:** Ahmet Solmaz
**Study Region:** Southeastern Türkiye
**Study Period:** 1990–2025
**Programming Environment:** R
**Primary Methods:** Hidden Markov Models, Markov-Switching Models, AIC/BIC Model Selection, Transition Probability Analysis, Regime Persistence, Duration Analysis, Multivariate Regime Analysis, Compound Hot-Dry Analysis

---

## Abstract

Climate variability is frequently investigated using linear trends, anomalies, correlation analysis, and conventional climate indices. Although these approaches provide important information about the direction and magnitude of climatic change, they generally treat the observed climate series as a single statistical process. Such an assumption may be insufficient when climatic conditions alternate between distinct states with different means, variability, persistence, and transition characteristics.

This study investigates the existence and temporal behaviour of **hidden climate regimes in Southeastern Türkiye during 1990–2025** using a Markov-switching framework supported by Hidden Markov Models (HMM). The analysis combines descriptive climate statistics, long-term behaviour metrics, seasonality analysis, standardized anomalies, autocorrelation and partial autocorrelation diagnostics, alternative two-, three-, and four-regime specifications, information-criterion-based model selection, regime probabilities, most-likely regime classification, transition probability matrices, expected and empirical regime durations, regime frequencies, inter-provincial comparisons, minimum-temperature regimes, humidity regimes, multivariate climate-state analysis, and compound hot-dry conditions.

The results demonstrate that the temporal structure of climate variability in Southeastern Türkiye can be interpreted through **multiple statistically distinguishable states rather than a single homogeneous process**. The identified regimes differ not only in their central tendency but also in their persistence, duration, frequency, and probability of transition toward alternative states.

A particularly important finding is that climate-state persistence provides information that cannot be obtained from a conventional linear trend alone. A warm or anomalous regime may become important not simply because its mean value is higher, but because it can persist for consecutive observations and exhibit a high probability of remaining within the same state.

The analysis further demonstrates that climate-regime behaviour varies among provinces and that maximum temperature, minimum temperature, humidity, and compound hot-dry conditions provide complementary information about the structure of regional climate variability.

The study therefore proposes a regime-oriented framework for understanding climate variability in Southeastern Türkiye, emphasizing **state identification, persistence, transition dynamics, temporal evolution, and compound climate behaviour**.

---

# 1. Research Motivation

Southeastern Türkiye is characterized by strong seasonal contrasts, high summer temperatures, relatively dry atmospheric conditions, and considerable interannual climate variability.

Conventional climate studies generally ask:

* Is temperature increasing?
* Is precipitation decreasing?
* Are extreme conditions becoming more frequent?
* Are climatic anomalies becoming stronger?

These questions remain important. However, a climate system can exhibit substantial structural variability even when its overall linear trend does not fully capture the underlying dynamics.

This study therefore introduces a complementary question:

> **Does the regional climate system alternate between distinct statistical regimes, and how persistent and transitional are these regimes?**

A Markov-switching framework is particularly appropriate because the statistical properties of the observed climate series are allowed to depend on an unobserved state variable.

The climate system is therefore conceptualized as:

```text
Climate observations
        ↓
Latent statistical state
        ↓
Regime persistence
        ↓
Transition to another regime
        ↓
New climate state
```

This approach allows climate variability to be interpreted as a **dynamic state-switching process** rather than solely as a monotonic trend.

---

# 2. Research Objectives

The study was designed to address the following objectives:

1. Identify hidden climate regimes in Southeastern Türkiye.
2. Determine whether two-, three-, or four-regime specifications provide the most appropriate representation of the climate system.
3. Characterize the statistical properties of each regime.
4. Estimate transition probabilities between regimes.
5. Quantify the persistence of individual climate states.
6. Estimate expected and empirical regime durations.
7. Determine the temporal probability of each regime.
8. Identify the most likely regime for each observation.
9. Compare regime characteristics among provinces.
10. Examine minimum-temperature regime behaviour.
11. Investigate humidity-related climate states.
12. Evaluate multivariate climate-regime behaviour.
13. Investigate compound hot-dry conditions.
14. Develop a reproducible R-based framework for regime-oriented climate analysis.

---

# 3. Data and Study Period

The analysis covers the **1990–2025 period** and focuses on climate variability in Southeastern Türkiye.

The analytical workflow incorporates multiple climate variables and derived statistical representations, including:

* maximum temperature;
* minimum temperature;
* precipitation;
* humidity;
* standardized anomalies;
* multivariate climate indicators;
* compound hot-dry conditions.

The repository contains processed Excel outputs corresponding to each major analytical stage.

These include:

* descriptive statistics;
* long-term climate metrics;
* standardized climate panels;
* ACF/PACF diagnostics;
* HMM classifications;
* Markov-switching models;
* model-selection statistics;
* regime statistics;
* regime probabilities;
* transition matrices;
* duration statistics;
* regime frequencies;
* inter-provincial comparisons;
* humidity regimes;
* multivariate comparisons;
* compound hot-dry analysis.

---

# 4. Methodological Framework

The complete workflow can be summarized as:

```text
Climate Data
      ↓
Data Preparation
      ↓
Descriptive Statistics
      ↓
Long-Term Behaviour
      ↓
Seasonality
      ↓
Standardization
      ↓
ACF / PACF
      ↓
Hidden Markov Model
      ↓
Markov-Switching Models
      ↓
2-, 3-, 4-Regime Comparison
      ↓
AIC / BIC / Log-Likelihood
      ↓
Regime Identification
      ↓
Regime Probabilities
      ↓
Most-Likely Regime
      ↓
Transition Matrix
      ↓
Persistence
      ↓
Expected Duration
      ↓
Empirical Duration
      ↓
Regime Frequency
      ↓
Inter-Provincial Analysis
      ↓
Tmin / Humidity Analysis
      ↓
Multivariate Analysis
      ↓
Compound Hot-Dry Analysis
```

---

# 5. Exploratory Climate Results

## 5.1 Maximum Temperature Distribution

### Figure 1 — Tmax Distribution

![Figure 1](Figure_1_T2M_MAX_Boxplot.png)

The initial distributional analysis establishes the thermal background of the study region.

The boxplot demonstrates that maximum-temperature behaviour is not identical across the analyzed locations. Differences in central tendency, dispersion, and the distribution of extreme observations indicate that the regional climate system contains meaningful spatial heterogeneity.

This initial result is important for the subsequent Markov analysis because a single regional distribution could obscure location-specific climate-state behaviour.

The corresponding descriptive statistics are provided in:

`Southeastern_Anatolia_Descriptive_Statistics_1990_2025.xlsx`

---

# 6. Precipitation Behaviour

## 6.1 Long-Term Precipitation Variability

### Figure 2 — Precipitation Trends

![Figure 2](Figure_2_Precipitation_Trends.png)

The precipitation analysis reveals substantial temporal variability in rainfall behaviour.

Unlike temperature, precipitation typically exhibits greater intermittency and short-term variability. Consequently, the precipitation series provides an important complementary dimension for understanding whether climate regimes are characterized only by thermal conditions or also by moisture-related variability.

---

## 6.2 Precipitation Fluctuations

### Figure 5 — Precipitation Fluctuations

![Figure 5](Figure_5_Precipitation_Fluctuations.png)

The fluctuation analysis highlights the episodic nature of precipitation.

This variability is particularly relevant to the later compound hot-dry analysis because dry conditions are not simply represented by the long-term precipitation mean. Instead, the temporal organization of low-precipitation conditions becomes important.

---

# 7. Long-Term Temperature Behaviour

### Figure 3 — Long-Term T2M Behaviour

![Figure 3](Figure_3_LongTerm_Behavior_T2M.png)

The long-term temperature series provides the baseline against which regime transitions are interpreted.

The temporal evolution of the series demonstrates that the regional temperature record contains substantial variability superimposed on the long-term climate signal.

This is important because the Markov-switching approach does not attempt to replace long-term climate analysis. Instead, it decomposes the temporal behaviour into statistically distinguishable states.

---

# 8. Seasonality

### Figure 4 — Seasonal Cycle

![Figure 4](Figure_4_Seasonality_Cycle.png)

The seasonal cycle represents one of the strongest deterministic components of the regional climate system.

The presence of pronounced seasonality demonstrates why climate-state interpretation must be undertaken carefully. A statistical regime should not simply represent the normal difference between winter and summer.

Consequently, the subsequent regime analysis focuses on the statistical structure of the time series rather than merely reproducing the known annual temperature cycle.

---

# 9. Temporal Dependence

## 9.1 Autocorrelation

### Figure 6 — ACF

![Figure 6](Figure_6_ACF_All_Provinces.png)

The autocorrelation analysis indicates temporal dependence in the climate observations.

This is important because climate observations occurring close together in time are not necessarily statistically independent.

Persistent autocorrelation provides a statistical basis for examining whether periods of similar climate conditions form coherent episodes rather than appearing randomly.

---

## 9.2 Partial Autocorrelation

### Figure 7 — PACF

![Figure 7](Figure_7_PACF_All_Provinces.png)

The PACF analysis complements the ACF by identifying the contribution of individual lags after accounting for shorter-term dependencies.

Together, Figures 6 and 7 establish the temporal-memory structure of the series and provide an important diagnostic foundation for the subsequent state-dependent modelling.

---

# 10. Standardized Climate Anomalies

### Figure 9 — Standardized Anomalies

![Figure 9](Figure_9_Standardized_Anomalies_All_Provinces.png)

Standardization places climate observations on a common statistical scale.

This is particularly important for comparing:

* different provinces;
* different climate variables;
* thermal and moisture-related conditions.

The standardized climate panel is stored in:

`Standardized_Climate_Panel_1990_2025.xlsx`

The anomaly representation makes it easier to identify periods in which observations deviate substantially from their typical local conditions.

---

# 11. Hidden Markov Model Results

### Figure 8 — HMM Academic Regimes

![Figure 8](Figure_8_HMM_Academic_Regimes_All_Provinces.png)

The Hidden Markov Model provides the first explicit representation of the climate series as a sequence of latent states.

The HMM results indicate that observations can be organized into statistically distinguishable states with different temporal probabilities.

The importance of this result is conceptual: the observed climate record can be viewed as the manifestation of an underlying state process that is not directly observed.

The corresponding numerical results are contained in:

`HMM_Model_B_Regimes_All_Provinces.xlsx`

---

# 12. Markov-Switching Results

## 12.1 Two-Regime Model

### Figure 10 — Markov-Switching Tmax

![Figure 10](Figure_10_Markov_Switching_T2M_MAX.png)

The two-regime model provides the simplest representation of state-dependent temperature behaviour.

The model distinguishes observations according to their estimated regime membership and demonstrates that the temperature series can be represented through different statistical states rather than a single constant mean.

The two-regime output is provided in:

`Markov_Switching_2Regime_Analysis_1990_2025.xlsx`

---

# 13. Three-Regime Model

### Figure 11 — Three-Regime Markov-Switching Model

![Figure 11](Figure_11_Markov_Switching_3Regime_T2M_MAX.png)

The three-regime specification provides greater differentiation among climate states.

Instead of forcing observations into a simple low/high structure, the three-regime model allows an intermediate statistical state to emerge.

This is particularly useful when the climate distribution contains a relatively normal or transitional state between lower and higher temperature conditions.

---

## 13.1 Empirical Three-Regime Structure

### Figure 12 — Empirical Three-Regime Classification

![Figure 12](Figure_12_Empirical_3Regime_T2M_MAX.png)

The empirical classification illustrates how the estimated regimes are distributed across the observed time series.

The figure provides a temporal interpretation of regime membership and allows periods of sustained regime behaviour to be identified.

---

# 14. Four-Regime Sensitivity Analysis

### Figure 13 — Empirical Four-Regime Classification

![Figure 13](Figure_13_Empirical_4Regime_T2M_MAX.png)

The four-regime analysis represents a sensitivity test of model complexity.

An additional regime can improve the representation of the underlying distribution, but increased complexity is only justified when it produces statistically meaningful and interpretable improvements.

Therefore, the four-regime structure was evaluated alongside simpler specifications rather than automatically selected.

---

# 15. Model Selection Results

### Figure 14 — BIC Model Selection

![Figure 14](Figure_14_BIC_Model_Selection.png)

The model-selection analysis is one of the central components of the project.

The competing regime specifications were evaluated using:

* Akaike Information Criterion (AIC);
* Bayesian Information Criterion (BIC);
* log-likelihood.

The corresponding Excel outputs are:

`Markov_Model_Selection_AIC_BIC.xlsx`

and

`Markov_Regime_Comparison_Model_AB.xlsx`

The BIC is particularly useful because it introduces a stronger penalty for unnecessary model complexity.

The comparison demonstrates that regime selection should be based on an objective statistical criterion rather than simply choosing the model with the largest number of states.

This prevents overfitting and improves interpretability.

---

# 16. Regime-Specific Characteristics

### Figure 15 — Regime Means and Confidence Intervals

![Figure 15](Figure_15_Regime_Means_Confidence_Intervals.png)

The regime-specific means demonstrate that the identified states are characterized by different thermal conditions.

The confidence intervals provide an additional measure of separation among the states.

The corresponding Excel output is:

`Markov_Switching_Regime_Statistics.xlsx`

The regime statistics provide the basis for assigning meaningful descriptive interpretations to the states.

Importantly, regime labels such as *cool*, *normal*, or *warm* should be interpreted from the estimated statistical properties rather than imposed before model estimation.

---

# 17. Regime Probabilities

### Figure 16 — Temporal Regime Probabilities

![Figure 16](Figure_16_Regime_Probabilities_All_Provinces.png)

The regime-probability analysis provides one of the most informative results of the study.

Instead of assigning each observation to a state with complete certainty, the model estimates the probability that an observation belongs to each regime.

The temporal variation in these probabilities demonstrates that the dominant statistical state of the climate system changes through time.

The corresponding files are:

* `Markov_Switching_Regime_Probabilities.xlsx`
* `Markov_Switching_Regime_Probabilities_All_Provinces.xlsx`

This probabilistic interpretation is important because climate states are not necessarily separated by perfectly abrupt boundaries.

---

# 18. Most-Likely Regime

### Figure 17 — Most-Likely Regimes

![Figure 17](Figure_17_Most_Likely_Regimes_All_Provinces.png)

The most-likely regime classification converts the probabilistic output into a temporal sequence of dominant states.

The figure provides a clear visual representation of how the climate system moves between states.

Periods of consecutive observations assigned to the same regime represent persistent episodes, whereas rapid alternation among regimes indicates greater short-term instability.

The numerical classification is stored in:

`Markov_Switching_Most_Likely_Regimes_All_Provinces.xlsx`

---

# 19. Transition Dynamics

### Figure 18 — Transition Probability Matrix

![Figure 18](Figure_18_Transition_Matrix_Heatmap_All_Provinces.png)

The transition matrix represents the core of the Markov framework.

Each element represents the probability of moving from one climate state to another:

[
P_{ij}=P(S_t=j\mid S_{t-1}=i)
]

The diagonal values represent persistence, while the off-diagonal values describe transitions.

The analysis therefore answers questions that cannot be answered by a simple trend:

* How likely is a regime to continue?
* How likely is it to transition into a warmer state?
* How likely is a warmer state to return to a lower state?
* Which regimes have the greatest persistence?
* Which transitions occur most frequently?

The full numerical results are contained in:

`Markov_Switching_Transition_Matrices_All_Provinces.xlsx`

---

# 20. Regime Persistence

A major result of the study is that regime frequency and regime persistence represent different dimensions of climate behaviour.

A regime may occur frequently but remain active for only a short period.

Alternatively, a regime may occur less frequently but persist for substantially longer episodes.

This distinction is critical for climate-risk interpretation.

---

# 21. Expected Regime Duration

### Figure 19 — Expected Durations

![Figure 19](Figure_19_Expected_Durations_All_Provinces.png)

Expected duration is derived from the probability of remaining in the same state:

[
E(D_i)=\frac{1}{1-p_{ii}}
]

where (p_{ii}) represents the probability of remaining in regime (i).

The results therefore translate transition probabilities into a more intuitive measure of temporal persistence.

The numerical output is provided in:

`Markov_Switching_Expected_Durations_All_Provinces.xlsx`

---

# 22. Empirical Regime Duration

### Figure 20 — Empirical Durations

![Figure 20](Figure_20_Empirical_Durations_All_Provinces.png)

The empirical duration analysis identifies the actual lengths of consecutive regime episodes.

This provides an important complement to the theoretical expected-duration calculation.

Together, Figures 19 and 20 allow the model-based persistence structure to be compared with the observed temporal behaviour of the climate system.

---

# 23. High-Regime Persistence

### Figure 21 — High-Regime Duration Comparison

![Figure 21](Figure_21_High_Regime_Durations_Comparison.png)

The duration of higher-temperature regimes is particularly relevant for understanding climate stress.

The results indicate that the significance of a warm regime should not be evaluated exclusively through its frequency.

Its persistence is equally important.

A relatively high-temperature state that persists for several consecutive observations may have substantially different environmental implications from an isolated warm observation.

This is one of the major advantages of the Markov-switching framework.

---

# 24. Regime Frequencies

### Figure 22 — Regime Frequencies

![Figure 22](Figure_22_Regime_Frequencies_All_Provinces.png)

The frequency analysis quantifies how often individual regimes occur.

The corresponding output is:

`Markov_Switching_Regime_Frequencies.xlsx`

Frequency provides a complementary measure to persistence and duration.

The combined interpretation of:

[
Frequency + Persistence + Duration + Transition
]

provides a much richer characterization of climate-state behaviour than any single metric.

---

# 25. Inter-Provincial Differences

### Figure 24 — Inter-Provincial Regime Comparison

![Figure 24](Figure_24_Inter_Provincial_Comparison.png)

The inter-provincial analysis demonstrates that Southeastern Türkiye should not be treated as a perfectly homogeneous climatic system.

The provinces differ in their regime characteristics, including:

* dominant climate states;
* regime frequency;
* persistence;
* duration;
* transition structure.

The corresponding numerical output is:

`Analysis_18_Inter_Provincial_Comparison.xlsx`

This result has an important geographical implication.

Regional averages may conceal substantial differences in the internal temporal dynamics of individual locations.

---

# 26. Minimum Temperature Regimes

### Figure 25 — Inter-Provincial Tmin Comparison

![Figure 25](Figure_25_Inter_Provincial_TMIN_Comparison.png)

Minimum temperature provides an independent perspective on thermal regime behaviour.

The inclusion of Tmin is particularly important because nocturnal temperatures may exhibit different temporal dynamics from daytime maximum temperatures.

Therefore, the study demonstrates that the regional thermal system should not be represented exclusively through Tmax.

The corresponding results are stored in:

`Analysis_19_Inter_Provincial_TMIN_Comparison.xlsx`

---

# 27. Humidity Regimes

### Figure 27 — Humidity Distribution

![Figure 27](Figure_27_Global_Humidity_Distribution.png)

Humidity analysis extends the climate-regime framework beyond temperature.

The corresponding output is:

`Analysis_21_Global_Humidity_Regimes.xlsx`

Humidity provides important contextual information for interpreting thermal states.

A warm state under relatively dry atmospheric conditions may represent a different environmental condition from a warm state accompanied by higher atmospheric moisture.

Consequently, humidity adds a second dimension to the interpretation of regional climate regimes.

---

# 28. Multivariate Climate-Regime Analysis

### Figure 28 — Multivariate Regime Comparison

![Figure 28](Figure_28_Multi_Variable_Regime_Comparison.png)

The multivariate analysis examines whether multiple climate variables exhibit coordinated regime behaviour.

The corresponding output is:

`Analysis_22_Multi_Variable_Comparison.xlsx`

This represents an important methodological extension because climate systems are inherently multivariate.

Temperature, precipitation, and atmospheric moisture do not operate independently.

A multivariate regime framework therefore provides a more realistic representation of the underlying climate system than a purely univariate model.

---

# 29. Compound Hot-Dry Regimes

### Figure 30 — Integrated Multivariate Results

![Figure 30](Figure_30_Multivariate_Integrated_Results.png)

The compound hot-dry analysis represents one of the most important applied components of the study.

The corresponding Excel output is:

`Analysis_23_Triple_Compound_Hot_Dry.xlsx`

The objective is to identify conditions in which elevated thermal states and dry conditions occur together.

This is scientifically important because compound hot-dry events may generate greater environmental stress than either hot or dry conditions considered separately.

The compound framework therefore links statistical climate-state analysis to potential impacts on:

* water resources;
* agriculture;
* soil moisture;
* ecosystems;
* drought vulnerability;
* thermal stress;
* environmental management.

---

# 30. Integrated Results

The complete set of analyses demonstrates that climate variability in Southeastern Türkiye contains several interconnected dimensions.

## 30.1 Statistical Regime Structure

The HMM and Markov-switching results demonstrate that the observed climate series can be represented through latent statistical states.

---

## 30.2 Temporal Persistence

The transition matrices and duration analyses demonstrate that these states are not independent observations.

Some states show stronger temporal persistence than others.

---

## 30.3 Regime Switching

The climate system repeatedly transitions between different statistical conditions.

This indicates that the temporal structure of climate variability is dynamic rather than stationary in a simple descriptive sense.

---

## 30.4 Spatial Heterogeneity

The inter-provincial analyses demonstrate that regime characteristics vary spatially.

Consequently, regional climate change assessments should consider local differences in state persistence and transition behaviour.

---

## 30.5 Thermal Asymmetry

The separate Tmax and Tmin analyses indicate that daytime and nocturnal thermal behaviour should be considered independently.

---

## 30.6 Moisture Dimension

The humidity and precipitation analyses demonstrate that thermal regime interpretation is incomplete without considering atmospheric moisture.

---

## 30.7 Compound Climate Behaviour

The multivariate and hot-dry analyses demonstrate the importance of considering simultaneous changes in multiple climate variables.

---

# 31. Main Scientific Findings

The complete analytical framework leads to the following major findings.

### Finding 1 — Climate variability is regime-dependent

The regional climate series cannot be interpreted exclusively as a single homogeneous statistical process.

Distinct climate states emerge from the HMM and Markov-switching analyses.

---

### Finding 2 — Regimes possess different persistence characteristics

The transition matrices demonstrate that the probability of remaining in a state differs among regimes.

Consequently, some climate states are more persistent than others.

---

### Finding 3 — Regime duration is a critical climate indicator

Expected and empirical duration analyses demonstrate that the length of a climate episode provides information beyond simple frequency.

Persistent warm or anomalous regimes are particularly important from an environmental perspective.

---

### Finding 4 — Climate-state probability changes through time

The regime-probability analysis demonstrates temporal changes in the likelihood of individual states.

This indicates that the dominant statistical character of the climate system is not constant throughout the entire study period.

---

### Finding 5 — Provincial climate dynamics are heterogeneous

The inter-provincial analysis demonstrates that climate regimes are not distributed identically across Southeastern Türkiye.

This emphasizes the importance of location-specific analysis.

---

### Finding 6 — Tmin adds important information

Minimum temperature provides a complementary representation of regional thermal variability and allows nocturnal conditions to be evaluated independently from daytime conditions.

---

### Finding 7 — Humidity modifies climate-state interpretation

The humidity analysis demonstrates that thermal regimes should be interpreted within a broader atmospheric context.

---

### Finding 8 — Compound hot-dry conditions provide a more integrated risk perspective

The compound analysis demonstrates the importance of studying the simultaneous occurrence of thermal and moisture-related anomalies.

---

# 32. Why the Markov-Switching Framework Matters

The central methodological contribution of this project is the transition from:

```text
Trend
```

toward:

```text
Regime
   ↓
Persistence
   ↓
Transition
   ↓
Duration
   ↓
Frequency
   ↓
Compound Behaviour
```

A conventional trend model may estimate:

[
Y_t=\alpha+\beta t+\epsilon_t
]

and therefore summarize the average direction of change.

The Markov-switching framework instead allows:

[
Y_t=\mu_{S_t}+\epsilon_t
]

where the expected value depends on the current latent state.

This makes it possible to investigate the internal organization of climate variability.

---

# 33. Practical Climate Interpretation

The regime-based framework has potential applications in:

### Water Resources

Persistent dry regimes may indicate periods of increased hydrological stress.

### Agriculture

Persistent warm or compound hot-dry regimes may affect crop water requirements and agricultural productivity.

### Ecosystems

Long-lasting thermal and moisture anomalies may influence ecosystem functioning and vegetation stress.

### Drought Monitoring

Regime persistence can complement conventional drought indices by identifying statistically coherent climate states.

### Heat-Stress Assessment

Persistent warm regimes can provide a useful statistical basis for subsequent heat-stress analyses.

### Climate-Risk Assessment

Transition probabilities and expected durations can help characterize the temporal behaviour of climate hazards.

---

# 34. Limitations

The Markov-switching framework should not be interpreted as proving a causal mechanism.

The detected regimes represent **statistical states of the observed climate system**.

They should therefore not automatically be interpreted as direct evidence of specific physical mechanisms without additional atmospheric, oceanic, land-surface, or circulation-based analysis.

Furthermore:

* regime labels depend on model specification;
* the number of states influences interpretation;
* model selection criteria should be considered jointly;
* climate regimes may not correspond to physically discrete states;
* statistical persistence does not automatically imply causation;
* compound-event interpretation requires careful threshold definition.

These limitations are important for maintaining a scientifically conservative interpretation.

---

# 35. Reproducibility

The complete project was developed in **R**.

The repository contains:

* R analysis scripts;
* processed Excel datasets;
* statistical outputs;
* Markov-switching results;
* HMM results;
* model-selection results;
* transition matrices;
* regime probabilities;
* duration statistics;
* frequency statistics;
* inter-provincial comparisons;
* multivariate outputs;
* compound hot-dry results;
* graphical outputs.

The analytical workflow is therefore designed to be transparent and reproducible.

---

# 36. Repository Contents

```text
Hidden-Climate-Regimes/
│
├── R Scripts
│   ├── 1. Code.R
│   ├── 2. Code.R
│   ├── 3. Code.R
│   ├── ...
│   └── 23. Code.R
│
├── Excel Results
│   ├── Southeastern_Anatolia_Descriptive_Statistics_1990_2025.xlsx
│   ├── Southeastern_Anatolia_LongTerm_Behavior_Metrics.xlsx
│   ├── Standardized_Climate_Panel_1990_2025.xlsx
│   ├── ACF_PACF_Metrics_1990_2025.xlsx
│   ├── HMM_Model_B_Regimes_All_Provinces.xlsx
│   ├── Markov_Model_Selection_AIC_BIC.xlsx
│   ├── Markov_Regime_Comparison_Model_AB.xlsx
│   ├── Markov_Switching_2Regime_Analysis_1990_2025.xlsx
│   ├── Markov_Switching_3Regime_Analysis_1990_2025.xlsx
│   ├── Markov_Switching_Empirical_3Regime_Analysis.xlsx
│   ├── Markov_Switching_Empirical_4Regime_Analysis.xlsx
│   ├── Markov_Switching_Regime_Statistics.xlsx
│   ├── Markov_Switching_Regime_Probabilities.xlsx
│   ├── Markov_Switching_Regime_Probabilities_All_Provinces.xlsx
│   ├── Markov_Switching_Most_Likely_Regimes_All_Provinces.xlsx
│   ├── Markov_Switching_Transition_Matrices_All_Provinces.xlsx
│   ├── Markov_Switching_Expected_Durations_All_Provinces.xlsx
│   ├── Markov_Switching_Empirical_Durations_All_Provinces.xlsx
│   ├── Markov_Switching_Empirical_Durations_Table.xlsx
│   ├── Markov_Switching_Regime_Frequencies.xlsx
│   ├── Analysis_18_Inter_Provincial_Comparison.xlsx
│   ├── Analysis_19_Inter_Provincial_TMIN_Comparison.xlsx
│   ├── Analysis_21_Global_Humidity_Regimes.xlsx
│   ├── Analysis_22_Multi_Variable_Comparison.xlsx
│   ├── Analysis_23_Triple_Compound_Hot_Dry.xlsx
│   └── ...
│
├── Figures
│   ├── Figure 1
│   ├── Figure 2
│   ├── ...
│   └── Figure 30
│
└── README.md
```

---

# 37. Complete Figure Gallery

## Figure 1 — Tmax Distribution

![Figure 1](Figure_1_T2M_MAX_Boxplot.png)

## Figure 2 — Precipitation Trends

![Figure 2](Figure_2_Precipitation_Trends.png)

## Figure 3 — Long-Term T2M Behaviour

![Figure 3](Figure_3_LongTerm_Behavior_T2M.png)

## Figure 4 — Seasonal Cycle

![Figure 4](Figure_4_Seasonality_Cycle.png)

## Figure 5 — Precipitation Fluctuations

![Figure 5](Figure_5_Precipitation_Fluctuations.png)

## Figure 6 — ACF

![Figure 6](Figure_6_ACF_All_Provinces.png)

## Figure 7 — PACF

![Figure 7](Figure_7_PACF_All_Provinces.png)

## Figure 8 — HMM Academic Regimes

![Figure 8](Figure_8_HMM_Academic_Regimes_All_Provinces.png)

## Figure 9 — Standardized Anomalies

![Figure 9](Figure_9_Standardized_Anomalies_All_Provinces.png)

## Figure 10 — Markov-Switching Tmax

![Figure 10](Figure_10_Markov_Switching_T2M_MAX.png)

## Figure 11 — Three-Regime Markov-Switching

![Figure 11](Figure_11_Markov_Switching_3Regime_T2M_MAX.png)

## Figure 12 — Empirical Three-Regime Classification

![Figure 12](Figure_12_Empirical_3Regime_T2M_MAX.png)

## Figure 13 — Empirical Four-Regime Classification

![Figure 13](Figure_13_Empirical_4Regime_T2M_MAX.png)

## Figure 14 — BIC Model Selection

![Figure 14](Figure_14_BIC_Model_Selection.png)

## Figure 15 — Regime Means and Confidence Intervals

![Figure 15](Figure_15_Regime_Means_Confidence_Intervals.png)

## Figure 16 — Regime Probabilities

![Figure 16](Figure_16_Regime_Probabilities_All_Provinces.png)

## Figure 17 — Most-Likely Regimes

![Figure 17](Figure_17_Most_Likely_Regimes_All_Provinces.png)

## Figure 18 — Transition Matrix

![Figure 18](Figure_18_Transition_Matrix_Heatmap_All_Provinces.png)

## Figure 19 — Expected Regime Duration

![Figure 19](Figure_19_Expected_Durations_All_Provinces.png)

## Figure 20 — Empirical Regime Duration

![Figure 20](Figure_20_Empirical_Durations_All_Provinces.png)

## Figure 21 — High-Regime Duration Comparison

![Figure 21](Figure_21_High_Regime_Durations_Comparison.png)

## Figure 22 — Regime Frequencies

![Figure 22](Figure_22_Regime_Frequencies_All_Provinces.png)

## Figure 24 — Inter-Provincial Comparison

![Figure 24](Figure_24_Inter_Provincial_Comparison.png)

## Figure 25 — Inter-Provincial Tmin Comparison

![Figure 25](Figure_25_Inter_Provincial_TMIN_Comparison.png)

## Figure 27 — Humidity Distribution

![Figure 27](Figure_27_Global_Humidity_Distribution.png)

## Figure 28 — Multivariate Regime Comparison

![Figure 28](Figure_28_Multi_Variable_Regime_Comparison.png)

## Figure 30 — Integrated Multivariate Results

![Figure 30](Figure_30_Multivariate_Integrated_Results.png)

---

# 38. Conclusion

The present study develops a regime-oriented statistical framework for examining climate variability in Southeastern Türkiye during 1990–2025.

The analysis demonstrates that the regional climate system can be investigated through multiple statistical states characterized by different levels of occurrence, persistence, duration, and transition probability.

The principal contribution of the project is therefore not simply the detection of warming or drying trends. Instead, it is the identification of the **internal temporal structure of climate variability**.

The combined HMM and Markov-switching framework allows the study to investigate:

* hidden climate states;
* regime-specific behaviour;
* temporal probabilities;
* transition dynamics;
* regime persistence;
* expected duration;
* empirical duration;
* frequency;
* provincial heterogeneity;
* minimum-temperature behaviour;
* humidity regimes;
* multivariate climate states;
* compound hot-dry conditions.

The results suggest that understanding climate variability requires attention not only to the magnitude and direction of change, but also to the **state structure and temporal persistence of the climate system**.

In this sense, the study provides a methodological bridge between conventional climate variability analysis and more advanced **state-dependent climate dynamics**.

The framework can be extended in future research to:

* drought regimes;
* heatwave regimes;
* compound hot-dry extremes;
* precipitation regimes;
* future climate projections;
* climate-model ensemble analysis;
* teleconnection-driven regime transitions;
* extreme-event persistence;
* climate-risk assessment.

---

# Author

## Ahmet Solmaz

This project, including the data-processing workflow, statistical analyses, R-based computational procedures, Excel outputs, regime analysis, and graphical visualizations, was prepared by **Ahmet Solmaz**.

---

# Citation

**Solmaz, A.** *Hidden Climate Regimes: A Markov-Switching Analysis of Climate Variability in Southeastern Türkiye.*

If using the analytical framework, code, figures, or processed outputs, please provide appropriate attribution to the author.

---

# License

This repository is intended for academic and research purposes.

Please provide appropriate attribution when reusing the code, analytical outputs, figures, or derived results.

**© Ahmet Solmaz**
