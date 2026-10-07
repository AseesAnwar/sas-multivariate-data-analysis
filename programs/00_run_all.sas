/*
    Multivariate Analysis Assignment 2
    Master SAS runner

    Update project_root to the folder that contains this repository.
*/

%let project_root = /home/u64477816/sas-multivariate-assignment-2;

%include "&project_root/programs/00_data_validation.sas";
%include "&project_root/programs/01_wbc_hotelling_and_pca.sas";
%include "&project_root/programs/02_twin_hotelling.sas";
%include "&project_root/programs/03_thc_pca.sas";
