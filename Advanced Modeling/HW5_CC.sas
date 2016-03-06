libname sscc "/sscc/datasets/imc490b";
/*examine dataset*/
proc print data=sscc.dmef3(obs=50);
run;

proc contents data=sscc.dmef3;
run;

proc univariate data=sscc.dmef3;
run;

/*examine level of data*/
proc sql;
select count(distinct CUSTNO) as cust from sscc.dmef3;
quit;

/*train=1*/
data hw5;
set sscc.dmef3;
where train=1;
logtargamnt=log(TARGAMNT+1);
run;

proc print data=hw5(obs=50);
run;

proc contents data=hw5;
run;

proc univariate data=hw5;
var logtargamnt;
run;

/*select top 20000 observations*/
data hw5;
set hw5;
TOT=TOTSALE+TARGAMNT;
run;

proc print data=hw5(obs=20);
run;

proc sort data=hw5;
by descending TOT;
run;

data hw5;
set hw5;
sequence=_N_;
run;

proc print data=hw5(obs=20);
run;

data hw5_2;
set hw5;
where sequence le 20000;
run;

proc contents data=hw5_2;
run;






