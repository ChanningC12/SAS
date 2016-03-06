libname optum "/sscc/home/c/ccn371/optum";

data contribution;
infile "/sscc/home/c/ccn371/optum/contribution_sas.csv" 
firstobs=2 dsd dlm="," termstr=cr truncover;
input contribution decile;
run;

proc print data=contribution(obs=10);
run;

proc rank data=contribution out=optum.contribution_decile groups=10;
var contribution;
ranks decile2;
run;

proc print data=optum.contribution_decile(obs=10) noobs;
run;

proc freq data=optum.contribution_decile;
tables decile decile2;
run;

proc means data=optum.contribution_decile;
class decile2;
var contribution;
run;