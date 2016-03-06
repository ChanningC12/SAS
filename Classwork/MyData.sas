data mydata;
input color$  x y amt;
cards;
red 1 2 12.73
blue 3 4 23.91
green 5 6 83.33
run;

proc sort data=mydata 
out=mydata2;
by descending x;
run;
title "descending x";
proc print data=mydata2 noobs;
run;

proc freq data=mydata;
tables color*(x y) / nocol norow nopercent deviation chisq;
run;

proc means data=mydata n mean max min stderr;
run;



