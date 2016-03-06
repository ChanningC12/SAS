libname fuck "/sscc/datasets/imc498/airmiles2";

proc sort data=fuck.key out=assign1;
by extref;
run;

proc sort data=fuck.posts out=assign2;
by extref;
run;

data assign3;
merge assign1 assign2(in=post);
retain tx;
if post then tx=1;
else tx=0;
by extref;
run;

proc print data=assign3(obs=400);
run;

