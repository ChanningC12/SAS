data clv;
do r=0.7 to 0.98 by 0.01;
Et=1/(1-r);
Eclv=25*1.01/(1.01-r);
output;
end;
format clv dollar8.2
r percent5.0 Et 5.2;
label
Et="E(T)";
Eclv="E(CLV)";
run;

proc print data=clv noobs label;
var r Et Eclv;
where mod(100*r,5)=0 or r=0.98;
run;

proc sgplot data=clv;
series X=r Y=Eclv;
xaxis label='Retention Rate (r)';
run;


data service1yr;
input bigT cancel count @@;
label bigT='Cancelation Time(T)'
cancel='Dummy 1=cancel, 0=censored';
datalines;
2 1 4 3 1 16 4 1 20 5 1 37 6 1 28 7 1 61 8 1 24 9 1 19 
10 1 13 11 1 10 12 1 13 1 0 3 3 0 2 4 0 1 5 0 7 6 0 33 7 0 49 
8 0 63 9 0 30 10 0 16 11 0 34 12 0 188
;
run;

proc print data=service1yr;
run;

proc means data=service1yr maxdec=0 sum;
var cancel bigT;
weight count;
output out=answer sum=;
run;

proc sql;
select 
cancels label='Number cancels',
flips label='Opporunities to cancel',
Rhat label='Retention Rate(r)' format=6.4,
1/(1-Rhat) as ET label='E(T)' format=5.1,
1+log(0.5)/log(Rhat) as median label='Median(T)' format 3.0
from (select sum(cancel) as cancels,
sum(bigT) as flips,
1-sum(cancel)/sum(bigT) as Rhat
from answer);
















