# 🧪 COVID-19 Pro-Social Behaviour Modelling

## 📚 Table of Contents

- [📌 Project Overview](#-project-overview)
- [🗂 Dataset Description](#-dataset-description)
- [🛠 Tools & Libraries](#-tools--libraries)
- [🧹 Data Engineering & Preprocessing Pipeline](#-data-engineering--preprocessing-pipeline)
- [📊 Statistical Analysis & Modelling](#-statistical-analysis--modelling)
  - [1️⃣ Hypothesis Testing](#1️⃣-hypothesis-testing)
  - [2️⃣ Correlation Analysis](#2️⃣-correlation-analysis)
  - [🔥 Correlation Heatmaps](#-correlation-heatmaps)
  - [3️⃣ Multiple Linear Regression](#3️⃣-multiple-linear-regression)
- [🌍 Country Similarity Modelling](#-country-similarity-modelling)
- [📈 Key Insights](#-key-insights)

## 📌 Project Overview

This project investigates country-level predictors of pro-social behaviour during the COVID-19 pandemic using a behavioural dataset (40,000 observations, 52 variables).

The objective was to:

- Identify statistically significant predictors of pro-social attitudes  
- Compare behavioural patterns between **China** and other countries  
- Research and engineer external socio-economic features to cluster countries based on similarity  
- Evaluate how predictors vary across geopolitical groupings  

The project involved large-scale preprocessing, multi-source data integration, statistical modelling, and hierarchical clustering in **R**.

---

## 🗂 Dataset Description

### Primary Dataset

- 40,000 survey responses  
- 52 attributes  
- 109 countries  
- Mixed data types (categorical, ordinal, binary flags)  
- Over 574,000 missing values before preprocessing  

Pro-social behaviour was measured across four dependent variables.

---

## 🛠 Tools & Libraries

- R  
- ggplot2  
- reshape2  
- stats (`lm`, `t.test`, `hclust`, `dist`)  
- Base R preprocessing functions  


## 🧹 Data Engineering & Preprocessing Pipeline

Significant transformation was required before modelling.

### 🔹 Cleaning & Structuring

- Replaced structured `NA` values in binary indicator columns with `0`  
- Removed entries with missing country identifiers  
- Converted categorical rank-order variables (A–F) into numeric values (1–6)  
- Identified and removed zero-variance variables  
- Managed high levels of missing data using pairwise complete observations  

### 🔹 Feature Engineering

- Created segmented datasets:
  - China  
  - Other Countries  
  - Countries Similar to China  

- Engineered socio-economic features from external datasets:
  - GDP per capita  
  - Life expectancy  
  - Political stability  
  - Mortality rate  
  - Population density  
  - Tertiary education enrolment  

- Standardised country-level features using scaling  
- Merged datasets using country-level joins  

This stage produced a multi-source analytical dataset ready for modelling.

---

### 📊 Exploratory Distribution Comparison

Below is a boxplot comparison of attribute distributions between China and other countries.

<img width="469" height="405" alt="image" src="https://github.com/user-attachments/assets/dfbb4467-cf34-4fa2-be03-0a59baf8fdc9" />

This visual highlights distributional differences across behavioural rankings and psychosocial variables prior to modelling.

---

## 📊 Statistical Analysis & Modelling

### 1️⃣ Hypothesis Testing

Conducted directional t-tests to compare:

- Achievement ranking importance  
- Empathy ranking importance  

Findings confirmed statistically significant differences between China and other countries.

---

### 2️⃣ Correlation Analysis

Generated correlation heatmaps for:

- China  
- Other Countries  
- Countries Similar to China  

Key strong predictors identified:

- Radical action beliefs (`C19RCA`)  
- Personal protective behaviour (`C19perBeh`)  
- Life satisfaction (`LifeSat`)  
- Sense of purpose (`MLQ`)  
- Time perception (`Bor03`)  

---

### 🔥 Correlation Heatmaps

#### China

<img width="538" height="250" alt="image" src="https://github.com/user-attachments/assets/db47e537-f886-4acf-85fe-021e3278061a" />

#### Other Countries

<img width="512" height="240" alt="image" src="https://github.com/user-attachments/assets/8c27d922-e8e6-4105-81ad-08ec1d1dc288" />

The heatmaps reveal stronger clustering between pro-social measures and radical action variables across both groups, with variation in strength and structure between geopolitical segments.

---

### 3️⃣ Multiple Linear Regression

Built regression models for each of the four pro-social outcomes across all country groupings.

Key observations:

- Radical action variables consistently strong predictors  
- Life satisfaction positively correlated with pro-social behaviour  
- Larger sample sizes (Other Countries) produced stronger statistical power  
- Predictor significance varied across geopolitical clusters  

---

## 🌍 Country Similarity Modelling

To identify countries socio-economically comparable to China:

- Scaled six socio-economic indicators  
- Computed Euclidean distances  
- Built hierarchical clustering model (`hclust`)  
- Extracted cluster containing China  

### 🌲 Hierarchical Clustering Model

<img width="1252" height="778" alt="image" src="https://github.com/user-attachments/assets/d37edc62-132b-46ed-8b5a-438e33e00007" />

The extracted cluster containing China included:

- Thailand  
- Jordan  
- Tunisia  
- Ecuador  
- Morocco  

Regression models were re-run on this cluster to evaluate predictor stability across similar socio-economic environments.

---

## 📈 Key Insights

- Pro-social behaviour is strongly linked to:
  - Support for mandatory public health measures  
  - Personal protective behaviours  
  - Life satisfaction  
  - Sense of purpose  

- Chinese respondents showed:
  - Higher prioritisation of achievement  
  - Lower prioritisation of empathy  
  - Significantly higher non-response rates for conspiracy-related questions  

- Country similarity modelling revealed that socio-economic similarity does not guarantee behavioural predictor similarity.
