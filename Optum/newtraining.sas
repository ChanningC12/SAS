%let q = Q9_1 Q9_2 Q9_3 Q9_4 Q9_5 Q9_6 Q9_7 Q10_1 Q10_2 Q10_3 Q10_4 Q10_5 Q14;
%let qq= qq1-qq13; 
data newtraining;
infile "/sscc/home/c/ccn371/optum/Provider Training Survey New.csv" 
firstobs=2 dsd dlm=',' 
termstr=cr truncover;
input Q3 &q I1-I23;
run;

proc print data=newtraining(obs=10);
run;

proc glm data=newtraining;
class Q3;
model Q14 = Q3 / solution;
means Q3 / DUNCAN;
run;

proc reg data=newtraining;
model Q14=Q9_1 Q10_1;
run;

%macro ins(I);
proc means data=newtraining maxdec=2;
var Q9_1 Q10_1 Q14;
where &I=1;
run;
%mend ins;


data newtraining;
set newtraining;
where Q3=5;
run;

proc print data=newtraining(obs=50);
run;

proc corr data=newtraining;
var &q;
run;

proc reg data=newtraining;
model Q14=Q9_1 Q10_1;
run;


data newcourseip;
set newtraining;
array q{*} &q;
length qq1-qq13 4;
array qq{*} qq1-qq13;
Xbar=mean(of &q);
Do I=1 to 13;
qq{I}=q{I}-Xbar;
end;
run;

proc print data=newcourseip(obs=20);
run;

proc corr data=newcourseip;
var qq1-qq13;
run;

proc reg data=newcourseip;
model qq13 = qq1 qq8;
run;

proc means data=newcourseip;
run;

proc reg data=newcourseip;
model qq1=qq2-qq7;
run;

proc reg data=newcourseip;
model qq8=qq9-qq12;
run;

proc factor data=newcourseip
rotate=varimax score reorder out=courseipfac nfactors=4;
var qq1-qq12;
run;

proc standard data=courseipfac mean=0 std=1 out=final;
var qq13;
run;

proc print data=courseipfac(obs=20);
run;

proc means data=final;
run;

proc reg data=final;
model qq13=factor1 factor2 factor3 factor4;
run;



