DATA tmp;
INPUT x;
DATALINES;
5
3
6
8
2
7
9
4
1
RUN;

title "raw data";
proc print data=tmp;
run;

proc rank data=tmp group=3 out=tmp;
var x;
ranks x3;
run;

title "after rank";
proc print data=tmp;
run;