/*
Standardize variables
Outliers, think about what is the meaning of these outliers
Proc factor standardize the data;
Factor scores are standardized variables, mean=0, std=1;

The starting points of segment are called seeds (clusters=3, 3 starting points)
Calculate the distance bewtween points and data points to determine clusters.
Assign the data points to clusters
At the end of process, it takes all the points and recalculate the centers.
Use the starting points, take all the data out of the pool and repeat the process,
reassign every data points---interiations!
fastclus, limit the effect outliers, or it puts the seed to somewhere else.
Restrict the distance, stablize the seeds
number of interiations is important, find the best locations of clusters
Once you got the interiation fixed, make interiation equals 0, don't move it anymore
Drift(early on): within the interiation, it recalculate the center, drift around.
Strict(limit the effect of outlier), start border, exclude more than 20%
*/

libname hw2 "/sscc/datasets/imc486/Cahill";

proc means data=hw2.bookorder_customer_unix skewness n min max mean;
run;

data customerlog1;
set hw2.bookorder_customer_unix;
logitem=log(itemhist);
logmonetary=log(monetary);
logfreq=log(freq);
logrecency=log(recency);
logAOA=log(AOA);
logAOS=log(AOS);
loglambda=log(lambda);
logAmtPerYear=log(AmtPerYear);
keep id logitem logmonetary logfreq logrecency logAOA logAOS loglambda TOF logAmtPerYear;
run;

/*log all the right-skewed variables*/

data customerlog;
set customerlog1;
where logitem<6 and logfreq<4.62 and logAOS<2.4 and loglambda<1.44;
run;
/*rule out all the outliers*/


/*proc standard data=customerlogp mean=0 std=1
out=customerlog;
var logitem logmonetary logfreq logrecency logAOA logAOS loglambda TOF logAmtPerYear;
run;*/

proc print data=customerlog(obs=20);
run;

proc univariate data=customerlog;
run;

proc means data=customerlog skewness n min max mean;
run;


proc factor data=customerlog
rotate=varimax score reorder out=customer outstat=score nfactors=3;
var logitem logmonetary logfreq logrecency logAOA logAOS loglambda TOF logAmtPerYear;
run;

/*outstat contkeep id logitem logmonetary logfreq logrecency logAOA logAOS loglambda logAmtPerYear;
ains factor scores matrix*/

proc univariate data=customerlog;
var factor1-factor3;
run;

proc means data=customerlog skewness n mean max min maxdec=2;
run;

proc fastclus data=customerlog maxclusters=75 maxiter=1 mean=seed_1;
var factor1-factor3;
run;

proc fastclus data=customerlog maxclusters=100 maxiter=1 mean=seed_2;
var factor1-factor3;
run;

proc fastclus data=customerlog maxclusters=125 maxiter=1 mean=seed_3;
var factor1-factor3;
run;


proc sort data=seed_1;
by descending _freq_;
run;

proc sort data=seed_2;
by descending _freq_;
run;

proc sort data=seed_3;
by descending _freq_;
run;

proc print data=seed_1(obs=20);
run;

proc print data=seed_1(obs=20);
run;

proc print data=seed_1(obs=20);
run;



/*sort the seeds that have most points, identify the clusters, obs=4 extract the clusters you need*/
/*drift is optimizing the seeds*/
/*strict is to optimize, within the radius of 1*/

proc fastclus data=customerlog maxclusters=4 
seed=seed_1(obs=4) drift converge=0 maxiter=100 strict=1.7 mean=seed_12;
var factor1-factor3;
run;

proc fastclus data=customerlog maxclusters=4 seed=seed_12(obs=4)
maxiter=0 replace=none out=scores;
var factor1-factor3;
run;

proc score data=customerlog
score=score out=results;
var logitem logmonetary logfreq logrecency logAOA logAOS loglambda TOF logAmtPerYear;
run;

proc tabulate data=scores format=comma8.4;
class cluster;
var factor1-factor3;
table n(factor1-factor3)*mean, cluster all;
title2 'Cluster Profiles';
run;

proc print data=scores(obs=50);
run;

proc means data=scores;
run;

proc fastclus data=results maxclusters=4 seed=seed_12(obs=4)
maxiter=0 replace=none out=final;
var factor1-factor3;
run;

proc tabulate data=final format=comma8.4;
class cluster;
var factor1-factor3;
table n(factor1-factor3)*mean, cluster all;
title 'Cluster Profiles';
run;


proc print data=final(obs=50);
run;

proc means data=final;
run;

