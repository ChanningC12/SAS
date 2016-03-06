data prepost;
input subj group $ pretest postest;
diff=postest-pretest;
datalines;
1 C 80 83
2 C 85 86
3 C 83 88
4 T 82 94
5 T 87 93
6 T 84 98
;

proc print data=prepost;
run;

proc ttest data=prepost;
title 'T-test on Difference Scores';
class group;
var diff;
run;

proc anova data=prepost;
title 'Two-way ANOVA with a Repeated Measure on One Factor';
class group;
model pretest postest = group / nouni;
repeated time 2 (0 1);
means group;
run;

