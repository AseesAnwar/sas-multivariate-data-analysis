# Statistical Assumption Diagnostics

This document records assumption checks added to the portfolio version of the project.

## WBC two-sample Hotelling's T-square

The two-sample Hotelling test relies on assumptions including independent observations, approximate multivariate normality within groups, and comparable within-group covariance structures.

### Covariance homogeneity

An independent check of the recovered WBC data produced a Box's M-style homogeneity result of approximately:

- chi-square = 24.60
- df = 21
- p = 0.265

At the 5% level, this does not provide evidence that the two covariance matrices differ materially.

The SAS workflow now also includes `PROC DISCRIM METHOD=NORMAL POOL=TEST` so the covariance-homogeneity check can be produced within SAS.

### Normality screening

Univariate Shapiro-Wilk screening showed that not every variable is normally distributed within each WBC group.

Examples include:

- Diseased Diameter: p ≈ 0.002
- Non-diseased Area: p ≈ 0.011
- Non-diseased Perimeter: p ≈ 0.021

Other WBC variables did not show strong univariate evidence against normality at the 5% level.

These are screening diagnostics only. Passing or failing individual univariate tests does not by itself establish multivariate normality.

### Potential multivariate outliers

Using squared Mahalanobis distance with a 97.5% chi-square screening threshold:

- Diseased group: 2 observations flagged for review
- Non-diseased group: 3 observations flagged for review

The project does not automatically delete these observations. They are retained unless a substantive data-quality reason supports exclusion.

## Twin paired Hotelling's T-square

For paired Hotelling analysis, the multivariate normality assumption applies to the vector of paired differences.

Univariate screening of the four difference variables showed clear departures from normality:

| Difference | Shapiro-Wilk p-value |
|---|---:|
| d1 | < 0.001 |
| d2 | < 0.001 |
| d3 | < 0.001 |
| d4 | < 0.001 |

Three observations were also flagged by the 97.5% Mahalanobis-distance screening threshold.

### Interpretation

The paired Hotelling result is retained as the original coursework method, but its normality assumption is a meaningful limitation and should be acknowledged when interpreting the p-value.

A stronger future extension would compare the result with a robust or resampling-based multivariate alternative.

## PCA assumptions

PCA is primarily a descriptive dimension-reduction technique and does not require multivariate normality merely to compute components.

The project therefore focuses on:

- correlation structure between variables;
- standardized analysis through the correlation matrix;
- eigenvalues and explained variance;
- scree-plot inspection;
- interpretation of loadings and retained components.

## Why these checks matter

The objective is not to mechanically remove every observation or reject an analysis whenever an assumption diagnostic is imperfect.

The objective is to:

1. identify material limitations;
2. avoid silently ignoring them;
3. understand how they affect interpretation;
4. preserve a transparent analytical record.
