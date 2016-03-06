libname sscc "/sscc/datasets/imc498/airmiles2";
data assign21;
SET sscc.trans;
proc sort data=sscc.trans;
by collector_number;
Run;

data assign211;
set assign21;
by collector_number;
Retain Y0 Y1 Y2 Y3;
IF first.collector_number Then do; 
  Y0=0;
  Y1=0;
  Y2=0; 
  Y3=0;
END;
DIFF=Tdate-"01JAN2010"D;
if 0<=diff<=340  THEN Y0=Y0+AM_ISSUED;
else if 340<diff<=354 THEN Y1=Y1+AM_ISSUED;
else if 354<diff<=368 THEN Y2=Y2+AM_ISSUED;
else if 368<diff<=382 THEN Y3=Y3+AM_ISSUED;
if last.collector_number;
keep collector_number Y0 Y1 Y2 Y3;
RUN;

proc print data=assign211(obs=10);
run;

proc means data=assign211;
run;


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




proc sort data=sscc.key out=assign231;
by extref;
run;

proc sort data=sscc.posts out=assign232;
by extref;
run;

data assign233;
merge assign231 assign232(in=post);
retain tx;
if post then tx=1;
else tx=0;
by extref;
run;

proc print data=assign233(obs=400);
run;



proc sort data=assign211 out=assign241;
by collector_number;
run;

proc sort data=assign233 out=assign242;
by collector_number;
run;


data assign243;
merge assign241 assign242;
by collector_number;
run;

proc print data=assign243(obs=100);
run;

data assign251;
set assign243;
log1=log(y1+1);
log2=log(y2+1);
log3=log(y3+1);
log0=log(y0+1);
run;

proc reg data=assign251;
model log1=log0 tx;
model log1=log0 tx;
model log1=log0 tx;
run;
