
data optum360;
infile "/sscc/home/c/ccn371/optum/optum360.csv" 
firstobs=2 dsd dlm=',' 
termstr=cr truncover;
input V10 Q1 Q2 Q3_1 Q3_3-Q3_8 Q4 Q5;
run;

proc print data=optum360(obs=20);
run;

proc corr data=optum360;
var Q3_1 Q3_3-Q3_8 Q5;
run;

proc factor data=optum360 reorder 
out=optum360fac rotate=varimax fuzz=0.3 nfactors=3;
var Q3_1 Q3_3-Q3_8;
run;

proc standard data=optum360fac mean=0 std=1 out=optum360fac2;
var Q5;
run;

proc print data=optum360fac2(obs=20);
run;

proc reg data=optum360fac2;
model Q5=factor1-factor3;
run;
