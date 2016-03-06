data corr_eg;
input gender $ height weight age;
height2=height**2;
datalines;
M 68 155 23
F 61 99 20
F 63 115 21
M 70 205 45
M 69 170 .
F 65 125 30
M 72 220 48
;
run;

proc print data=corr_eg;
run;

proc corr data=corr_eg;
title 'Example of a Correlation Matrix';
var height weight;
partial age;
run;

proc reg data=corr_eg;
title 'Regression Line for Height-Weight Data';
Model weight=height;
run;

proc plot data=corr_eg;
plot weight*height;
run;

proc reg data=corr_eg;
model weight=height height2;
plot residual.*height='o';
run;
