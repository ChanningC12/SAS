data htwt;
input subject gender $ height weight;
datalines;
1 M 68.5 155
2 F 61.2 99
3 F 63.0 115
4 M 70.0 205
5 M 68.6 170
6 F 65.1 125
7 M 72.4 220
run;
proc means data=htwt n mean maxdec=3;
title 'Simple Descriptive Statistics';
run;

proc univariate data=htwt normal plot;
var height weight;
title 'Univariate';
id subject;
run;

proc sort data=htwt;
by gender;
run;

proc means data=htwt n mean std maxdec=2;
by gender;
var height weight;
run;

proc freq data=htwt;
title 'using proc freq to compute frequencies';
tables gender;
run;

proc chart data=htwt;
vbar gender;
run;

proc chart data=htwt;
vbar height / levels=6;
run;

proc plot data=htwt;
plot weight*height=gender;
run;
