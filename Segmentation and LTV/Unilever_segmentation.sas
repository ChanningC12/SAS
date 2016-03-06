libname grocery '/sscc/datasets/imc486/Cahill/grocery';
libname cc '/sscc/home/c/ccn371/Segmentation LTV';

proc contents data=cc.unilever_customer;
run;

proc means data=cc.unilever_customer n min max skewness mean;
run;

proc corr data=cc.unilever_customer;
run;

data adjusted_customer;
set cc.unilever_customer;
log_custot=log(cus_tot+1);
log_dairytot=log(dairy_tot+1);
log_frotot=log(fro_tot+1);
log_bevtot=log(bev_tot+1);
log_groctot=log(groc_tot+1);
log_hbtot=log(hb_tot+1);
log_times=log(times+1);
keep cnsm_id log_custot tenure recency 
log_dairytot log_frotot log_bevtot log_groctot log_hbtot log_times;
run;

proc means data=adjusted_customer n min max mean skewness;
run;

proc factor data=adjusted_customer
rotate=varimax score reorder fuzz=0.3 out=customer3 outstat=score nfactors=4;
var log_custot log_dairytot 
log_frotot log_bevtot 
log_groctot log_hbtot tenure recency log_times;
run;

proc fastclus data=customer3 maxiter=1 maxclusters=100 mean=seed1;
var factor1-factor4;
run;

proc sort data=seed1;
by descending _freq_;
run;

proc fastclus data=customer3 maxiter=100 maxclusters=4 
seed=seed1(obs=4) drift converge=0 strict=2 mean=seed2;
var factor1-factor4;
run;

proc fastclus data=customer3 maxiter=0 maxclusters=4 
seed=seed2(obs=4) replace=none out=scores;
var factor1-factor4;
run;

proc print data=scores(obs=10);
run;

proc means data=scores;
run;










