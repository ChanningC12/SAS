libname hw2 '/sscc/home/c/ccn371/Segmentation LTV';

proc contents data=hw2.investdata;
run;

proc print data=hw2.investdata(obs=100);
format opendt mmddyy9.;
run;

proc means data=hw2.investdata;
run;

proc univariate data=hw2.investdata;
var age;
run;

proc freq data=hw2.investdata;
tables category;
run;

proc sort data=hw2.investdata out=invest;
by cust_num;
run;

/*
1. roll up cust_num, create balance by categories, tenure, total accounts
segmentation variable: total balance, equity balance, other balance
funds balance, tenure
*/

data customer;
set invest;
by cust_num;

retain balance_tot account_num frstdt lastdt tenure 
recency equity_tot bonds_tot other_tot;

keep cust_num balance_tot account_num frstdt lastdt tenure recency 
equity_tot bonds_tot other_tot;

if first.cust_num then do;
balance_tot=0;
account_num=0;
frstdt='31DEC2040'd;
lastdt='31DEC1959'd;
equity_tot=0;
bonds_tot=0;
other_tot=0;
end;
if frstdt gt opendt then frstdt=opendt;
if lastdt lt opendt then lastdt=opendt;
balance_tot=balance_tot+balance;
account_num=account_num+1;
if category='equity' then equity_tot=equity_tot+balance;
if category='bonds' then bonds_tot=bonds_tot+balance;
if category='other' then other_tot=other_tot+balance;

if last.cust_num then do;
tenure=(today()-frstdt)/365.25;
recency=(today()-lastdt)/365.25;
output;
end;
run;

proc print data=customer(obs=20);
format frstdt mmddyy9.;
format lastdt mmddyy9.;
run;

proc means data=customer;
run;

proc factor data=customer 
rotate=varimax score reorder out=segmentation nfactors=3;
var balance_tot account_num equity_tot bonds_tot other_tot
tenure recency;
run;

proc fastclus data=segmentation maxclusters=75 maxiter=1 mean=seed1;
var factor1-factor3;
run;

proc sort data=seed1;
by descending _freq_;
run;

proc fastclus data=segmentation maxclusters=3 seed=seed1(obs=5)
maxiter=100 drift converge=0 strict=1 mean=seed2;
var factor1-factor3;
run;

proc fastclus data=segmentation maxclusters=3 seed=seed2(obs=5)
maxiter=0 replace=none out=scores;
var factor1-factor3;
run;



