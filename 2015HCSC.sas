proc import datafile="C:\Users\chicheng3\Desktop\SQL Practice\2015_HCSC.csv"
dbms=csv out=HCSC2015 replace;
label
	LOB = "line of business"
	LOB_Product = "Product segment"
run;

proc print data=HCSC2015(obs=10);
run;

proc means data=HCSC2015 maxdec=2;
run;

proc freq data=HCSC2015;
tables Metrics;
run;
