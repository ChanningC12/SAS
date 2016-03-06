data response;
input group $ time;
datalines;
C 80
C 93
C 83
C 89
C 98
T 100
T 103
T 104
T 99
T 102
;
proc ttest data=response;
title 'T-test Example';
class group;
var time;
run;

data tumor;
input group $ mass @@;
datalines;
A 3.1 A 2.2 A 1.7 A 2.7 A 2.5
B 0.0 B 0.0 B 1.0 B 2.3
;
run;

proc npar1way data=tumor wilcoxon;
title 'Nonparametric test to compare tumor masses';
class group;
var mass;
exact wilcoxon;
run;




