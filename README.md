# Hidden Climate Regimes: A Markov-Switching Analysis of Climate Variability in Southeastern Türkiye

**Author:** Ahmet Solmaz
**Study Region:** Southeastern Türkiye
**Study Period:** 1990–2025
**Programming Environment:** R
**Primary Framework:** Markov-Switching Models and Hidden Markov Models

---

## Abstract

Climate variability is commonly examined through linear trends, anomalies, correlations, and conventional extreme-event indicators. Although these approaches are valuable, they generally assume that the underlying statistical behavior of a climate variable can be represented by a single continuous process. Such an assumption may be inadequate when the climate system alternates between distinct states characterized by different means, variances, persistence levels, and transition dynamics.

This study investigates the existence and temporal behavior of **hidden climate regimes in Southeastern Türkiye** using a Markov-switching framework. The analysis covers the 1990–2025 period and combines exploratory climate diagnostics, standardized anomalies, autocorrelation analysis, partial autocorrelation analysis, Hidden Markov Models (HMM), alternative Markov-switching specifications, information-criterion-based model selection, regime probabilities, transition matrices, persistence measures, empirical and expected regime durations, frequency analysis, inter-provincial comparisons, minimum-temperature regimes, humidity regimes, and multivariate/compound climate-state analysis.

The central objective is not simply to determine whether climate variables have increased or decreased. Instead, the study asks whether the regional climate system exhibits **statistically distinguishable states**, how frequently the system moves between these states, how persistent individual regimes are, and whether warm, dry, humid, or compound anomalous conditions occupy an increasingly important position within the regional climate variability structure.

The results indicate that climate variability in Southeastern Türkiye can be meaningfully investigated as a **regime-switching stochastic process rather than as a homogeneous time series**. The resulting framework provides information on regime persistence, transition dynamics, and state-specific behavior that cannot be obtained directly from conventional trend analysis alone.

---

# 1. Research Motivation

Southeastern Türkiye represents a particularly sensitive climatic environment because of its strong seasonal cycle, high summer temperatures, relatively dry atmospheric conditions, and substantial temporal variability in temperature and precipitation.

Conventional climate analysis generally focuses on questions such as:

> Is temperature increasing?

> Is precipitation decreasing?

> Are climate extremes becoming more frequent?

This project introduces a complementary question:

> **Does the statistical behavior of the climate system change between distinct and persistent regimes, and how does the system transition between these regimes?**

A Markov-switching framework is particularly appropriate for this purpose because the statistical properties of the observed climate variable are allowed to vary according to an unobserved state variable.

Consequently, the analysis moves from a purely trend-oriented perspective toward a **state-dependent interpretation of climate variability**.

---

# 2. Research Objectives

The study has six principal objectives:

1. To identify statistically distinguishable climate regimes in Southeastern Türkiye.
2. To characterize the statistical properties of each detected regime.
3. To estimate transition probabilities between climate states.
4. To quantify regime persistence and expected duration.
5. To compare alternative two-, three-, and four-regime specifications.
6. To investigate whether temperature, precipitation, humidity, and compound hot-dry conditions exhibit coherent regime structures.

Additional objectives include:

* evaluating temporal autocorrelation and memory;
* identifying the most probable regime at each observation;
* comparing empirical and model-based regime durations;
* evaluating differences among provinces;
* examining minimum-temperature behavior separately from maximum temperature;
* investigating humidity-related regimes;
* integrating multiple climate variables into a multivariate regime framework.

---

# 3. Study Region and Data

The analysis focuses on **Southeastern Türkiye** and covers the period **1990–2025**.

The repository contains processed climate datasets and analytical outputs for temperature and other climate variables. The principal variables represented in the analytical workflow include:

* Maximum air temperature (Tmax)
* Minimum air temperature (Tmin)
* Precipitation
* Relative humidity
* Standardized climate anomalies
* Multivariate climate indicators

The repository contains dedicated Excel outputs for descriptive statistics, standardized climate panels, autocorrelation/partial autocorrelation diagnostics, Markov-switching models, HMM regimes, regime probabilities, transition matrices, regime durations, regime frequencies, humidity regimes, multivariate comparisons, and compound hot-dry conditions.

---

# 4. Analytical Framework

The complete analytical workflow follows the structure:

```text
Climate Data
      ↓
Data Preparation and Quality Control
      ↓
Descriptive Statistics
      ↓
Long-Term Climate Behaviour
      ↓
Seasonality Analysis
      ↓
Standardization
      ↓
ACF / PACF Diagnostics
      ↓
Hidden Markov Model
      ↓
Markov-Switching Estimation
      ↓
2-, 3-, and 4-Regime Models
      ↓
AIC / BIC / Log-Likelihood Comparison
      ↓
Regime Identification
      ↓
Regime Probabilities
      ↓
Transition Probability Matrix
      ↓
Regime Persistence
      ↓
Expected and Empirical Durations
      ↓
Regime Frequencies
      ↓
Inter-Provincial Comparison
      ↓
Tmin and Humidity Regimes
      ↓
Multivariate and Compound Hot-Dry Analysis
```

---

# 5. Statistical Methodology

## 5.1 Descriptive Statistics

Initial statistical characterization was conducted using:

* mean;
* median;
* standard deviation;
* minimum;
* maximum;
* variability measures;
* long-term behavior metrics.

These statistics provide the baseline against which regime-specific characteristics can subsequently be interpreted.

The corresponding output is stored in:

`Southeastern_Anatolia_Descriptive_Statistics_1990_2025.xlsx`

and

`Southeastern_Anatolia_LongTerm_Behavior_Metrics.xlsx`

---

## 5.2 Standardized Climate Anomalies

Because the climate variables have different physical units and statistical scales, standardized anomalies were incorporated into the analytical workflow.

Standardization allows temporal deviations to be compared across provinces and variables without allowing the original measurement scale to dominate the multivariate analysis.

The processed standardized panel is provided in:

`Standardized_Climate_Panel_1990_2025.xlsx`

---

## 5.3 Seasonality

Climate time series in Southeastern Türkiye exhibit a pronounced seasonal cycle.

Therefore, the seasonal structure was examined before interpreting regime behavior.

This step is particularly important because an apparent regime pattern may otherwise reflect deterministic seasonal variability rather than a genuine change in the underlying statistical state.

---

## 5.4 Autocorrelation and Partial Autocorrelation

The temporal dependence structure was evaluated using:

* Autocorrelation Function (ACF)
* Partial Autocorrelation Function (PACF)

The results are provided in:

`ACF_PACF_Metrics_1990_2025.xlsx`

The ACF and PACF diagnostics demonstrate why temporal dependence must be considered when interpreting climate-state persistence. A climate observation is not necessarily independent of its preceding observations; consequently, consecutive observations can exhibit memory that is relevant to regime identification.

---

# 6. Hidden Markov Model

A Hidden Markov Model was used as a complementary framework for identifying latent climate states.

The HMM approach assumes that the observed climate series is generated by an underlying sequence of unobserved states.

The corresponding regime classifications are presented in:

`Figure_8_HMM_Academic_Regimes_All_Provinces.png`

and the numerical results are stored in:

`HMM_Model_B_Regimes_All_Provinces.xlsx`

The HMM analysis provides an important conceptual foundation for the subsequent Markov-switching analysis by demonstrating that climate observations can be represented through latent statistical states.

---

# 7. Markov-Switching Model

The central model is expressed as:

[
Y_t=\mu_{S_t}+\epsilon_t
]

where:

* (Y_t) is the observed climate variable;
* (\mu_{S_t}) is the regime-specific mean;
* (S_t) is the latent climate regime;
* (\epsilon_t) is the model residual.

The latent state follows a first-order Markov process:

[
P(S_t=j\mid S_{t-1}=i)=p_{ij}
]

where (p_{ij}) represents the probability of moving from state (i) to state (j).

The diagonal elements of the transition matrix,

[
p_{ii},
]

represent the probability of remaining in the same regime and therefore provide a direct measure of regime persistence.

---

# 8. Alternative Regime Specifications

To avoid imposing an arbitrary number of states, alternative specifications were examined.

### Two-Regime Specification

The two-state model provides a relatively simple distinction between lower and higher climate states.

### Three-Regime Specification

The three-state structure allows a more detailed separation between relatively cool/normal, warm, and more anomalous warm conditions.

### Four-Regime Specification

The four-state structure allows further subdivision of the climate distribution where statistically justified.

Importantly, regime labels were not treated as predetermined physical categories. Instead, interpretation was based on the estimated statistical characteristics of the states.

The corresponding model outputs include:

* `Markov_Switching_2Regime_Analysis_1990_2025.xlsx`
* `Markov_Switching_3Regime_Analysis_1990_2025.xlsx`
* `Markov_Switching_Empirical_3Regime_Analysis.xlsx`
* `Markov_Switching_Empirical_4Regime_Analysis.xlsx`

These files are accompanied by Figures 10–13.

---

# 9. Model Selection

Alternative regime specifications were evaluated using:

* Akaike Information Criterion (AIC);
* Bayesian Information Criterion (BIC);
* Log-Likelihood.

The model-selection results are contained in:

`Markov_Model_Selection_AIC_BIC.xlsx`

and

`Markov_Regime_Comparison_Model_AB.xlsx`

### Figure 14 — BIC Model Selection

![Figure 14 — BIC Model Selection](Figure_14_BIC_Model_Selection.png)

The BIC comparison provides an objective basis for determining whether additional regimes provide sufficient improvement in model fit to justify the increase in model complexity.

This is particularly important because a larger number of regimes will almost inevitably provide greater flexibility. The preferred specification therefore should not simply be the most complex model; it should provide an appropriate balance between goodness of fit, parsimony, interpretability, and statistical stability.

---

# 10. Climate Regime Characteristics

For each identified regime, the study evaluates:

* regime mean;
* variance;
* standard deviation;
* frequency;
* relative occurrence;
* expected duration;
* empirical duration;
* persistence probability;
* transition probability.

The corresponding numerical output is provided in:

`Markov_Switching_Regime_Statistics.xlsx`

### Figure 15 — Regime Means and Confidence Intervals

![Figure 15 — Regime Means and Confidence Intervals](Figure_15_Regime_Means_Confidence_Intervals.png)

Figure 15 demonstrates the statistical separation among the estimated climate regimes. The confidence intervals provide an additional indication of whether the regime-specific means are clearly differentiated rather than representing arbitrary divisions of a continuous distribution.

This distinction is fundamental to the interpretation of the Markov-switching model.

---

# 11. Regime Probabilities

The estimated probability of belonging to each regime was calculated throughout the study period.

The corresponding outputs are:

* `Markov_Switching_Regime_Probabilities.xlsx`
* `Markov_Switching_Regime_Probabilities_All_Provinces.xlsx`

### Figure 16 — Regime Probabilities

![Figure 16 — Regime Probabilities](Figure_16_Regime_Probabilities_All_Provinces.png)

The temporal evolution of regime probabilities demonstrates that the climate system does not remain statistically homogeneous throughout the entire 1990–2025 period.

Periods of greater probability for one regime are followed by periods in which another state becomes more dominant. This provides empirical evidence for interpreting climate variability through a regime-switching framework rather than exclusively through a single long-term mean.

---

# 12. Most Likely Climate Regime

The most likely regime was determined for each observation.

The corresponding dataset is:

`Markov_Switching_Most_Likely_Regimes_All_Provinces.xlsx`

### Figure 17 — Most Likely Regimes

![Figure 17 — Most Likely Regimes](Figure_17_Most_Likely_Regimes_All_Provinces.png)

This figure translates the probabilistic model into a temporal sequence of dominant climate states.

The result is particularly useful for identifying periods during which the regional climate system remained in relatively stable statistical states and periods characterized by rapid transitions.

---

# 13. Transition Probability Structure

The estimated transition matrices represent one of the most important outputs of the study.

The corresponding Excel file is:

`Markov_Switching_Transition_Matrices_All_Provinces.xlsx`

For a three-regime model:

[
P=
\begin{bmatrix}
p_{11}&p_{12}&p_{13}\
p_{21}&p_{22}&p_{23}\
p_{31}&p_{32}&p_{33}
\end{bmatrix}
]

where each row represents the origin regime and each column represents the destination regime.

### Figure 18 — Transition Probability Matrix

![Figure 18 — Transition Probability Matrix](Figure_18_Transition_Matrix_Heatmap_All_Provinces.png)

The transition matrices provide direct evidence of the persistence and switching structure of the regional climate system.

Large diagonal probabilities indicate that once the system enters a particular regime, it has a relatively high probability of remaining there during the following observation period.

Conversely, larger off-diagonal probabilities indicate greater mobility between climate states.

This provides information that is fundamentally different from a conventional linear trend coefficient.

---

# 14. Regime Persistence and Expected Duration

Regime persistence was evaluated through both theoretical expected duration and empirically observed duration.

The expected duration of a regime can be expressed as:

[
E(D_i)=\frac{1}{1-p_{ii}}
]

where (p_{ii}) is the probability of remaining in regime (i).

The relevant numerical outputs are:

* `Markov_Switching_Expected_Durations_All_Provinces.xlsx`
* `Markov_Switching_Empirical_Durations_All_Provinces.xlsx`
* `Markov_Switching_Empirical_Durations_Table.xlsx`

### Figure 19 — Expected Regime Durations

![Figure 19 — Expected Regime Durations](Figure_19_Expected_Durations_All_Provinces.png)

Figure 19 demonstrates the persistence structure of the identified regimes. Regimes with higher self-transition probabilities naturally produce longer expected durations.

### Figure 20 — Empirical Regime Durations

![Figure 20 — Empirical Regime Durations](Figure_20_Empirical_Durations_All_Provinces.png)

The empirical duration analysis complements the model-based expectation by showing the actual observed lengths of consecutive regime episodes.

The combination of Figures 19 and 20 provides a useful robustness perspective: expected persistence derived from the transition matrix can be compared with the duration of observed regime episodes.

---

# 15. Persistence of High-Temperature Regimes

### Figure 21 — High-Regime Duration Comparison

![Figure 21 — High-Regime Duration Comparison](Figure_21_High_Regime_Durations_Comparison.png)

The persistence of higher-temperature regimes is particularly important from a climate-change perspective.

The analysis demonstrates that the relevant question is not simply whether high temperatures occur. Rather, it is necessary to determine:

* how frequently high-temperature regimes occur;
* how long they persist;
* how likely they are to remain high;
* how readily they transition back to lower regimes.

Therefore, the Markov framework provides a more dynamic interpretation of warming-related climate variability than a conventional mean-temperature comparison.

---

# 16. Regime Frequency

### Figure 22 — Regime Frequencies

![Figure 22 — Regime Frequencies](Figure_22_Regime_Frequencies_All_Provinces.png)

The frequency analysis identifies the relative occurrence of different climate states.

Frequency and persistence should be interpreted jointly.

A regime can be frequent but short-lived, or relatively infrequent but highly persistent. Consequently, frequency alone cannot fully characterize the importance of a climate state.

The Excel output is:

`Markov_Switching_Regime_Frequencies.xlsx`

---

# 17. Inter-Provincial Climate-Regime Differences

One of the principal strengths of the project is the comparison of regime behavior across Southeastern Türkiye.

### Figure 24 — Inter-Provincial Comparison

![Figure 24 — Inter-Provincial Comparison](Figure_24_Inter_Provincial_Comparison.png)

The inter-provincial analysis demonstrates that climate-regime behavior is not spatially homogeneous.

Different provinces may differ in:

* regime frequency;
* regime persistence;
* transition structure;
* temperature-state distribution;
* duration of high-temperature conditions.

The corresponding Excel output is:

`Analysis_18_Inter_Provincial_Comparison.xlsx`

This comparison is particularly important because a regional average can obscure substantial differences in the temporal behavior of individual locations.

---

# 18. Minimum-Temperature Regimes

### Figure 25 — Inter-Provincial Tmin Comparison

![Figure 25 — Inter-Provincial Tmin Comparison](Figure_25_Inter_Provincial_TMIN_Comparison.png)

Minimum temperature provides a complementary perspective to maximum temperature.

Whereas Tmax primarily reflects daytime thermal conditions, Tmin is particularly informative for detecting changes in nocturnal thermal persistence.

The analysis therefore provides evidence that climate-regime research should not be restricted to daytime temperature alone.

The corresponding output is:

`Analysis_19_Inter_Provincial_TMIN_Comparison.xlsx`

---

# 19. Humidity Regimes

### Figure 27 — Humidity Distribution

![Figure 27 — Humidity Distribution](Figure_27_Global_Humidity_Distribution.png)

Humidity was examined as an additional component of the climate-regime system.

The corresponding numerical output is:

`Analysis_21_Global_Humidity_Regimes.xlsx`

The inclusion of humidity is scientifically important because temperature alone does not fully describe atmospheric thermal stress or moisture conditions.

Humidity regimes can alter the interpretation of warm conditions by distinguishing comparatively dry thermal states from warmer and more moisture-laden atmospheric states.

---

# 20. Multivariate Climate-Regime Analysis

### Figure 28 — Multivariate Regime Comparison

![Figure 28 — Multivariate Regime Comparison](Figure_28_Multi_Variable_Regime_Comparison.png)

The multivariate analysis extends the study beyond a single climate variable.

The corresponding output is:

`Analysis_22_Multi_Variable_Comparison.xlsx`

The purpose of this analysis is to determine whether the identified regime structure is limited to one variable or whether multiple components of the climate system exhibit coordinated state changes.

This represents an important methodological extension because regional climate variability is inherently multivariate.

---

# 21. Compound Hot-Dry Regimes

### Figure 30 — Integrated Multivariate Results

![Figure 30 — Multivariate Integrated Results](Figure_30_Multivariate_Integrated_Results.png)

The compound analysis represents one of the most important extensions of the project.

The corresponding Excel output is:

`Analysis_23_Triple_Compound_Hot_Dry.xlsx`

The analysis examines the possibility that high-temperature and dry conditions occur as part of the same climate-state structure.

This is more informative than analyzing temperature and precipitation independently because compound events may generate impacts that are stronger than those associated with either hazard individually.

The resulting framework therefore provides a transition from conventional climate variability analysis toward **compound climate-risk characterization**.

---

# 22. Complete Graphical Results

## Figure 1 — Tmax Distribution

![Figure 1](Figure_1_T2M_MAX_Boxplot.png)

The boxplot provides the initial comparison of maximum-temperature distributions and identifies differences in central tendency and variability among the analyzed locations.

---

## Figure 2 — Precipitation Trends

![Figure 2](Figure_2_Precipitation_Trends.png)

The precipitation series demonstrates the temporal variability of rainfall and provides the hydroclimatic background for the subsequent regime analysis.

---

## Figure 3 — Long-Term T2M Behaviour

![Figure 3](Figure_3_LongTerm_Behavior_T2M.png)

The long-term temperature behavior establishes the baseline temporal structure against which regime transitions are interpreted.

---

## Figure 4 — Seasonality Cycle

![Figure 4](Figure_4_Seasonality_Cycle.png)

The pronounced seasonal structure confirms the importance of accounting for periodic climate variability before interpreting latent regimes.

---

## Figure 5 — Precipitation Fluctuations

![Figure 5](Figure_5_Precipitation_Fluctuations.png)

The precipitation-fluctuation analysis illustrates the episodic and irregular nature of rainfall variability.

---

## Figure 6 — ACF

![Figure 6](Figure_6_ACF_All_Provinces.png)

The ACF results demonstrate temporal dependence within the climate series.

---

## Figure 7 — PACF

![Figure 7](Figure_7_PACF_All_Provinces.png)

The PACF complements the ACF analysis by identifying partial dependence at individual lags.

---

## Figure 8 — HMM Academic Regimes

![Figure 8](Figure_8_HMM_Academic_Regimes_All_Provinces.png)

The HMM classification provides a latent-state representation of climate variability.

---

## Figure 9 — Standardized Climate Anomalies

![Figure 9](Figure_9_Standardized_Anomalies_All_Provinces.png)

Standardized anomalies allow climate variability to be compared on a common statistical scale.

---

## Figure 10 — Markov-Switching Tmax

![Figure 10](Figure_10_Markov_Switching_T2M_MAX.png)

The Markov-switching representation demonstrates the temporal allocation of observations among statistically distinct states.

---

## Figure 11 — Three-Regime Markov-Switching Model

![Figure 11](Figure_11_Markov_Switching_3Regime_T2M_MAX.png)

The three-regime specification provides a more differentiated representation of the temperature-state structure.

---

## Figure 12 — Empirical Three-Regime Classification

![Figure 12](Figure_12_Empirical_3Regime_T2M_MAX.png)

The empirical classification translates the model states into an observed temporal sequence.

---

## Figure 13 — Empirical Four-Regime Classification

![Figure 13](Figure_13_Empirical_4Regime_T2M_MAX.png)

The four-regime structure provides an additional sensitivity analysis of regime complexity.

---

## Figure 14 — BIC Model Selection

![Figure 14](Figure_14_BIC_Model_Selection.png)

The BIC comparison provides the principal evidence for selecting an appropriate level of regime complexity.

---

## Figure 15 — Regime Means and Confidence Intervals

![Figure 15](Figure_15_Regime_Means_Confidence_Intervals.png)

The figure confirms the statistical differentiation of the estimated regimes.

---

## Figure 16 — Regime Probabilities

![Figure 16](Figure_16_Regime_Probabilities_All_Provinces.png)

The probability series reveal temporal changes in the likelihood of individual climate states.

---

## Figure 17 — Most Likely Regimes

![Figure 17](Figure_17_Most_Likely_Regimes_All_Provinces.png)

The most-likely-state sequence provides a compact representation of the temporal switching structure.

---

## Figure 18 — Transition Matrix

![Figure 18](Figure_18_Transition_Matrix_Heatmap_All_Provinces.png)

The transition matrix quantifies persistence and movement between regimes.

---

## Figure 19 — Expected Duration

![Figure 19](Figure_19_Expected_Durations_All_Provinces.png)

Expected duration quantifies the theoretical persistence of each regime.

---

## Figure 20 — Empirical Duration

![Figure 20](Figure_20_Empirical_Durations_All_Provinces.png)

Empirical duration provides an observed counterpart to model-based persistence.

---

## Figure 21 — High-Regime Duration

![Figure 21](Figure_21_High_Regime_Durations_Comparison.png)

High-regime duration highlights the persistence of elevated-temperature conditions.

---

## Figure 22 — Regime Frequency

![Figure 22](Figure_22_Regime_Frequencies_All_Provinces.png)

Frequency analysis quantifies the relative occurrence of the identified climate states.

---

## Figure 24 — Inter-Provincial Regime Comparison

![Figure 24](Figure_24_Inter_Provincial_Comparison.png)

The comparison highlights spatial heterogeneity in climate-regime behavior.

---

## Figure 25 — Tmin Comparison

![Figure 25](Figure_25_Inter_Provincial_TMIN_Comparison.png)

Minimum-temperature regimes provide an independent perspective on nocturnal thermal variability.

---

## Figure 27 — Humidity Distribution

![Figure 27](Figure_27_Global_Humidity_Distribution.png)

Humidity analysis expands the regime framework beyond temperature and precipitation.

---

## Figure 28 — Multivariate Regime Comparison

![Figure 28](Figure_28_Multi_Variable_Regime_Comparison.png)

The multivariate comparison investigates whether different climate variables exhibit coherent regime structures.

---

## Figure 30 — Integrated Multivariate Results

![Figure 30](Figure_30_Multivariate_Integrated_Results.png)

The integrated analysis summarizes the multivariate regime structure and provides the final synthesis of the study.

---

# 23. Main Findings

The combined results of the exploratory, HMM, Markov-switching, duration, transition, inter-provincial, humidity, and multivariate analyses support several major conclusions.

### 23.1 Climate variability is not statistically homogeneous

The results demonstrate that the climate system can be represented through distinguishable statistical states rather than a single invariant process.

This is the central finding of the study.

---

### 23.2 Regime persistence is an important component of climate variability

The transition matrices and duration analyses demonstrate that climate states possess different levels of persistence.

Therefore, the importance of a climate regime depends not only on its frequency but also on its ability to persist through consecutive observations.

---

### 23.3 Warm conditions should be interpreted dynamically

The analysis shows that elevated temperatures should not be evaluated exclusively through their long-term mean or linear trend.

A regime-oriented interpretation additionally asks:

* how often warm states occur;
* how long they persist;
* what states precede them;
* what states follow them;
* whether warm states repeatedly transition into more anomalous states.

---

### 23.4 Climate-regime behavior differs among provinces

The inter-provincial outputs demonstrate that Southeastern Türkiye should not be interpreted as a completely homogeneous climatic unit.

Different locations exhibit different combinations of:

* regime occurrence;
* persistence;
* transition structure;
* temperature characteristics;
* minimum-temperature behavior.

---

### 23.5 Tmax and Tmin provide complementary information

Maximum and minimum temperatures describe different components of regional thermal variability.

The inclusion of Tmin therefore strengthens the interpretation of the regional climate system by allowing daytime and nocturnal thermal behavior to be considered separately.

---

### 23.6 Humidity adds a second dimension to thermal interpretation

The humidity analysis demonstrates the importance of considering atmospheric moisture alongside temperature.

A regime-based framework therefore allows thermal states to be interpreted in relation to broader atmospheric conditions rather than temperature alone.

---

### 23.7 Compound hot-dry states represent an important extension

The compound analysis provides a transition from single-variable climate statistics toward integrated climate-risk characterization.

The co-occurrence of hot and dry conditions is particularly relevant for water resources, agriculture, ecosystem stress, and drought-related vulnerability in Southeastern Türkiye.

---

### 23.8 Markov-switching analysis provides information beyond conventional trend analysis

A linear trend describes the average direction of change.

A Markov-switching model additionally describes:

[
\text{State} \rightarrow \text{Persistence} \rightarrow \text{Transition} \rightarrow \text{Duration}
]

This makes it possible to investigate the internal temporal structure of climate variability.

---

# 24. Scientific Interpretation

The main conceptual contribution of this study is the treatment of regional climate variability as a **dynamic stochastic system with multiple latent states**.

Under a conventional framework, a temperature series can be represented approximately as:

[
Y_t=\alpha+\beta t+\epsilon_t
]

where (\beta) represents the long-term trend.

The Markov-switching framework instead allows:

[
Y_t=\mu_{S_t}+\epsilon_t
]

where the statistical expectation changes according to the latent regime (S_t).

This distinction is scientifically important.

A climate system can exhibit a modest overall trend while simultaneously undergoing substantial changes in:

* regime frequency;
* regime persistence;
* transition probability;
* duration;
* variance;
* compound-state occurrence.

Therefore, the absence of a very large linear trend does not necessarily imply that the underlying climate variability structure is unchanged.

---

# 25. Reproducibility

All analyses were conducted in **R**.

The repository provides:

* R scripts;
* processed Excel datasets;
* Markov-switching outputs;
* HMM outputs;
* model-selection results;
* transition matrices;
* regime probabilities;
* duration statistics;
* frequency statistics;
* multivariate analyses;
* graphical outputs.

The repository therefore provides a transparent computational framework through which the analytical workflow can be examined and reproduced.

---

# 26. Repository Structure

```text
Hidden-Climate-Regimes/
│
├── R Scripts
│   ├── 1. Code.R
│   ├── 2. Code.R
│   ├── 3. Code.R
│   ├── ...
│   ├── 23. Code.R
│
├── Excel Results
│   ├── ACF_PACF_Metrics_1990_2025.xlsx
│   ├── HMM_Model_B_Regimes_All_Provinces.xlsx
│   ├── Markov_Model_Selection_AIC_BIC.xlsx
│   ├── Markov_Regime_Comparison_Model_AB.xlsx
│   ├── Markov_Switching_2Regime_Analysis_1990_2025.xlsx
│   ├── Markov_Switching_3Regime_Analysis_1990_2025.xlsx
│   ├── Markov_Switching_Empirical_3Regime_Analysis.xlsx
│   ├── Markov_Switching_Empirical_4Regime_Analysis.xlsx
│   ├── Markov_Switching_Empirical_Durations_All_Provinces.xlsx
│   ├── Markov_Switching_Empirical_Durations_Table.xlsx
│   ├── Markov_Switching_Expected_Durations_All_Provinces.xlsx
│   ├── Markov_Switching_Most_Likely_Regimes_All_Provinces.xlsx
│   ├── Markov_Switching_Regime_Frequencies.xlsx
│   ├── Markov_Switching_Regime_Probabilities.xlsx
│   ├── Markov_Switching_Regime_Probabilities_All_Provinces.xlsx
│   ├── Markov_Switching_Regime_Statistics.xlsx
│   ├── Markov_Switching_Transition_Matrices_All_Provinces.xlsx
│   ├── Southeastern_Anatolia_Descriptive_Statistics_1990_2025.xlsx
│   ├── Southeastern_Anatolia_LongTerm_Behavior_Metrics.xlsx
│   ├── Standardized_Climate_Panel_1990_2025.xlsx
│   └── ...
│
├── Figures
│   ├── Figure 1–30
│   └── PNG outputs
│
└── README.md
```

The repository currently contains the complete collection of these analytical Excel outputs and graphical results.

---

# 27. Conclusion

This study demonstrates the value of a regime-based approach for investigating climate variability in Southeastern Türkiye.

The principal conclusion is that climate variability should not necessarily be represented as a single, temporally stable statistical process. Instead, the regional climate system can be investigated as a dynamic process characterized by multiple states, different levels of persistence, and probabilistic transitions between regimes.

The Markov-switching framework provides a quantitative description of this behavior through:

* regime-specific statistics;
* transition probabilities;
* persistence probabilities;
* expected durations;
* empirical durations;
* regime frequencies;
* temporal regime probabilities;
* inter-provincial differences;
* multivariate climate states;
* compound hot-dry conditions.

The study therefore moves beyond the conventional question:

> **“Is the climate getting warmer or drier?”**

and addresses a more structurally informative question:

> **“How does the regional climate system move between different statistical states, how persistent are those states, and how is the structure of climate variability changing?”**

This perspective provides an additional methodological framework for climate variability research in Southeastern Türkiye and may be particularly valuable for future investigations of climate extremes, drought, heat stress, compound hazards, and regional climate risk.

---

# Author

## Ahmet Solmaz

**Geography and Climate Research — Türkiye**

This research project, including the statistical analyses, R-based computational workflow, Excel outputs, regime analysis, and visualizations, was prepared by **Ahmet Solmaz**.

---

## Citation

If you use the methodology, code, processed outputs, figures, or analytical framework of this repository, please provide appropriate attribution to:

**Solmaz, A. — Hidden Climate Regimes: A Markov-Switching Analysis of Climate Variability in Southeastern Türkiye.**

---

## License

This repository is intended for academic and research purposes.

Please provide appropriate attribution when reusing the code, analytical outputs, figures, or derived results.

© Ahmet Solmaz
