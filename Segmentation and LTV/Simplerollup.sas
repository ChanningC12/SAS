data rollup;
input customer_id $ amt;
datalines;
001 50
001 75
001 55
002 75
002 60
003 100
004 85
;
run;

proc print data=rollup noobs;
run;

proc sort data=rollup out=rollups;
by customer_id;
run;

data rollups;
set rollup;
by customer_id;

keep customer_id totamt; 

retain amt totamt;

if first.customer_id then do;

totamt=0;
end;
totamt=totamt+amt;

if last.customer_id then do;
output;
end;

run;

proc print data=rollups;
run;













