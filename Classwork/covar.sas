data covar;
length group $1;
input group math IQ @@;
datalines;
A 260 105 A 325 115 A 300 122 A 400 125 A 390 138
B 326 126 B 440 135 B 425 142 B 500 140 B 600 160
;
proc corr data=covar nosimple;
title 'Covariate Example';
var math IQ;
run;

proc ttest data=covar;
class group;
var IQ math;
run;

proc ttest data=covar;
class group;
var iq math;
run;

proc glm data=covar;
class group;
model math=IQ group IQ*group;
run;

proc glm data=covar;
class group;
model math=IQ group;
lsmeans group;
run;
