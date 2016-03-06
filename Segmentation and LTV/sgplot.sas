data pdf;
input x p @@;
datalines;
0 2 1 4 2 3 3 1
;
run;

proc print data=pdf;
run;

proc sgplot data=pdf;
histogram x / freq=p nbins=4;
xaxis label='number of orders (x)';
yaxis label='P(X=x) as a percent';
run;