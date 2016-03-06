libname hw2 '/sscc/home/c/ccn371/Segmentation LTV';

proc contents data=hw2.investdata;
run;

proc print data=hw2.investdata(obs=50);
run;

proc means data=hw2.investdata;
run;

proc freq data=hw2.investdata;
tables category;
run;

proc sort data=hw2.investdata out=invest;
by cust_num;
run;



data customer;
set invest;
by cust_num;

retain age1 balance_tot account_num tenure equity_tot bonds_tot other_tot;

keep cust_num age1 balance_tot account_num tenure equity_tot bonds_tot other_tot;

if first.cust_num then do;
balance_tot=0;
account_num=0;
tenure="31DEC2040"d;
age1=0;
equity_tot=0;
bonds_tot=0;
other_tot=0;
end;
if tenure gt opendt then tenure=opendt;
if age1 lt age then age1=age;
balance_tot=balance_tot+balance;
account_num=account_num+cust_num/cust_num;
if category='equity' then equity_tot=equity_tot+balance;
if category='bonds' then bonds_tot=bonds_tot+balance;
if category='other' then other_tot=other_tot+balance;

if last.cust_num then do;
tenure=(today()-opendt)/365.25;
output;
end;
run;

proc print data=customer(obs=50);
run;

proc means data=customer;
run;

proc factor data=customer 
rotate=varimax score reorder out=segmentation nfactors=4;
var balance_tot account_num tenure equity_tot bonds_tot other_tot;
run;

proc fastclus data=segmentation maxclusters=75 maxiter=1 mean=seed1;
var balance_tot account_num tenure equity_tot bonds_tot other_tot;
run;

proc sort data=seed1;
by descending _freq_;
run;

proc fastclus data=segmentation maxclusters=6 maxiter=100 
drift strict=1.5 seed=seed1(obs=6) converge=0 mean=seed1_2;
var balance_tot account_num tenure equity_tot bonds_tot other_tot;
run;


proc fastclus data=segmentation maxclusters=6 seed=seed1_2(obs=6)
maxiter=0 replace=none out=scores;
var balan

_tot account_num tenure;
run;






