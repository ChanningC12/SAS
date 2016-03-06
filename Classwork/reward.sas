data assignment4;
infile "/sscc/datasets/imc498/airmiles2/reward.txt"
FIRSTOBS=2 DSD DLM='09'x;
informat BookingDate mmddyy10. Category $12.;
input COLLECTOR_KEY	$ Collector_Number $ BookingDate Category $ UNITS TOTAL_MILES;
format BookingDate mmddyy10.;
run;
proc print data=assignment4(obs=10);
run;
proc means data=assignment4;
run;
