DATA example;
INPUT id amt;
DATALINES;
1 10
1 20
2 5
2 3
2 2
3 40
RUN;
PROC PRINT DATA=example; 
RUN;

data newdata;
set example;
by id;
if first.id then firstrec="Y";
else firstrec="N";
if last.id then lastrec="Y";
else lastrec="N";
run;

proc print data=newdata;
run;

data newdata2;
set example;
by id;
if first.id;
keep id;
run;

proc print data=newdata2;
run;

data newdata3;
set example;
by id;
retain monetary 0;
if first.id then monetary=0;
if last.id;
keep id monetary;
monetary=monetary + amt;
run;

proc print data=newdata3 noobs;
run;