%let qall = q1-q16;
%let qqall = qq1-qq16;
data survey;
infile "/sscc/home/c/ccn371/optum/LRT_survey.csv" firstobs=2 dsd dlm=',' 
termstr=cr truncover;
input recommend overall &qall;
run;

proc print data=survey(obs=10);
run;

proc means data=survey;
var &qall;
run;

proc freq data=survey;
tables overall;
run;

proc factor data=survey rotate=varimax 
score reorder out=surveyfac nfactor=3 fuzz=.3;
var &qall;
run;

proc factor data=survey rotate=promax 
score reorder out=surveyfac nfactor=3 fuzz=.3;
var q6 q9 q10 q8 q11 q14 q16 q12 q3 q2 q5 q4;
run;


proc reg data=surveyfac corr;
  model overall = factor1 factor2 factor3 / vif;
run;
proc logistic data=surveyfac descending;
  model recommend = factor1 factor2 factor3;
run;
data new;
  set survey;
  engage = MEAN(OF q6 q9 q10 q8);
  quality = MEAN(OF q11 q14 q16 q12);
  implement = MEAN(OF q3 q2 q5 q4);
run;

proc reg data=new;
  model overall = quality;
  model overall = quality implement;
  model overall = quality implement engage / stdb;
  model overall = engage;
run;

/* ANOVA */
proc glm data=
class gender;
model overall = gender / solutions;
means gender / DUNCAN;
run

proc reg data=new corr;
  model overall = engage quality implement / vif;
run;
proc logistic data=new descending;
  model recommend = engage quality implement;
run;


data surveynew;
set survey;
array q{*} &qall;
length &qqall 4;
array qq{*} &qqall;
xbar = mean (of &qall);
do I=1 to 16;
qq{I}=q{I}-xbar;
end;
run;

proc print data=surveynew(obs=10);
run;

proc factor data=surveynew rotate=varimax
score reorder out=surveynewfac nfactor=3 fuzz=.3;
var &qqall;
run;

proc print data=surveynewfac(obs=10);
run;

proc standard data=surveynewfac mean=0 std=1 out=zfac;
var overall;
run;

proc print data=zfac;
run;

proc reg data=zfac;
model overall = factor1-factor3;
run;




