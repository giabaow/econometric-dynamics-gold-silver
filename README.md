# 📊 Gold & Silver Price Dynamics (2007–2025)

> A time-series analysis of gold and silver prices exploring long-run equilibrium and short-term interactions.

---

## 🛠 Tools Used

| Tool | Description |
|------|-------------|
| ![R](https://img.shields.io/badge/R-276DC3?style=flat&logo=r&logoColor=white) **R** | Time-series modeling, stationarity tests, VECM/ECM estimation |
| ![Python](https://img.shields.io/badge/Python-3776AB?style=flat&logo=python&logoColor=white) **Python** | Data preprocessing, visualization, supplementary statistical analysis |
| ![Excel](https://img.shields.io/badge/Excel-217346?style=flat&logo=microsoft-excel&logoColor=white) **Excel** | Data collection, initial preprocessing, charts |
| ![Statistics](https://img.shields.io/badge/Statistics-FF6F61?style=flat&logo=gnuplot&logoColor=white) **Statistical Methods** | ADF/KPSS tests, Engle–Granger cointegration, ECM/VECM, IRF analysis |

---

## 📈 Visualizations

### Figure 1: Standardized Gold & Silver Price Series
![Figure 1: Standardized Gold and Silver Prices](./visualizations/Time series of gold and silver closing price.png)  
*Daily closing prices of gold and silver standardized for comparison.*

### Figure 2: Autocorrelation Functions (ACF) of Log-Transformed Prices
![Figure 2: ACF of Log-Transformed Gold & Silver Prices](./images/figure2_acf.png)  
*Autocorrelation analysis of log-transformed gold and silver prices to detect seasonality and persistence.*

---

## Project Overview

Gold and silver are widely recognized for their roles as **investment assets**, **inflation hedges**, and **safe-haven commodities**. While gold is typically stable, silver exhibits higher volatility due to industrial demand.  

This study investigates:

1. **Long-run equilibrium (cointegration)** between gold and silver prices.  
2. **Short-run interactions** and shock transmission between the two metals.  
3. **Adjustment dynamics**: which metal responds to deviations from equilibrium.  

---

## Data

- **Source:** Yahoo Finance  
- **Frequency:** Daily closing prices  
- **Period:** January 2007 – December 2025  
- **Tools:** R, Python, Excel  

---

## Methodology

1. **Data Transformation**
   - Logarithmic transformation for stationarity.  
   - Standardization for visualization.  
   - Linear interpolation for missing values.

2. **Stationarity Testing**
   - **ADF Test** and **KPSS Test**: both series are I(1) (non-stationary in levels, stationary in first differences).

3. **Cointegration Analysis**
   - **Engle–Granger test** confirms a long-run equilibrium between gold and silver.

4. **Error-Correction Model (ECM)**
   - **VECM** captures short-term dynamics and long-term adjustments.  
   - Lag selection via **AIC, BIC, HQ, FPE** criteria.  
   - **Impulse Response Functions (IRFs)** analyze shock transmission.

5. **Residual Diagnostics**
   - Ensure residuals behave like white noise.

---

## Key Findings

- Gold and silver prices are **cointegrated**, sharing a stable long-run trajectory.  
- **Silver prices** adjust to deviations from the long-run equilibrium; gold is weakly exogenous.  
- **Short-run interactions** are limited; no strong evidence of Granger causality.  
- Relationship is primarily **long-term co-movement**.

---

## References

1. Baur, D. G., & Lucey, B. M. (2010). *Is gold a hedge or a safe haven?* Financial Review, 45(2), 217–229.  
2. Engle, R. F., & Granger, C. W. J. (1987). *Co-Integration and Error Correction: Representation, Estimation, and Testing*, Vol. 55, Issue 2.  
3. Pindyck, R. S. (1999). *The long-run evolution of energy prices*. The Energy Journal, 20(2), 1–27.  
4. Sari, R., Hammoudeh, S., & Soytas, U. (2010). *Dynamics of oil price, precious metal prices, and exchange rate*. Energy Economics, 32(2), 351–362.  
5. Hammoudeh, S., Yuan, Y., McAleer, M., & Thompson, M. A. (2010). *Precious metals–exchange rate volatility transmissions and hedging strategies*. International Review of Economics & Finance, 19(4), 633–647.

---

## License

MIT License
