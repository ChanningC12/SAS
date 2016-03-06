libname shi"/sscc/datasets/imc498/airmiles2";
data assignt3;
SET shi.posts;
proc sort data=assignt3;
by extref;
Run;

data assign33;
set assignt3;
by extref;
IF first.extref;
keep extref;
RUN;

proc print data=assign33;
run;
