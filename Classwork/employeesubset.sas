libname sscc "/sscc/datasets/imc498";
options ls=72 ps=9999;

data female;
set sscc.employee;
if female=1;
run;

proc print data=female;
run;

proc freq data=female;
table female;
run;

data females;
set sscc.employee;
if female ne 1 then delete;
run;


proc print data=females;
run;

proc freq data=females;
table female;
run;

proc freq data=females;
table female;
where female=1;
run;