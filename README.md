# SAS Multivariate Data Analysis

An end-to-end statistical analysis project in SAS using multivariate hypothesis testing and principal component analysis (PCA) across biological, paired-measurement, and chemical datasets.

The project demonstrates how SAS can be used to validate data, compare multivariate groups, analyse paired observations, reduce dimensionality, and communicate statistically meaningful findings.

## Why This Project Matters

The analysis addresses four practical analytical questions:

1. Do diseased and non-diseased white blood cell groups differ across their combined morphological characteristics?
2. Can WBC measurements be reduced to a smaller number of principal components?
3. Do paired twin measurements show a significant multivariate difference?
4. Can 13 THC chemical variables be represented by a smaller set of components while retaining most of the information?

## Skills Demonstrated

- SAS programming
- PROC IML
- PROC PRINCOMP
- PROC TTEST
- PROC CORR
- PROC MEANS
- Matrix operations
- Hotelling's T-square testing
- Principal component analysis
- Dimensionality reduction
- Covariance and correlation analysis
- Statistical hypothesis testing
- Data validation
- Reproducible analytical workflows
- Statistical interpretation and communication

## Project Workflow

```text
Raw CSV data
    ↓
File and schema validation
    ↓
Missing-value / duplicate / range checks
    ↓
Exploratory summaries and correlation analysis
    ↓
Multivariate hypothesis testing
    ↓
PCA and dimensionality reduction
    ↓
Statistical interpretation
    ↓
Reported findings
```

## Repository Structure

```text
programs/
    00_run_all.sas
    00_data_validation.sas
    01_wbc_hotelling_and_pca.sas
    02_twin_hotelling.sas
    03_thc_pca.sas

data/
    README.md

results/
    assignment-results-summary.md

docs/
    multivariate-analysis-assignment-2.docx

outputs/
    reserved for generated SAS outputs
```

### Main programs

- `programs/00_run_all.sas` — master program that runs validation before all statistical analysis.
- `programs/00_data_validation.sas` — checks required files and variables, status labels, missing values, ranges, and duplicate rows.
- `programs/01_wbc_hotelling_and_pca.sas` — two-sample Hotelling's T-square, univariate tests, and PCA for WBC groups.
- `programs/02_twin_hotelling.sas` — paired Hotelling's T-square analysis.
- `programs/03_thc_pca.sas` — descriptive analysis, correlations, scatterplot matrix, and PCA for 13 chemical variables.

## Reproducibility Improvements

The current code is designed so statistical quantities are derived from the imported data rather than manually copied from previous output.

In particular:

- PCA eigenvalues are captured directly from `PROC PRINCOMP` using `OUTSTAT=`.
- Sample sizes are calculated from the imported datasets.
- Confidence-interval calculations use the generated PCA eigenvalues.
- A validation program runs before the statistical analysis.
- The master runner executes the project in a defined order.

This reduces the risk of stale results when the underlying data changes.

## Analytical Methods

### WBC group comparison

The WBC analysis compares six morphological variables between diseased and non-diseased observations using:

- group descriptive statistics
- covariance matrices
- correlation matrices
- two-sample Hotelling's T-square
- individual two-sample t-tests
- PCA for each group

### WBC PCA

PCA is used to investigate whether the six WBC measurements can be represented using fewer dimensions.

The SAS workflow captures eigenvalues directly from `PROC PRINCOMP` and uses them for follow-on component tests and confidence intervals.

### Twin paired analysis

Paired differences are calculated across four measurements and analysed jointly using Hotelling's T-square.

### THC chemical PCA

The THC analysis examines 13 chemical variables using descriptive statistics, correlations, a scatterplot matrix, and PCA.

`PROC PRINCOMP` uses the correlation matrix by default, which is appropriate when variables may differ in scale because each variable is effectively standardized before component extraction.

## Key Findings From the Original Analysis

The original analysis reported:

- no statistically significant overall multivariate difference between diseased and non-diseased WBC groups (Hotelling's T-square p = 0.463);
- approximately 85.4% of WBC variance captured by the first three components in the diseased group;
- approximately 79.0% captured by the first three components in the non-diseased group;
- no statistically significant multivariate mean difference in the paired twin analysis (p = 0.117);
- approximately 66.5% of total THC chemical variation captured by the first three principal components.

See `results/assignment-results-summary.md` for the detailed historical results.

## Data Availability

The original CSV datasets are not currently stored in this repository.

The programs expect:

- `data/Dataset WBC.csv`
- `data/Dataset TWIN.csv`
- `data/Dataset THC.csv`

Because those files are currently unavailable in the repository, the published historical results have not yet been re-executed against the improved pipeline.

This is an explicit remaining reproducibility dependency rather than a hidden limitation.

## How To Run

1. Clone the repository.
2. Place the three required CSV files in the `data/` folder.
3. Open SAS Studio, SAS OnDemand for Academics, or another SAS environment with SAS/IML available.
4. Update `project_root` in `programs/00_run_all.sas`.
5. Run `programs/00_run_all.sas`.

The validation stage runs first and stops the workflow if a required input file or required variable is missing.

## Current Improvement Roadmap

- Restore or publish permitted versions of the source datasets.
- Re-run the complete workflow against the restored data.
- Export key SAS tables and plots into `outputs/`.
- Add scree plots and other visual results directly to this README.
- Add formal statistical-assumption diagnostics.
- Expand interpretation of PCA loadings and component meaning.
- Add a concise methodology document for technical reviewers.

## Project Background

This project originated from university coursework in multivariate statistics and has since been reorganised as a reproducible SAS analytics portfolio project. The original submission is retained in `docs/` for transparency, while the SAS programs are being improved independently for reproducibility, validation, and recruiter readability.
