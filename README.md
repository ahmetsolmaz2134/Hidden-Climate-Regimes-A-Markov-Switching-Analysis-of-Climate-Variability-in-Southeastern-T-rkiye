# Hidden Climate Regimes: A Markov-Switching Analysis of Climate Variability in Southeastern Türkiye

<p align="center">
  <img src="Figure_14_BIC_Model_Selection.png" width="850">
</p>

## Abstract

Climate variability is not necessarily characterized by a uniform and temporally stable statistical structure. Climatic systems may alternate between relatively cool, warm, wet, dry, humid, and compound hydroclimatic states, with each state exhibiting different persistence and transition characteristics. Conventional trend-based approaches are often insufficient to capture such nonlinear and state-dependent behavior.

This study investigates the existence, persistence, transition dynamics, and spatial differentiation of hidden climate regimes across nine provinces of Southeastern Türkiye during the 1990–2025 period. Monthly maximum air temperature (T2M_MAX), minimum air temperature (T2M_MIN), precipitation (PRECTOTCORR), and relative humidity (RH2M) were analyzed using Hidden Markov Model (HMM) and Markov-Switching frameworks.

The analysis combines exploratory climatological diagnostics, autocorrelation and partial autocorrelation analysis, standardized anomalies, HMM-based regime identification, Markov-Switching model comparison, Akaike Information Criterion (AIC), Bayesian Information Criterion (BIC), transition probabilities, theoretical expected regime durations, empirical spell durations, regime frequencies, inter-provincial comparisons, humidity regimes, multivariable climate-state analysis, and compound hot–dry event assessment.

A total of 36 province-variable combinations were evaluated under two-, three-, and four-regime specifications. BIC selected the four-regime specification for 33 of the 36 cases, while the three-regime specification was preferred in only three cases. This strong model-selection result indicates that climate variability across Southeastern Türkiye is generally better represented by a multi-state structure than by a simple two-state framework.

The results reveal pronounced spatial differentiation. Şanlıurfa and Kilis exhibit the highest maximum-temperature regimes, whereas Siirt and Şırnak generally occupy cooler regimes. Compound hot–dry conditions are particularly prominent in Şanlıurfa, Mardin, Batman, Diyarbakır, and Şırnak. Şanlıurfa exhibits the highest compound hot–dry frequency (33.10%), with a mean spell duration of approximately 3.76 months and a maximum observed spell of five months.

The findings demonstrate that Markov-Switching analysis provides a useful framework for investigating nonlinear and persistent climate variability and for identifying spatially differentiated hydroclimatic risk regimes in Southeastern Türkiye.

---

# 1. Research Objectives

The principal objective of this research is to identify whether climate variability in Southeastern Türkiye can be represented through distinct latent statistical regimes rather than a single homogeneous process.

The study addresses the following research questions:

1. How many statistically distinguishable climate regimes characterize the monthly climate variability of Southeastern Türkiye?
2. Is a two-, three-, or four-regime specification statistically more appropriate?
3. How persistent are individual climate regimes?
4. What are the probabilities of remaining within or transitioning between regimes?
5. How do regime characteristics differ among provinces?
6. Are high-temperature and low-humidity conditions spatially concentrated?
7. How frequently do warm and dry conditions occur simultaneously?
8. Do the identified regimes provide additional information beyond conventional descriptive climatology?

The broader aim is to demonstrate that climate variability should not always be interpreted solely through linear trends. Instead, the temporal structure of climate may involve repeated transitions among relatively stable statistical states.

---

# 2. Study Area

The analysis covers nine provinces representing Southeastern Türkiye:

* Adıyaman
* Batman
* Diyarbakır
* Gaziantep
* Kilis
* Mardin
* Siirt
* Şırnak
* Şanlıurfa

The region is characterized by strong spatial gradients in elevation, continentality, precipitation, temperature, humidity, and seasonal climate variability.

These characteristics make Southeastern Türkiye an appropriate region for investigating spatially heterogeneous climate regimes.

---

# 3. Data and Study Period

The analysis covers the period:

**1990–2025**

with monthly observations.

Four principal climate variables were investigated:

| Variable    | Description                     |
| ----------- | ------------------------------- |
| T2M_MAX     | Monthly maximum air temperature |
| T2M_MIN     | Monthly minimum air temperature |
| PRECTOTCORR | Corrected precipitation         |
| RH2M        | Relative humidity               |

The resulting dataset provides a maximum theoretical temporal length of:

**36 years × 12 months = 432 monthly observations per province-variable series.**

Across nine provinces and four climate variables, the study evaluates:

**36 province-variable combinations.**

---

# 4. Analytical Framework

The analytical workflow consists of several interconnected stages.

```text
Climate Data
     ↓
Descriptive Statistics
     ↓
Seasonality and Long-Term Behavior
     ↓
ACF / PACF Diagnostics
     ↓
Standardized Anomalies
     ↓
HMM Regime Identification
     ↓
Markov-Switching Models
     ↓
2 / 3 / 4 Regime Comparison
     ↓
AIC / BIC Model Selection
     ↓
Regime Characteristics
     ↓
Transition Probabilities
     ↓
Expected Durations
     ↓
Empirical Durations
     ↓
Regime Frequencies
     ↓
Inter-Provincial Comparison
     ↓
Humidity and Multivariable Regimes
     ↓
Compound Hot–Dry Conditions
```

---

# 5. Exploratory Climate Diagnostics

## 5.1 Maximum Temperature Distribution

![Figure 1 – T2M\_MAX Boxplot](Figure_1_T2M_MAX_Boxplot.png)

**Figure 1.** Distribution of monthly maximum air temperature across the study provinces.

The boxplot demonstrates substantial spatial heterogeneity in maximum temperature. The distributional differences provide an initial indication that a single homogeneous climatic state may not adequately describe the region.

---

## 5.2 Precipitation Trends

![Figure 2 – Precipitation Trends](Figure_2_Precipitation_Trends.png)

**Figure 2.** Long-term precipitation behavior across Southeastern Türkiye.

Precipitation exhibits pronounced temporal variability and spatial differentiation. Unlike temperature, precipitation does not necessarily follow a uniform monotonic pattern, reinforcing the importance of state-based approaches.

---

## 5.3 Long-Term Temperature Behavior

![Figure 3 – Long-Term Temperature Behavior](Figure_3_LongTerm_Behavior_T2M.png)

**Figure 3.** Long-term behavior of maximum temperature.

The long-term temperature series reveal substantial temporal variability superimposed on the seasonal cycle. This structure motivates the investigation of latent states that may persist for several consecutive months.

---

## 5.4 Seasonal Cycle

![Figure 4 – Seasonality Cycle](Figure_4_Seasonality_Cycle.png)

**Figure 4.** Seasonal cycle of climate variability.

The strong seasonal structure is an important characteristic of the dataset. Consequently, the interpretation of Markov regimes should distinguish genuine persistence of climate states from deterministic seasonal repetition.

---

## 5.5 Precipitation Fluctuations

![Figure 5 – Precipitation Fluctuations](Figure_5_Precipitation_Fluctuations.png)

**Figure 5.** Temporal variability of precipitation.

The precipitation series display considerably greater short-term variability than temperature, indicating that precipitation regimes may be particularly sensitive to persistence and transition structure.

---

# 6. Temporal Dependence

## 6.1 Autocorrelation Function

![Figure 6 – ACF](Figure_6_ACF_All_Provinces.png)

**Figure 6.** Autocorrelation functions for the analyzed climate variables.

The ACF analysis indicates temporal dependence within the monthly climate series. Such dependence is essential for Markov-Switching analysis because climate states are not independent from one month to the next.

---

## 6.2 Partial Autocorrelation Function

![Figure 7 – PACF](Figure_7_PACF_All_Provinces.png)

**Figure 7.** Partial autocorrelation functions.

The PACF analysis provides additional information concerning the short-memory structure of the climate variables and supports the identification of temporal dependence prior to regime modeling.

---

# 7. Hidden Markov Model Regime Identification

![Figure 8 – HMM Regimes](Figure_8_HMM_Academic_Regimes_All_Provinces.png)

**Figure 8.** HMM-derived climate regimes across the study provinces.

The HMM framework identifies latent states according to the statistical properties of the observed climate variables. These states should be interpreted as **statistical climate regimes**, rather than as direct physical atmospheric classifications.

The regime framework provides a foundation for subsequent Markov-Switching analysis by identifying periods characterized by relatively similar statistical behavior.

---

# 8. Standardized Climate Anomalies

![Figure 9 – Standardized Anomalies](Figure_9_Standardized_Anomalies_All_Provinces.png)

**Figure 9.** Standardized climate anomalies for the analyzed variables.

Standardization allows the temporal behavior of different climate variables and provinces to be compared on a common scale.

Positive and negative anomalies provide a complementary perspective to the latent regime classification.

---

# 9. Markov-Switching Analysis

## 9.1 Two-Regime Markov-Switching Model

![Figure 10 – Markov-Switching T2M\_MAX](Figure_10_Markov_Switching_T2M_MAX.png)

**Figure 10.** Two-regime Markov-Switching representation of maximum temperature.

The two-regime model provides a simplified representation of climate variability. However, model-selection results demonstrate that this specification is generally insufficient to capture the full complexity of the analyzed climate system.

---

## 9.2 Three-Regime Model

![Figure 11 – Three-Regime Markov-Switching](Figure_11_Markov_Switching_3Regime_T2M_MAX.png)

**Figure 11.** Three-regime Markov-Switching representation.

The three-regime framework provides greater flexibility than the two-state specification and is retained as an alternative model for comparison and sensitivity assessment.

---

## 9.3 Empirical Three-Regime Durations

![Figure 12 – Empirical Three-Regime Durations](Figure_12_Empirical_3Regime_T2M_MAX.png)

**Figure 12.** Empirical durations of three-regime climate states.

Observed spell durations provide an empirical complement to theoretical Markov expectations.

---

## 9.4 Empirical Four-Regime Durations

![Figure 13 – Empirical Four-Regime Durations](Figure_13_Empirical_4Regime_T2M_MAX.png)

**Figure 13.** Empirical durations of four-regime climate states.

The four-regime structure provides additional resolution for distinguishing intermediate and extreme climate states.

---

# 10. Model Selection

![Figure 14 – BIC Model Selection](Figure_14_BIC_Model_Selection.png)

**Figure 14.** BIC-based comparison of two-, three-, and four-regime Markov-Switching models.

A total of **36 province-variable combinations** were evaluated.

The BIC results show:

* **33/36 cases: four-regime model selected**
* **3/36 cases: three-regime model selected**
* **0/36 cases: two-regime model selected**

The three exceptions were:

* Kilis — precipitation
* Mardin — precipitation
* Siirt — minimum temperature

This result is one of the principal findings of the study.

The dominance of the four-regime specification suggests that the climate variability of Southeastern Türkiye is generally characterized by more than a simple low/high state structure.

Importantly, model selection is based on statistical information criteria and does not imply that four physical climate mechanisms necessarily exist. The four regimes represent statistically distinguishable latent states.

---

# 11. Regime Characteristics

![Figure 15 – Regime Means and Confidence Intervals](Figure_15_Regime_Means_Confidence_Intervals.png)

**Figure 15.** Estimated regime means and 95% confidence intervals.

The estimated regime means demonstrate substantial separation between the latent states.

For maximum temperature, the four-regime structure generally corresponds to progressively warmer statistical states.

For example, the estimated T2M_MAX regime means show particularly high values in Şanlıurfa and Kilis, while Siirt and Şırnak generally occupy cooler distributions.

This spatial differentiation demonstrates that regime characteristics are geographically structured rather than randomly distributed.

---

# 12. Regime Probabilities

![Figure 16 – Regime Probabilities](Figure_16_Regime_Probabilities_All_Provinces.png)

**Figure 16.** Posterior regime probabilities across provinces.

The posterior probabilities indicate the temporal uncertainty associated with regime assignment.

Rather than treating every month as deterministically belonging to a state, the probabilistic framework allows each observation to have different levels of membership in the latent regimes.

This is particularly important during transition periods, when the climate system may not clearly correspond to one state.

---

# 13. Most Likely Regimes

![Figure 17 – Most Likely Regimes](Figure_17_Most_Likely_Regimes_All_Provinces.png)

**Figure 17.** Most likely regime classification across provinces.

The most-probable-regime sequence provides a simplified temporal representation of the hidden state dynamics.

Periods of sustained regime membership indicate persistence, whereas rapid changes indicate transitional behavior.

---

# 14. Transition Probabilities

![Figure 18 – Transition Matrix](Figure_18_Transition_Matrix_Heatmap_All_Provinces.png)

**Figure 18.** Transition probability matrices.

The Markov transition matrix is defined as:

[
P_{ij}=P(S_t=j\mid S_{t-1}=i)
]

where (S_t) denotes the latent climate regime at time (t).

The diagonal elements:

[
P_{ii}
]

represent the probability that a climate regime persists from one month to the next.

High diagonal probabilities therefore indicate strong temporal persistence.

The transition matrices also reveal whether climate states tend to evolve gradually between neighboring regimes or undergo more abrupt transitions.

---

# 15. Expected Regime Durations

![Figure 19 – Expected Durations](Figure_19_Expected_Durations_All_Provinces.png)

**Figure 19.** Theoretical expected durations of climate regimes.

For a first-order Markov process, the expected duration of regime (i) is:

[
E(D_i)=\frac{1}{1-P_{ii}}
]

where (P_{ii}) is the probability of remaining in regime (i).

This metric transforms transition probabilities into an interpretable measure of persistence.

The results indicate that some climate states are considerably more persistent than others. Such persistence is particularly important from an environmental-risk perspective because prolonged exposure to warm, dry, or low-humidity conditions can produce impacts that are substantially different from isolated monthly anomalies.

---

# 16. Empirical Regime Durations

![Figure 20 – Empirical Durations](Figure_20_Empirical_Durations_All_Provinces.png)

**Figure 20.** Empirically observed regime durations.

The empirical duration analysis complements the theoretical Markov expectation.

Comparing theoretical and observed durations provides a useful model-diagnostic perspective. Consistency between the two measures increases confidence that the transition matrix captures meaningful persistence, whereas substantial divergence may indicate that the simple first-order Markov assumption does not fully represent the observed spell structure.

---

# 17. High-Regime Persistence

![Figure 21 – High Regime Duration Comparison](Figure_21_High_Regime_Durations_Comparison.png)

**Figure 21.** Comparison of high-temperature regime durations.

The persistence of high-temperature regimes is particularly relevant for climate-impact assessment.

Prolonged warm conditions may increase:

* evaporative demand,
* irrigation requirements,
* agricultural water stress,
* heat exposure,
* ecosystem stress,
* wildfire susceptibility,
* and compound hot–dry risk.

The importance of these effects depends not only on the frequency of warm regimes but also on their persistence.

---

# 18. Regime Frequencies

![Figure 22 – Regime Frequencies](Figure_22_Regime_Frequencies_All_Provinces.png)

**Figure 22.** Frequency distribution of latent regimes.

Regime frequency provides a complementary measure to persistence.

A regime can be:

* frequent but short-lived,
* infrequent but highly persistent,
* or both frequent and persistent.

Therefore, frequency and duration should be interpreted jointly rather than independently.

---

# 19. Inter-Provincial Climate Comparison

![Figure 24 – Inter-Provincial Comparison](Figure_24_Inter_Provincial_Comparison.png)

**Figure 24.** Inter-provincial comparison of maximum temperature, humidity, and precipitation.

The mean maximum temperature ranking indicates a pronounced spatial gradient.

Approximate mean T2M_MAX values are:

| Province   | Mean T2M_MAX |
| ---------- | -----------: |
| Şanlıurfa  |  **30.26°C** |
| Kilis      |  **30.15°C** |
| Gaziantep  |      28.33°C |
| Mardin     |      28.29°C |
| Diyarbakır |      28.19°C |
| Batman     |      28.17°C |
| Siirt      |      26.65°C |
| Şırnak     |      26.49°C |
| Adıyaman   |      22.97°C |

Şanlıurfa and Kilis therefore represent the warmest environments within the analyzed network, whereas Siirt and Şırnak exhibit substantially lower mean maximum temperatures.

These spatial differences are consistent with the regime-level results.

---

# 20. Minimum Temperature Comparison

![Figure 25 – TMIN Comparison](Figure_25_Inter_Provincial_TMIN_Comparison.png)

**Figure 25.** Inter-provincial comparison of minimum temperature.

Minimum temperature provides additional information about nocturnal thermal conditions.

The inclusion of T2M_MIN is important because climate impacts are not determined exclusively by daytime maximum temperature. Persistent changes in minimum temperature can affect:

* crop phenology,
* frost risk,
* respiration rates,
* nighttime heat stress,
* energy demand,
* and ecosystem functioning.

---

# 21. Humidity Regimes

![Figure 27 – Humidity Regimes](Figure_27_Global_Humidity_Distribution.png)

**Figure 27.** Distribution of high-, normal-, and low-humidity regimes.

Humidity regimes exhibit strong spatial differentiation.

Examples include:

* **Adıyaman:** high humidity ≈ 45.14%
* **Kilis:** normal humidity ≈ 55.09%
* **Batman:** low humidity ≈ 37.96%
* **Mardin:** low humidity ≈ 39.35%
* **Şırnak:** low humidity ≈ 40.74%
* **Şanlıurfa:** low humidity ≈ 39.35%

The prevalence of low-humidity states in several provinces is particularly important when combined with high-temperature regimes because low humidity can enhance atmospheric evaporative demand and intensify surface moisture stress.

---

# 22. Multivariable Climate Regimes

![Figure 28 – Multivariable Regime Comparison](Figure_28_Multi_Variable_Regime_Comparison.png)

**Figure 28.** Multivariable comparison of high-temperature, low-precipitation, and low-humidity conditions.

The multivariable analysis indicates that temperature, precipitation, and humidity regimes do not operate independently.

Şanlıurfa shows particularly high frequencies of:

* high T2M_MAX,
* high T2M_MIN,
* low precipitation,
* and low humidity.

Similarly, Mardin and Şırnak exhibit pronounced combinations of warm and dry atmospheric conditions.

This provides evidence that hydroclimatic risk should be evaluated through multiple interacting variables rather than temperature alone.

---

# 23. Integrated Multivariate Climate Structure

![Figure 30 – Integrated Multivariate Results](Figure_30_Multivariate_Integrated_Results.png)

**Figure 30.** Integrated representation of the multivariate climate-regime structure.

The integrated analysis demonstrates that the region contains spatially differentiated combinations of thermal, precipitation, and atmospheric-moisture states.

This result is particularly important for climate-impact assessment because environmental impacts are often driven by combinations of climatic stressors rather than isolated variables.

---

# 24. Compound Hot–Dry Conditions

One of the most important results of the study concerns the simultaneous occurrence of high-temperature and dry conditions.

The compound-event results are summarized below:

| Province      | Hot–Dry Frequency |      Mean Spell | Maximum Spell |
| ------------- | ----------------: | --------------: | ------------: |
| **Şanlıurfa** |        **33.10%** | **3.76 months** |  **5 months** |
| Mardin        |            30.56% |     3.57 months |      5 months |
| Batman        |            28.94% |     3.47 months |      5 months |
| Diyarbakır    |            28.24% |     3.39 months |      5 months |
| Şırnak        |            28.01% |     3.36 months |      5 months |
| Siirt         |            26.85% |     3.22 months |      5 months |
| Gaziantep     |            23.61% |     2.62 months |      4 months |
| Adıyaman      |            16.67% |     2.18 months |      4 months |
| Kilis         |         **4.40%** | **1.12 months** |  **2 months** |

The highest compound hot–dry frequency occurs in **Şanlıurfa (33.10%)**, followed by Mardin (30.56%) and Batman (28.94%).

The mean duration of compound hot–dry spells is also highest in Şanlıurfa, reaching approximately **3.76 months**.

This combination is particularly important because prolonged simultaneous heat and dryness can increase:

* soil moisture deficits,
* irrigation demand,
* agricultural drought stress,
* vegetation stress,
* evapotranspiration,
* wildfire potential,
* and pressure on water resources.

The results therefore suggest that the southern and southeastern portions of the study region may face disproportionately high compound hydroclimatic stress.

---

# 25. Principal Findings

The principal findings of the study can be summarized as follows.

### 25.1 Four-regime models dominate model selection

Out of 36 province-variable combinations:

**33 selected the four-regime specification**, while only three selected the three-regime specification.

No two-regime model was selected as optimal by BIC.

This represents strong statistical evidence that climate variability is generally better represented by a multi-state framework.

### 25.2 Climate regimes exhibit persistence

The transition matrices reveal substantial within-regime persistence.

The expected-duration framework demonstrates that some states can persist for several consecutive months rather than appearing only as isolated anomalies.

### 25.3 Strong spatial differentiation exists

Şanlıurfa and Kilis generally exhibit the highest thermal regime characteristics, whereas Siirt and Şırnak occupy cooler thermal conditions.

This spatial differentiation is consistent across descriptive statistics and regime-based analyses.

### 25.4 Humidity regimes are spatially heterogeneous

Low-humidity states are particularly frequent in Şırnak, Mardin, Şanlıurfa, Batman, and Siirt.

This increases the potential significance of compound thermal-dryness conditions.

### 25.5 Compound hot–dry conditions are concentrated in specific provinces

Şanlıurfa records the highest compound hot–dry frequency:

**33.10%**

with a mean spell duration of:

**3.76 months**

and a maximum observed spell of:

**5 months.**

### 25.6 Temperature alone does not describe the full climate risk

The multivariable analysis demonstrates that high temperature, low precipitation, and low humidity can occur in overlapping temporal regimes.

This supports a transition from single-variable climate analysis toward compound-risk assessment.

---

# 26. Interpretation of the Hidden Regimes

The identified regimes should be interpreted as **latent statistical states** rather than directly as physical atmospheric mechanisms.

For example, a high-temperature regime represents a statistical state characterized by relatively elevated temperature conditions within the modeled distribution.

It should not automatically be interpreted as a specific synoptic circulation pattern, air-mass type, or atmospheric mechanism unless additional atmospheric observations are incorporated.

This distinction is essential for maintaining methodological rigor.

---

# 27. Why Markov-Switching Matters

Traditional climate analyses frequently focus on:

* linear trends,
* long-term means,
* anomalies,
* correlation,
* and monotonic changes.

These methods are valuable but may not fully describe situations in which the statistical properties of a climate variable change over time.

Markov-Switching models provide an alternative perspective:

[
Y_t \sim f(\theta_{S_t})
]

where the statistical parameters depend on the latent state (S_t).

Thus, the same climate variable may exhibit fundamentally different statistical behavior under different regimes.

This makes Markov-Switching particularly suitable for investigating:

* nonlinear climate variability,
* persistence,
* state transitions,
* regime-specific variance,
* and compound climate conditions.

---

# 28. Methodological Caution

Several methodological considerations should be emphasized.

First, the monthly climate data exhibit strong seasonality. Consequently, regime interpretations must carefully distinguish persistent latent climate states from deterministic seasonal cycles.

Second, model-selection criteria identify the statistically preferred number of regimes, but they do not by themselves establish physical causality.

Third, the four-regime specification is statistically dominant in the present dataset, but regime labels such as "cool", "normal", "warm", and "extreme warm" should be assigned based on estimated distributions rather than arbitrary terminology.

Fourth, theoretical expected durations and empirical durations represent different concepts and should not be assumed to be identical.

Finally, compound-event definitions should be explicitly documented because percentile-based definitions may naturally generate relatively stable frequencies. Future versions of the analysis may benefit from externally defined climatological thresholds or internationally standardized extreme-climate indices.

---

# 29. Reproducibility

All analyses were conducted using R.

The repository includes:

* R scripts for individual analyses,
* model-selection outputs,
* regime statistics,
* transition matrices,
* duration estimates,
* empirical spell calculations,
* regime probabilities,
* inter-provincial comparisons,
* humidity analysis,
* multivariable results,
* and compound hot–dry calculations.

The Excel workbooks provide numerical outputs corresponding to the graphical results presented in this repository.

The project is therefore designed to facilitate reproducibility and independent methodological inspection.

---

# 30. Repository Structure

```text
.
├── 1. Code.R
├── 2. Code.R
├── ...
├── 23. Code.R
│
├── Figure_1_T2M_MAX_Boxplot.png
├── Figure_2_Precipitation_Trends.png
├── Figure_3_LongTerm_Behavior_T2M.png
├── Figure_4_Seasonality_Cycle.png
├── Figure_5_Precipitation_Fluctuations.png
├── Figure_6_ACF_All_Provinces.png
├── Figure_7_PACF_All_Provinces.png
├── Figure_8_HMM_Academic_Regimes_All_Provinces.png
├── Figure_9_Standardized_Anomalies_All_Provinces.png
├── Figure_10_Markov_Switching_T2M_MAX.png
├── Figure_11_Markov_Switching_3Regime_T2M_MAX.png
├── Figure_12_Empirical_3Regime_T2M_MAX.png
├── Figure_13_Empirical_4Regime_T2M_MAX.png
├── Figure_14_BIC_Model_Selection.png
├── Figure_15_Regime_Means_Confidence_Intervals.png
├── Figure_16_Regime_Probabilities_All_Provinces.png
├── Figure_17_Most_Likely_Regimes_All_Provinces.png
├── Figure_18_Transition_Matrix_Heatmap_All_Provinces.png
├── Figure_19_Expected_Durations_All_Provinces.png
├── Figure_20_Empirical_Durations_All_Provinces.png
├── Figure_21_High_Regime_Durations_Comparison.png
├── Figure_22_Regime_Frequencies_All_Provinces.png
├── Figure_24_Inter_Provincial_Comparison.png
├── Figure_25_Inter_Provincial_TMIN_Comparison.png
├── Figure_27_Global_Humidity_Distribution.png
├── Figure_28_Multi_Variable_Regime_Comparison.png
└── Figure_30_Multivariate_Integrated_Results.png
```

---

# 31. Figures at a Glance

| Figure    | Description                           |
| --------- | ------------------------------------- |
| Figure 1  | Maximum temperature boxplots          |
| Figure 2  | Precipitation trends                  |
| Figure 3  | Long-term temperature behavior        |
| Figure 4  | Seasonal cycle                        |
| Figure 5  | Precipitation fluctuations            |
| Figure 6  | ACF                                   |
| Figure 7  | PACF                                  |
| Figure 8  | HMM climate regimes                   |
| Figure 9  | Standardized anomalies                |
| Figure 10 | Two-regime Markov-Switching           |
| Figure 11 | Three-regime Markov-Switching         |
| Figure 12 | Empirical three-regime durations      |
| Figure 13 | Empirical four-regime durations       |
| Figure 14 | BIC model selection                   |
| Figure 15 | Regime means and confidence intervals |
| Figure 16 | Regime probabilities                  |
| Figure 17 | Most likely regimes                   |
| Figure 18 | Transition matrix heatmaps            |
| Figure 19 | Expected regime durations             |
| Figure 20 | Empirical regime durations            |
| Figure 21 | High-regime duration comparison       |
| Figure 22 | Regime frequencies                    |
| Figure 24 | Inter-provincial climate comparison   |
| Figure 25 | Minimum-temperature comparison        |
| Figure 27 | Humidity-regime distribution          |
| Figure 28 | Multivariable regime comparison       |
| Figure 30 | Integrated multivariate results       |

---

# 32. Scientific Contribution

The principal contribution of this research is methodological and climatological.

Rather than treating Southeastern Türkiye as a spatially homogeneous climate system characterized by a single mean state, the study demonstrates that climate variability can be represented as a sequence of latent statistical regimes with distinct persistence and transition characteristics.

The combination of:

**HMM + Markov-Switching + AIC/BIC + transition probabilities + duration analysis + spatial comparison + multivariable analysis + compound hot–dry events**

provides a more comprehensive representation of climate variability than a conventional single-variable trend analysis.

The results are particularly relevant for:

* climate-risk assessment,
* agricultural adaptation,
* water-resource management,
* drought monitoring,
* ecosystem vulnerability assessment,
* wildfire-risk analysis,
* environmental planning,
* and regional climate adaptation strategies.

---

# 33. Conclusions

The analysis demonstrates that climate variability across Southeastern Türkiye is characterized by substantial temporal persistence, nonlinear state transitions, and pronounced spatial differentiation.

The overwhelming preference for four-regime models in the BIC-based model selection indicates that a simple binary representation of climate variability is generally inadequate for the analyzed province-variable combinations.

The regime analysis further demonstrates that high-temperature, low-humidity, and low-precipitation states may persist over multiple consecutive months. This persistence becomes particularly important when multiple stressors occur simultaneously.

The compound hot–dry analysis identifies Şanlıurfa as the most exposed province within the analyzed network, with a compound-event frequency of approximately 33.10%, a mean spell duration of 3.76 months, and a maximum observed spell of five months.

Mardin, Batman, Diyarbakır, and Şırnak also demonstrate substantial compound hot–dry occurrence.

Taken together, the findings indicate that climate risk in Southeastern Türkiye should not be evaluated solely through changes in mean temperature or precipitation. The **frequency, persistence, transition probability, and co-occurrence of multiple climate stressors** provide additional and potentially more policy-relevant information.

The Markov-Switching framework therefore offers a promising methodological approach for identifying hidden climate states and characterizing their temporal persistence and spatial differentiation.

---

# 34. Future Research

Future extensions of this research should focus on five major directions:

1. **Seasonally adjusted regime analysis**
   Applying Markov-Switching models to deseasonalized or anomaly-based climate series would help distinguish genuine latent climate states from deterministic seasonal cycles.

2. **Standardized drought indices**
   SPI and SPEI could be integrated into the regime framework to explicitly represent meteorological and climatic water-balance drought.

3. **Atmospheric circulation mechanisms**
   Reanalysis data, geopotential height, circulation indices, and synoptic classifications could be incorporated to investigate the physical mechanisms underlying the statistical regimes.

4. **Extreme climate indices**
   ETCCDI-type indices such as TX90p, TN90p, WSDI, CDD, and CWD could provide standardized definitions of climate extremes.

5. **Future climate projections**
   The framework could be applied to CMIP6 or CORDEX projections to investigate whether the frequency, persistence, and transition structure of climate regimes are projected to change under future emission scenarios.

---

# 35. Data and Software

**Programming language:** R

**Primary statistical frameworks:**

* Hidden Markov Models
* Markov-Switching Models
* AIC
* BIC
* Transition probability analysis
* Regime-duration analysis
* Empirical spell analysis
* Multivariable climate-state analysis
* Compound-event analysis

**Temporal resolution:** Monthly

**Study period:** 1990–2025

**Spatial coverage:** 9 provinces in Southeastern Türkiye

**Climate variables:** T2M_MAX, T2M_MIN, PRECTOTCORR, RH2M

---

# 36. Keywords

`Climate Variability` · `Markov-Switching` · `Hidden Markov Model` · `Climate Regimes` · `Southeastern Türkiye` · `Temperature Extremes` · `Precipitation` · `Relative Humidity` · `Regime Persistence` · `Transition Probability` · `Compound Hot-Dry Events` · `Climate Risk` · `Hydroclimatic Variability` · `Climate Change Adaptation`

---

# 37. Citation

If you use this repository, methodology, code, or results in academic research, please cite the associated study.

**Ahmet Solmaz.**
*Hidden Climate Regimes: A Markov-Switching Analysis of Climate Variability in Southeastern Türkiye.*

---

## Research Statement

This repository is intended to provide a transparent and reproducible framework for investigating nonlinear climate variability through latent-state and Markov-Switching approaches.

The central hypothesis of the study is that climate variability cannot always be adequately represented by a single stationary statistical process. Instead, climate observations may emerge from multiple latent states whose probabilities and persistence evolve over time.

By combining regime identification, model selection, persistence analysis, spatial comparison, and compound-event assessment, this study seeks to contribute to a more process-oriented understanding of regional climate variability and climate-related environmental risk in Southeastern Türkiye.
