%let q = Q9_1 Q9_2 Q9_3 Q9_4 Q9_5 Q9_6 Q9_7 Q10_1 Q10_2 Q10_3 Q10_4 Q10_5 Q14;
%let qq= Q1-Q12 Q14; 
data course;
infile "/sscc/home/c/ccn371/optum/training.csv" firstobs=2 dsd dlm=',' 
termstr=cr truncover;
input Q3 Q1-Q12 Q14;
run;

proc print data=course(obs=10);
run;

proc freq data=course;
tables Q3;
run;

data course5;
set course;
where Q3=5;
run;

data course5ip;
set course5;
array q{*} &qq;
length qq1-qq13 4;
array qq{*} qq1-qq13;
Xbar=mean(of &qq);
Do I=1 to 13;
qq{I}=q{I}-Xbar;
end;
run;

proc print data=course5ip(obs=100);
run;

proc means data=course5ip mean max min skewness;
run;

proc corr data=course5ip;
var qq1 qq8 qq13;
run;

data course5ip2;
set course5ip;
where qq1 ne 0 and qq2 ne 0 and qq3 ne 0;
run;

proc print data=course5ip2(obs=100);
run;

proc reg data=course5ip2;
model qq13=qq1 qq8;
run;

proc means data=course5ip mean min max skewness std;
var qq13 qq1 qq8;
run;

proc factor data=course5ip rotate=varimax 
score reorder out=coursefac nfactor=4;
var qq1-qq12;
run;

proc standard data=coursefac;
var qq13;
run;

proc print data=coursefac(obs=10);
run;

proc reg data=coursefac;
model qq13=factor1-factor4;
run;

proc means data=course5ip mean max min skewness;
var qq1-qq13;
run;



