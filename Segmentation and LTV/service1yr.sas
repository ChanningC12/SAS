data service1yr;
input bigT cancel count @@;
label bigT="Cancelation Time(T)"
cancel = "Dummy 1=cancel, 0=censored";

datalines;
2 1 4    3 1 16   4 1 20   5 1 37  6 1 28  7 1 61   8 1 24
9 1 19   10 1 13  11 1 10   12 1 13  1 0 3  3 0 2   4 0 1  
5 0 7   6 0 33   7 0 49   8 0 63   9 0 30   10 0 16   11 0 34  
12 0 188
;
run;

proc print data=service1yr;
run;

proc lifetest data=service1yr plots=s;
time bigT*cancel(0);
freq count;
run;

proc lifetest data=service1yr method=life intervals=1 to 12 by 1
plots=(s,h,p);
time bigT*cancel(0);
freq count;
run;


proc format;
value model
1='SRM'
2='GRM';
run;

data srm;
model=1;
h_t=245/5828;
S_t=100000;
cancel=1;
do bigT = .5 to 12.5 by 1;
count=S_t*h_t;
output;
S_t=S_t-count;
end;

count=S_t;
cancel=0;
output;
run;

data both;
set srm service1yr;
if model=. then model=2;
format model model.;
run;

proc lifetest data=both
method=life interval=0 to 12 by 1 outsurv=out1
plots=(s,h,p);
time bigT*cancel(0);
freq count;
strata model;
run;







