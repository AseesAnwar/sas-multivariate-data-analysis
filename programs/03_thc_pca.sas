/*
    THC chemical summary statistics, correlations, scatterplot matrix, and PCA.
    PCA eigenvalues and sample size are derived automatically from the data.
*/

%let thc_file = &project_root/data/Dataset THC.csv;

proc import datafile="&thc_file"
    out=thc
    dbms=csv
    replace;
    getnames=yes;
run;

proc means data=thc mean stddev maxdec=4;
    var chem1 chem2 chem3 chem4 chem5 chem6 chem7
        chem8 chem9 chem10 chem11 chem12 chem13;
run;

proc corr data=thc;
    var chem1 chem2 chem3 chem4 chem5 chem6 chem7
        chem8 chem9 chem10 chem11 chem12 chem13;
run;

proc sgscatter data=thc;
    matrix chem1 chem2 chem3 chem4 chem5 chem6 chem7
           chem8 chem9 chem10 chem11 chem12 chem13;
run;

/*
    PROC PRINCOMP uses the correlation matrix by default.
    OUTSTAT stores the eigenvalues so downstream calculations stay reproducible.
*/
proc princomp data=thc out=pcout outstat=thc_pca_stat plots=scree;
    var chem1 chem2 chem3 chem4 chem5 chem6 chem7
        chem8 chem9 chem10 chem11 chem12 chem13;
run;

data thc_pca_eigen;
    set thc_pca_stat;
    where _TYPE_ = "EIGENVAL";
    keep chem1 chem2 chem3 chem4 chem5 chem6 chem7
         chem8 chem9 chem10 chem11 chem12 chem13;
run;

/* Confidence intervals for the first three eigenvalues generated above. */
proc iml;
    use thc_pca_eigen;
    read all var {chem1 chem2 chem3 chem4 chem5 chem6 chem7
                  chem8 chem9 chem10 chem11 chem12 chem13} into lambda_row;
    close thc_pca_eigen;

    use thc;
    read all var {chem1 chem2 chem3 chem4 chem5 chem6 chem7
                  chem8 chem9 chem10 chem11 chem12 chem13} into X;
    close thc;

    lambda = lambda_row`;
    lambda = lambda[1:3];
    n = nrow(X);
    alpha = 0.05;
    z = quantile("Normal", 1-alpha/2);

    se = lambda # sqrt(2/n);
    lower = lambda - z#se;
    upper = lambda + z#se;

    print n alpha z;
    print (lambda || se || lower || upper)
        [colname={"Eigenvalue" "SE" "Lower_95CI" "Upper_95CI"}
         rowname={"lambda1" "lambda2" "lambda3"}];
quit;
