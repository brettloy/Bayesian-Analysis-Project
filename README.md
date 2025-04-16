Bayesian-Analysis-Project
# Statistical Analysis of Serious Crimes: A Comparison of Frequentist and Bayesian Approaches
This project investigates the relationship between demographic and infrastructural factors and serious crime rates across counties in the United States. Using both **frequentist** and **Bayesian** statistical modeling approaches, we identify key predictors of crime and assess the reliability of different statistical frameworks.

## 📊 Project Objective

To determine the most significant predictor of serious crime rates using demographic data, and to compare traditional linear regression (frequentist) with Bayesian modeling techniques.

---

## 🧪 Methodology

- **Data Source**: Demographic and socioeconomic data from various U.S. counties
- **Target Variable**: Log-transformed count of serious crimes
- **Key Predictors**:
  - Hospital Beds (strongest single predictor)
  - Total Population
  - Personal Income
  - Educational Attainment

### Modeling Techniques:
- Simple linear regression
- Bayesian inference using:
  - Gibbs Sampling
  - G-prior formulation

---

## 🔍 Key Findings

- **Hospital Beds** emerged as the strongest single predictor of serious crime rates.
- Each additional hospital bed is associated with a **0.032% increase** in log serious crimes.
- Hospital beds likely serve as a **proxy for urbanization** — more urban areas tend to experience higher crime rates.
- **Both frequentist and Bayesian** methods produced nearly identical estimates and supported the reliability of results.
- Outlier counties and residual analysis revealed limitations in the linear model assumptions.

---

## 📈 Results Summary

| Parameter      | Estimate   | 95% Interval (Bayesian)       |
|----------------|------------|-------------------------------|
| Intercept      | ~9.03      | [8.91, 9.14]                  |
| Beds Coefficient | 0.000323 | [0.000293, 0.000353]          |
| R² (Frequentist) | 0.483     | Explained 48.3% of variation |

---

## 🧠 Limitations

- Single-variable model does not account for complex interactions
- Influential outliers affected model stability
- County-level data may obscure within-county variation
- Spatial dependencies were not modeled

---

## 🔭 Future Work

- Add multiple predictors to improve explanatory power
- Implement robust regression techniques to handle outliers
- Incorporate spatial modeling or clustering to capture regional effects

