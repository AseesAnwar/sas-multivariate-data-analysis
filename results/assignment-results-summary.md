# Statistical Results Summary

These figures are the results reported by the original analysis. The SAS code has since been refactored to improve reproducibility, but the source CSV files are not currently stored in the repository, so the improved pipeline has not yet been re-run against the original data.

## WBC: Diseased vs Non-diseased

The original WBC dataset contained 50 diseased and 50 non-diseased observations measured across six variables:

- Eccentricity
- Area
- Perimeter
- Solidity
- Extent
- Diameter

### Multivariate comparison

Hotelling's T-square test did not identify a statistically significant overall difference between the two groups at alpha = 0.05.

| Statistic | Result |
|---|---:|
| T-square | 6.0116 |
| F | 0.9508 |
| F critical | 2.1977 |
| p-value | 0.4630 |

Interpretation: the six WBC characteristics, considered jointly, did not provide sufficient evidence of a systematic multivariate difference between the diseased and non-diseased groups.

The individual two-sample t-tests also did not identify statistically significant differences at the 5% level.

## WBC PCA

### Diseased group

The first three principal components explained approximately 85.42% of total variance.

- PC1: 43.05%
- PC2: 26.59%
- first three PCs combined: 85.42%

### Non-diseased group

The first three principal components explained approximately 78.99% of total variance.

- PC1: 33.54%
- PC2: 28.38%
- first three PCs combined: 78.99%

Interpretation: variation in the diseased group was somewhat more concentrated in the leading components, while variation in the non-diseased group was distributed more broadly.

## Paired Twin Analysis

The paired Hotelling's T-square analysis used four difference variables across 30 paired observations.

| Statistic | Result |
|---|---:|
| T-square | 9.1496 |
| F | 2.0508 |
| df1 | 4 |
| df2 | 26 |
| p-value | 0.1165 |
| F critical | 2.7426 |

Interpretation: the four paired measurements did not collectively provide sufficient evidence of a systematic multivariate mean difference at the 5% significance level.

## THC Chemical PCA

The original THC dataset contained 178 observations measured across 13 chemical variables.

The first three components had eigenvalues above 1 and together explained approximately 66.53% of total variance.

| Component | Eigenvalue | Variance explained |
|---|---:|---:|
| PC1 | 4.7059 | 36.20% |
| PC2 | 2.4970 | 19.21% |
| PC3 | 1.4461 | 11.12% |

Interpretation: PCA reduced 13 chemical measurements to three leading components while retaining roughly two-thirds of the total variation.

## Reproducibility status

The current SAS programs now derive PCA eigenvalues and sample sizes directly from imported data instead of relying on manually copied values. Once the original datasets are restored, these historical results should be re-generated and checked against the refactored workflow before being treated as validated current output.
