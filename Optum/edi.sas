data edi;
infile "/sscc/home/c/ccn371/optum/EDI.csv" firstobs=2
truncover termstr=cr dsd dlm=',';
input name:$30. position:$30. entity: $30. company:$30. year date:mmddyy9. 
Q2_1-Q2_5 Q3_1-Q3_3 Q4_1-Q4_3;
run;

proc print data=edi(obs=30);
run;

proc freq data=edi;
tables year company;
run;


proc sql;
create table edii as
select year,
avg(Q2_1) as Q2_1avg,avg(Q2_2) as Q2_2avg,avg(Q2_3) as Q2_3avg,
avg(Q2_4) as Q2_4avg,avg(Q2_5) as Q2_5avg,
avg(Q3_1) as Q3_1avg,avg(Q3_2) as Q3_2avg,avg(Q3_3) as Q3_3avg,
avg(Q4_1) as Q4_1avg, avg(Q4_2) as Q4_2avg, avg(Q4_3) as Q4_3avg from edi
group by year;
quit;

proc print data=edii;
run;


proc sql;
create table edi2 as
select company,
avg(Q2_1) as Q2_1avg,avg(Q2_2) as Q2_2avg,avg(Q2_3) as Q2_3avg,
avg(Q2_4) as Q2_4avg,avg(Q2_5) as Q2_5avg,
avg(Q3_1) as Q3_1avg,avg(Q3_2) as Q3_2avg,avg(Q3_3) as Q3_3avg,
avg(Q4_1) as Q4_1avg, avg(Q4_2) as Q4_2avg, avg(Q4_3) as Q4_3avg from edi
group by company;
quit;

proc print data=edi2(obs=30);
run;

proc corr data=edi;
var Q2_1-Q2_5 Q3_1-Q3_3 Q4_1-Q4_3;
run;

proc sql;
create table edi3 as
select company, 
(Q2_1avg+Q2_2avg+Q2_3avg+Q2_4avg+Q2_5avg)/5 as Q2avg,
(Q3_1avg+Q3_2avg+Q3_3avg)/3 as Q3avg,
(Q4_1avg+Q4_2avg+Q4_3avg)/3 as Q4avg
from edi2;
quit;

proc print data=edi3(obs=30);
run;

proc means data=edi;
var Q2_1-Q2_5 Q3_1-Q3_3 Q4_1-Q4_3;
run;

data edi4;
set edi;
avg2=(Q2_1+Q2_2+Q2_3+Q2_4+Q2_5)/5;
avg3=(Q3_1+Q3_2+Q3_3)/3;
avg4=(Q4_1+Q4_2+Q4_3)/3;
run;

proc print data=edi4(obs=30);
run;

proc means data=edi4;
var avg2-avg4;
run;

