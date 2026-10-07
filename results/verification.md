# Independent Verification of Published Results

The original project datasets were recovered and checked against the statistical results previously reported in this repository.

The datasets used for verification contained:

- WBC: 100 observations, including 50 Diseased and 50 Non-diseased observations
- Twin: 30 paired observations
- THC: 178 observations and 13 chemical variables

No missing values were present in the analysis variables.

The Twin dataset contains 3 exact duplicate measurement rows. These are retained because identical response patterns can be legitimate observations; the validation script flags them for review rather than deleting them automatically.

## Reproduced results

### WBC two-sample Hotelling's T-square

| Statistic | Reproduced value |
|---|---:|
| T-square | 6.0115921 |
| F | 0.9508130 |
| p-value | 0.4629967 |
| F critical | 2.1976785 |

These values match the historical project results.

### WBC PCA eigenvalues

Diseased group:

| PC | Eigenvalue |
|---|---:|
| PC1 | 2.58295761 |
| PC2 | 1.59566664 |
| PC3 | 0.94656794 |
| PC4 | 0.45051455 |
| PC5 | 0.27338960 |
| PC6 | 0.15090366 |

Non-diseased group:

| PC | Eigenvalue |
|---|---:|
| PC1 | 2.01210359 |
| PC2 | 1.70308995 |
| PC3 | 1.02398090 |
| PC4 | 0.67193663 |
| PC5 | 0.34271819 |
| PC6 | 0.24617075 |

These reproduce the values previously hard-coded in the original SAS program, confirming that the refactored OUTSTAT-based workflow is using the correct target quantities.

### Twin paired Hotelling's T-square

| Statistic | Reproduced value |
|---|---:|
| T-square | 9.1496452 |
| F | 2.0507825 |
| p-value | 0.1165385 |
| F critical | 2.7425941 |

These values match the historical project results.

### THC PCA

| Component | Eigenvalue | Variance explained |
|---|---:|---:|
| PC1 | 4.70585025 | 36.20% |
| PC2 | 2.49697373 | 19.21% |
| PC3 | 1.44607197 | 11.12% |

The first three components explain approximately 66.53% of total variance, matching the historical analysis.

## Verification conclusion

The recovered source datasets reproduce the main numerical results reported in the original project.

The refactoring therefore preserves the original statistical findings while improving the workflow by deriving eigenvalues and sample sizes directly from the data instead of manually entering them.

## Data distribution note

The raw coursework datasets are not committed to this public repository until their redistribution rights are confirmed. This keeps the portfolio transparent without assuming permission to republish source data.
