/*
    Pre-analysis data validation
    Confirms required files and variables exist, reports missing values,
    duplicate rows, group labels, and basic ranges before modelling.
*/

%let wbc_file = &project_root/data/Dataset WBC.csv;
%let twin_file = &project_root/data/Dataset TWIN.csv;
%let thc_file = &project_root/data/Dataset THC.csv;

%macro assert_file(path=, label=);
    %if not %sysfunc(fileexist("&path")) %then %do;
        %put ERROR: Required &label file was not found at &path;
        %abort cancel;
    %end;
%mend;

%macro assert_vars(ds=, vars=);
    %local dsid rc i var;
    %let dsid=%sysfunc(open(&ds));

    %if &dsid = 0 %then %do;
        %put ERROR: Unable to open dataset &ds;
        %abort cancel;
    %end;

    %do i=1 %to %sysfunc(countw(&vars));
        %let var=%scan(&vars,&i);
        %if %sysfunc(varnum(&dsid,&var)) = 0 %then %do;
            %put ERROR: Required variable &var is missing from &ds;
            %let rc=%sysfunc(close(&dsid));
            %abort cancel;
        %end;
    %end;

    %let rc=%sysfunc(close(&dsid));
%mend;

%assert_file(path=&wbc_file, label=WBC);
%assert_file(path=&twin_file, label=TWIN);
%assert_file(path=&thc_file, label=THC);

proc import datafile="&wbc_file"
    out=wbc_validate
    dbms=csv
    replace;
    getnames=yes;
run;

%assert_vars(
    ds=wbc_validate,
    vars=Status Eccentricity Area Perimeter Solidity Extent Diameter
);

title "WBC Validation - Observation Counts and Status Labels";
proc freq data=wbc_validate;
    tables Status / missing;
run;

title "WBC Validation - Missing Values and Ranges";
proc means data=wbc_validate n nmiss min max;
    var Eccentricity Area Perimeter Solidity Extent Diameter;
run;

data wbc_unexpected_status;
    set wbc_validate;
    if Status not in ("Diseased", "Non-diseased");
run;

proc sql noprint;
    select count(*) into :wbc_bad_status trimmed
    from wbc_unexpected_status;
quit;

%if &wbc_bad_status > 0 %then
    %put WARNING: WBC dataset contains &wbc_bad_status observation(s) with unexpected Status values.;

proc sort data=wbc_validate out=wbc_unique nodupkey dupout=wbc_duplicates;
    by _all_;
run;

proc sql noprint;
    select count(*) into :wbc_dup_count trimmed from wbc_duplicates;
quit;

%put NOTE: WBC duplicate row count = &wbc_dup_count;

proc import datafile="&twin_file"
    out=twin_validate
    dbms=csv
    replace;
    getnames=yes;
run;

%assert_vars(
    ds=twin_validate,
    vars=X1_T1 X1_T2 X2_T1 X2_T2 X3_T1 X3_T2 X4_T1 X4_T2
);

title "Twin Validation - Missing Values and Ranges";
proc means data=twin_validate n nmiss min max;
    var X1_T1 X1_T2 X2_T1 X2_T2 X3_T1 X3_T2 X4_T1 X4_T2;
run;

proc sort data=twin_validate out=twin_unique nodupkey dupout=twin_duplicates;
    by _all_;
run;

proc sql noprint;
    select count(*) into :twin_dup_count trimmed from twin_duplicates;
quit;

%put NOTE: Twin duplicate row count = &twin_dup_count;

proc import datafile="&thc_file"
    out=thc_validate
    dbms=csv
    replace;
    getnames=yes;
run;

%assert_vars(
    ds=thc_validate,
    vars=chem1 chem2 chem3 chem4 chem5 chem6 chem7 chem8 chem9 chem10 chem11 chem12 chem13
);

title "THC Validation - Missing Values and Ranges";
proc means data=thc_validate n nmiss min max;
    var chem1 chem2 chem3 chem4 chem5 chem6 chem7
        chem8 chem9 chem10 chem11 chem12 chem13;
run;

proc sort data=thc_validate out=thc_unique nodupkey dupout=thc_duplicates;
    by _all_;
run;

proc sql noprint;
    select count(*) into :thc_dup_count trimmed from thc_duplicates;
quit;

%put NOTE: THC duplicate row count = &thc_dup_count;

title;
