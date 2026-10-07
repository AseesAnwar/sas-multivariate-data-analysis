/*
    WBC diseased vs non-diseased multivariate analysis and PCA.
    All sample sizes and PCA eigenvalues are derived from the imported data.
*/

%let wbc_file = &project_root/data/Dataset WBC.csv;

proc import datafile="&wbc_file"
    out=wbc
    dbms=csv
    replace;
    getnames=yes;
run;

proc contents data=wbc;
run;

proc print data=wbc(obs=10);
run;

proc sort data=wbc;
    by Status;
run;

proc means data=wbc n mean std maxdec=4;
    class Status;
    var Eccentricity Area Perimeter Solidity Extent Diameter;
run;

proc corr data=wbc cov;
    by Status;
    var Eccentricity Area Perimeter Solidity Extent Diameter;
run;

proc corr data=wbc;
    by Status;
    var Eccentricity Area Perimeter Solidity Extent Diameter;
run;

/* Hotelling's two-sample T-square test. */
proc iml;
    use wbc;
    read all var {Eccentricity Area Perimeter Solidity Extent Diameter}
        where(Status="Diseased") into X1;
    read all var {Eccentricity Area Perimeter Solidity Extent Diameter}
        where(Status="Non-diseased") into X2;
    close wbc;

    n1 = nrow(X1);
    n2 = nrow(X2);
    p = ncol(X1);
    alpha = 0.05;

    mean1 = mean(X1);
    mean2 = mean(X2);
    S1 = cov(X1);
    S2 = cov(X2);
    Sp = ((n1-1)*S1 + (n2-1)*S2) / (n1+n2-2);
    diff = mean1 - mean2;

    T2 = (n1*n2/(n1+n2)) * diff * inv(Sp) * diff`;
    F = ((n1+n2-p-1) / ((n1+n2-2)*p)) * T2;
    df1 = p;
    df2 = n1+n2-p-1;
    pvalue = 1 - probf(F, df1, df2);
    fcrit = finv(1-alpha, df1, df2);

    print n1 n2 p;
    print mean1[colname={"Eccentricity" "Area" "Perimeter" "Solidity" "Extent" "Diameter"}];
    print mean2[colname={"Eccentricity" "Area" "Perimeter" "Solidity" "Extent" "Diameter"}];
    print diff[colname={"Eccentricity" "Area" "Perimeter" "Solidity" "Extent" "Diameter"}];
    print T2 F df1 df2 pvalue fcrit;
quit;

/* Individual two-sample tests. */
proc ttest data=wbc;
    class Status;
    var Eccentricity Area Perimeter Solidity Extent Diameter;
run;

/* PCA for diseased WBC cells. OUTSTAT captures eigenvalues for downstream calculations. */
proc princomp data=wbc(where=(Status="Diseased"))
    out=pca_diseased
    outstat=pca_diseased_stat
    plots=(scree pattern);
    var Eccentricity Area Perimeter Solidity Extent Diameter;
run;

data pca_diseased_eigen;
    set pca_diseased_stat;
    where _TYPE_ = "EIGENVAL";
    keep Eccentricity Area Perimeter Solidity Extent Diameter;
run;

/* Diseased group: component equality tests using eigenvalues generated above. */
proc iml;
    use pca_diseased_eigen;
    read all var {Eccentricity Area Perimeter Solidity Extent Diameter} into lambda_row;
    close pca_diseased_eigen;

    use wbc;
    read all var {Eccentricity Area Perimeter Solidity Extent Diameter}
        where(Status="Diseased") into X;
    close wbc;

    lambda = lambda_row`;
    n = nrow(X);
    p = ncol(X);
    result = {};

    do k = 0 to p-2;
        m = p - k;
        rem_lambda = lambda[(k+1):p];
        lambda_bar = mean(rem_lambda);

        Q = -(n - 1 - (2*p + 5)/6 - (2*k)/3) *
             sum(log(rem_lambda / lambda_bar));

        df = (m - 1)*(m + 2)/2;
        p_Q = 1 - probchi(Q, df);
        u = sum((rem_lambda - lambda_bar)##2) / (lambda_bar##2);
        p_u = 1 - probchi(u, df);

        result = result // (k || m || lambda_bar || Q || df || p_Q || u || p_u);
    end;

    print n p lambda;
    print result[colname={
        "k" "Remaining_PC" "Mean_Eigenvalue" "Q_Statistic"
        "DF" "Q_p_value" "u_Statistic" "u_p_value"
    }];
quit;

/* Diseased group: confidence intervals for the first two eigenvalues. */
proc iml;
    use pca_diseased_eigen;
    read all var {Eccentricity Area Perimeter Solidity Extent Diameter} into lambda_row;
    close pca_diseased_eigen;

    use wbc;
    read all var {Eccentricity Area Perimeter Solidity Extent Diameter}
        where(Status="Diseased") into X;
    close wbc;

    lambda = lambda_row`[1:2];
    n = nrow(X);
    alpha = 0.05;
    z = quantile("Normal", 1-alpha/2);

    se = lambda # sqrt(2/n);
    lower = lambda - z#se;
    upper = lambda + z#se;

    print n;
    print (lambda || se || lower || upper)
        [colname={"Eigenvalue" "SE" "Lower_95CI" "Upper_95CI"}
         rowname={"lambda1" "lambda2"}];
quit;

/* PCA for non-diseased WBC cells. */
proc princomp data=wbc(where=(Status="Non-diseased"))
    out=pca_nondiseased
    outstat=pca_nondiseased_stat
    plots=(scree pattern);
    var Eccentricity Area Perimeter Solidity Extent Diameter;
run;

data pca_nondiseased_eigen;
    set pca_nondiseased_stat;
    where _TYPE_ = "EIGENVAL";
    keep Eccentricity Area Perimeter Solidity Extent Diameter;
run;

/* Non-diseased group: component equality tests using generated eigenvalues. */
proc iml;
    use pca_nondiseased_eigen;
    read all var {Eccentricity Area Perimeter Solidity Extent Diameter} into lambda_row;
    close pca_nondiseased_eigen;

    use wbc;
    read all var {Eccentricity Area Perimeter Solidity Extent Diameter}
        where(Status="Non-diseased") into X;
    close wbc;

    lambda = lambda_row`;
    n = nrow(X);
    p = ncol(X);
    result = {};

    do k = 0 to p-2;
        m = p - k;
        rem_lambda = lambda[(k+1):p];
        lambda_bar = mean(rem_lambda);

        Q = -(n - 1 - (2*p + 5)/6 - (2*k)/3) *
             sum(log(rem_lambda / lambda_bar));

        df = (m - 1)*(m + 2)/2;
        p_Q = 1 - probchi(Q, df);
        u = sum((rem_lambda - lambda_bar)##2) / (lambda_bar##2);
        p_u = 1 - probchi(u, df);

        result = result // (k || m || lambda_bar || Q || df || p_Q || u || p_u);
    end;

    print n p lambda;
    print result[colname={
        "k" "Remaining_PC" "Mean_Eigenvalue" "Q_Statistic"
        "DF" "Q_p_value" "u_Statistic" "u_p_value"
    }];
quit;

/* Non-diseased group: confidence intervals for the first two eigenvalues. */
proc iml;
    use pca_nondiseased_eigen;
    read all var {Eccentricity Area Perimeter Solidity Extent Diameter} into lambda_row;
    close pca_nondiseased_eigen;

    use wbc;
    read all var {Eccentricity Area Perimeter Solidity Extent Diameter}
        where(Status="Non-diseased") into X;
    close wbc;

    lambda = lambda_row`[1:2];
    n = nrow(X);
    alpha = 0.05;
    z = quantile("Normal", 1-alpha/2);

    se = lambda # sqrt(2/n);
    lower = lambda - z#se;
    upper = lambda + z#se;

    print n;
    print (lambda || se || lower || upper)
        [colname={"Eigenvalue" "SE" "Lower_95CI" "Upper_95CI"}
         rowname={"lambda1" "lambda2"}];
quit;
