data ritalin;
do group='normal','hyper';
do drug='placebo','ritalin';
do subj=1 to 4;
input activity @;
output;
end;
end;
end;
datalines;
50 45 55 52 67 60 58 65 70 72 68 75 51 57 48 55
;

proc print data=ritalin;
run;

proc sort data=ritalin;
by group;
run;

proc ttest data=ritalin;
by group;
class drug;
var activity;
run;