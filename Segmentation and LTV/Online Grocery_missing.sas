libname grocery '/sscc/datasets/imc486/Cahill/grocery';
libname cc '/sscc/home/c/ccn371/Segmentation LTV';

/*Check frequency of demographic variables to see how many missing values exist*/
proc freq data=grocery.cust;
tables hhincome educ dwelling prkids home_own_rent marital_stat online_dols
match_level life_stage;
run;

/*Check the skewness to see if we need to take log*/
proc means data=cc.customer1 n min max skewness mean;
run;

/*Check the correlation between variables*/
proc corr data=cc.customer1;
run;

/*Create log variables*/
data customer2;
set cc.customer1;
log_custot=log(cus_tot+1);
log_babytot=log(baby_tot+1);
log_delitot=log(deli_tot+1);
log_dairytot=log(dairy_tot+1);
log_frotot=log(fro_tot+1);
log_snacktot=log(snack_tot+1);
log_bevtot=log(bev_tot+1);
log_alctot=log(alc_tot+1);
log_fretot=log(fre_tot+1);
log_prodtot=log(prod_tot+1);
log_groctot=log(groc_tot+1);
log_hbtot=log(hb_tot+1);
log_hgtot=log(hg_tot+1);
log_hhtot=log(hh_tot+1);
log_times=log(times+1);
keep log_custot log_babytot log_delitot tenure recency 
log_dairytot log_frotot log_snacktot log_bevtot log_alctot
log_fretot log_prodtot log_groctot log_hbtot log_hgtot log_hhtot log_times;
run;

proc means data=customer2 n min max mean skewness;
run;

/*Cluster analysis*/
proc factor data=customer2
rotate=varimax score reorder out=customer3 outstat=score nfactors=4;
var log_custot log_babytot log_delitot log_dairytot 
log_frotot log_snacktot log_bevtot log_alctot log_fretot log_prodtot 
log_groctot log_hbtot log_hgtot log_hhtot tenure recency log_times;
run;

proc print data=customer3(obs=10);
run;

proc print data=score(obs=10);
run;

proc fastclus data=customer3 maxiter=1 maxclusters=100 mean=seed1;
var factor1-factor4;
run;

proc sort data=seed1;
by descending _freq_;
run;

proc contents data=customer3;
run;

proc fastclus data=customer3 maxclusters=6 maxiter=100 
seed=seed1(obs=6) drift converge=0 strict=1 mean=seed2;
var factor1-factor4;
run;

proc fastclus data=customer3 maxclusters=6 maxiter=0 
seed=seed2(obs=6) replace=none out=scores;
var factor1-factor4;
run;

proc print data=scores(obs=10);
run;

proc means data=scores;
run;

proc tabulate data=scores format=comma8.4;
class cluster;
var factor1-factor4;
table n(factor1-factor4)*mean,cluster all;
title 'Customer Profiles';
run;

proc means data=scores maxdec=2;
class cluster;
run;





