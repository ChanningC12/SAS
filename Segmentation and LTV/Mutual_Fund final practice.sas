libname mua '/sscc/home/c/ccn371/Segmentation LTV';

proc contents data=mua.investdata;
run;

proc print data=mua.investdata(obs=50);
run;

proc means data=mua.investdata;
format opendt date.;
run;

/*roll up*/
proc sort data=mua.investdata out=invest;
by cust_num;
run;

data rollup;
set invest;
by cust_num;

retain frstdt totbal numact tot_bond tot_equity tot_other numactive;
keep cust_num frstdt totbal numact tot_bond tot_equity 
tot_other numactive risk_level pct_bond age num_category
age_fill;

if first.cust_num then do;
frstdt='31DEC2050'd;
totbal=0;
numact=0;
numactive=0;
tot_bond=0;
tot_equity=0;
tot_other=0;
end;

if frstdt gt opendt then frstdt=opendt;
totbal=totbal+balance;
numact=numact+1;
if balance gt 0 then numactive=numactive+1;

if category='bonds' then tot_bond=tot_bond+balance;
if category='equity' then tot_equity=tot_equity+balance;
if category='other' then tot_other=tot_other+balance;

if last.cust_num then do;
tenure='22OCT2008'd - frstdt;
num_category=(tot_bond gt 0)+(tot_equity gt 0)+(tot_other gt 0);

if totbal gt 0 then pct_bond=tot_bond/totbal;
else pct_bond=0;

if totbal gt 0 then 
risk_level=(tot_bond*1+tot_equity*2+tot_other*1)/totbal;
else risk_level=0;

if age lt 18 then age_fill=54.5;
else age_fill=age;

output;
end;

run;

proc print data=rollup(obs=20);
format frstdt mmddyy9.;
run;

proc means data=rollup;
run;

proc freq data=rollup;
tables age;
run; 



data rollup_active;
set rollup;
where totbal gt 0;
run;


proc factor data=rollup_active rotate=varimax reorder out=fact
nfactors=4;
var frstdt totbal numactive tot_bond tot_equity tot_other
risk_level num_category age_fill;
run;

proc fastclus data=fact maxclusters=75 maxiter=1 mean=seed;
var factor1-factor4;
run; 

proc sort data=seed;
by descending _freq_;
run;

proc fastclus data=fact maxcluster=6 maxiter=100 seed=seed(obs=6)
drift converge=0;
var factor1-factor4;
run;

proc fastclus data=fact maxcluster=7 maxiter=100 seed=seed(obs=7)
drift converge=0;
var factor1-factor4;
run;

proc fastclus data=fact maxcluster=7 maxiter=100 seed=seed(obs=7)
drift converge=0 strict=1 mean=seed1;
var factor1-factor4;
run;

proc fastclus data=fact maxcluster=7 maxiter=0 seed=seed1(obs=7)
replace=none out=scores;
var factor1-factor4;
run;

















