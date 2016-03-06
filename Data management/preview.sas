libname sscc "/sscc/datasets/imc498/airmiles2";
data assign22;
SET sscc.posts;
proc sort data=assign22;
by extref;
Run;

data assign221;
set assign22;
by extref;
IF first.extref;
keep extref;
RUN;

proc print data=assign221(obs=10);
run;

