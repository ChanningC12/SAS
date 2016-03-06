data mydata;
input color$  x y amt;
cards;
red 1 2 12.73
blue 3 4 23.91
green 5 6 83.33
run;

title "original";
proc print data=mydata noobs;
run;

data newdata;
set mydata(drop=color amt);
xsqr=x**2;
logy=log(y);
run;

title "drop 2 add 2";
proc print data=newdata;
run;

data newdata;
set newdata;
sqrtx = sqrt(x);
run;
proc print data=newdata noobs;
run;
