/*
    Statistical assumption diagnostics

    Purpose:
    - Review equal-covariance assumptions for the two-sample WBC Hotelling test.
    - Review univariate normality and potential multivariate outliers.
    - Review normality and potential multivariate outliers for paired Twin differences.

    Notes:
    - Independence is a study-design assumption and cannot be established by a statistical test here.
    - Univariate normality tests do not prove multivariate normality; they are screening diagnostics.
*/

/* ------------------------- WBC diagnostics ------------------------- */

%let wbc_file = &project_root/data/Dataset WBC.csv;

proc import datafile="&wbc_file"
    out=wbc_assumptions
    dbms=csv
    replace;
    getnames=yes;
run;

proc sort data=wbc_assumptions;
    by Status;
run;

title "WBC Normality Screening by Status";
proc univariate data=wbc_assumptions normal;
    by Status;
    var Eccentricity Area Perimeter Solidity Extent Diameter;
    histogram / normal;
    qqplot / normal(mu=est sigma=est);
run;

/*
    With METHOD=NORMAL and POOL=TEST, PROC DISCRIM reports a test
    of homogeneity of within-group covariance matrices.
*/
title "WBC Homogeneity of Covariance Matrices";
proc discrim data=wbc_assumptions method=normal pool=test;
    class Status;
    var Eccentricity Area Perimeter Solidity Extent Diameter;
run;

/*
    Group-wise squared Mahalanobis distances.
    Observations above the 97.5% chi-square cutoff are flagged as
    potential multivariate outliers for review, not automatically removed.
*/
proc iml;
    use wbc_assumptions;
    read all var {ID Eccentricity Area Perimeter Solidity Extent Diameter}
        where(Status="Diseased") into XD;
    read all var {ID Eccentricity Area Perimeter Solidity Extent Diameter}
        where(Status="Non-diseased") into XN;
    close wbc_assumptions;

    start FlagOutliers(X, GroupName);
        id = X[,1];
        V = X[,2:ncol(X)];
        n = nrow(V);
        p = ncol(V);
        mu = mean(V);
        S = cov(V);
        centered = V - repeat(mu, n, 1);
        md2 = vecdiag(centered * inv(S) * centered`);
        cutoff = quantile("chisquare", 0.975, p);
        flag = (md2 > cutoff);
        result = id || md2 || flag;

        print GroupName n p cutoff;
        print result[colname={"ID" "Mahalanobis_D2" "Potential_Outlier"}];
    finish;

    run FlagOutliers(XD, "Diseased");
    run FlagOutliers(XN, "Non-diseased");
quit;


/* ------------------------- Twin diagnostics ------------------------- */

%let twin_file = &project_root/data/Dataset TWIN.csv;

proc import datafile="&twin_file"
    out=twin_assumptions
    dbms=csv
    replace;
    getnames=yes;
run;

data twin_diff_assumptions;
    set twin_assumptions;
    RowID = _N_;
    d1 = X1_T1 - X1_T2;
    d2 = X2_T1 - X2_T2;
    d3 = X3_T1 - X3_T2;
    d4 = X4_T1 - X4_T2;
run;

title "Twin Difference Normality Screening";
proc univariate data=twin_diff_assumptions normal;
    var d1 d2 d3 d4;
    histogram / normal;
    qqplot / normal(mu=est sigma=est);
run;

title "Twin Difference Correlation Matrix";
proc corr data=twin_diff_assumptions;
    var d1 d2 d3 d4;
run;

proc iml;
    use twin_diff_assumptions;
    read all var {RowID d1 d2 d3 d4} into X;
    close twin_diff_assumptions;

    id = X[,1];
    V = X[,2:ncol(X)];
    n = nrow(V);
    p = ncol(V);
    mu = mean(V);
    S = cov(V);
    centered = V - repeat(mu, n, 1);
    md2 = vecdiag(centered * inv(S) * centered`);
    cutoff = quantile("chisquare", 0.975, p);
    flag = (md2 > cutoff);
    result = id || md2 || flag;

    print n p cutoff;
    print result[colname={"RowID" "Mahalanobis_D2" "Potential_Outlier"}];
quit;

title;
