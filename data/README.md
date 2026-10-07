# Data

The analysis requires three CSV files:

- `Dataset WBC.csv`
- `Dataset TWIN.csv`
- `Dataset THC.csv`

These source datasets are not currently included in the repository.

## Expected schemas

### WBC

Required variables:

`Status, Eccentricity, Area, Perimeter, Solidity, Extent, Diameter`

Expected `Status` values:

- `Diseased`
- `Non-diseased`

### Twin

Required variables:

`X1_T1, X1_T2, X2_T1, X2_T2, X3_T1, X3_T2, X4_T1, X4_T2`

### THC

Required variables:

`chem1` through `chem13`

## Validation

Before the analysis begins, `programs/00_data_validation.sas` checks:

- whether all three files exist;
- whether required variables are present;
- missing values and observed ranges;
- unexpected WBC status labels;
- exact duplicate rows.

The master script runs validation before downstream statistical analysis.

## Reproducibility note

Until the source datasets are restored or a redistributable version is added, a fresh clone of this repository cannot reproduce the historical numerical results. This limitation is documented deliberately so users are not given the impression that the current repository is fully self-contained.
