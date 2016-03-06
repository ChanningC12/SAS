libname modeling "/sscc/datasets/imc490b";

proc contents data=modeling.dmef3;
run;

proc sgplot data=modeling.dmef3; /*sgplot to create graph*/
histogram ordcls3;
run;

proc * Put this line before opening any ODS destinations. ;
options orientation = landscape ;

  ods graphics / height = 6in width = 10in ;

  proc sgplot data = gnu ;
    * scatter x = adate y = source_count / group = source ;
    loess x = adate y = source_count / group = source lineattrs = (pattern = solid) ;
    * series x = adate y = source_count / group = source lineattrs = (thickness = .1 CM) ;
    xaxis grid ; * values = (&earliest to "31dec2010"d by month ) ;
    yaxis grid ;
  run ;


proc sgplot data=modeling.dmef3;
histogram totsale;
run;

/*transformation*/
data dmef3;
	set modeling.dmef3;
	lg_salcls1=log(salcls1+1);
	lg_salcls2=log(salcls2+1);
	lg_salcls3=log(salcls3+1);
	lg_salcls4=log(salcls4+1);
	lg_salcls5=log(salcls5+1);
	lg_salcls6=log(salcls6+1);
	lg_salcls7=log(salcls7+1);
	lg_ordcls1=log(ordcls1+1);
	lg_ordcls2=log(ordcls2+1);
	lg_ordcls3=log(ordcls3+1);
	lg_ordcls4=log(ordcls4+1);
	lg_ordcls5=log(ordcls5+1);
	lg_ordcls6=log(ordcls6+1);
	lg_ordcls7=log(ordcls7+1);
	lg_totord=log(totord+1);
	lg_totsale=log(totsale+1);
	lg_targamnt=log(targamnt+1);
	aoa=totsale/totord;
	lg_aoa=log(aoa+1);
	lg_recmon=log(recmon+1);
	freq=totord/tof;
	lg_freq=log(freq+1);
	lg_tof=log(tof+1);
	if targamnt>0 then response=1;
	if targamnt=<0 then response=0;
	tr=response*train;
run;

proc print data=dmef3(obs=20);
run;

/************************1.Lazy model************************/

proc corr data=dmef3;
var recmon lg_targamnt lg_salcls1 lg_salcls2 lg_salcls3 lg_salcls4 lg_salcls5 lg_salcls6 lg_salcls7 
		  lg_totord lg_totsale lg_aoa ord185 ord285 ord385 ord485
		  lg_ordcls1 lg_ordcls2 lg_ordcls3 lg_ordcls4 lg_ordcls5 lg_ordcls6 lg_ordcls7;
run;
/*check multicollinearity*/
/*proc reg data=modeling.dmef3;
model targamnt=lg_salcls1 lg_salcls2 lg_salcls3 lg_salcls4 lg_salcls5 lg_salcls6 lg_salcls7 
		  lg_totord lg_totsale lg_aoa ord185 ord285 ord385 ord485 recmon
		  lg_ordcls1 lg_ordcls2 lg_ordcls3 lg_ordcls4 lg_ordcls5 lg_ordcls6 lg_ordcls7
		  /vif;
run; */
proc glmselect data=dmef3;
	model targamnt=lg_salcls1 lg_salcls2 lg_salcls3 lg_salcls4 lg_salcls5 lg_salcls6 lg_salcls7 
		  lg_totord lg_totsale ord185 ord285 ord385 ord485 recmon
		  lg_ordcls1 lg_ordcls2 lg_ordcls3 lg_ordcls4 lg_ordcls5 lg_ordcls6 lg_ordcls7
		  /selection=none;
		  partition rolevar=train(train='1');
	output out=pred1 p=yhat;  
run;
/*split dataset*/
%macro split(dataset, test,train);
data &test;
	set &dataset;
	if train=0;
run;

data &train;
	set &dataset;
	if train=1;
run;
%mend;


/*GAINS TABLE*/

%macro gains(y,score,datain,dataout);
title "&datain";
proc rank data=&datain out=&dataout groups=10 descending;
	var &score;
	ranks decile;
run;

proc summary data=&dataout nway;
	class decile;
	var &y;
	output out=gainout(drop=_type_ _freq_) N=N Mean=MEAN SUM=TOTAL;
run;

data gainout;
	set gainout;
	retain cumn cumsum 0;
	decile = decile + 1;
	cumsum = cumsum + total;
	cumn = cumn + n;
	cummean = cumsum/cumn;
	output;
run;

proc print data=gainout noobs;
	var decile n total mean cumn cumsum cummean;
	sum n total;
run;
%mend;


%split(pred1,pred1_test,pred1_train);
%gains(targamnt,yhat,pred1_test, pred2);
%gains(targamnt,yhat,pred1_train, pred2);



/************************2.Multiplicative model************************/
proc glmselect data=dmef3;
	class ord185 ord285 ord385 ord485;
	model lg_targamnt=lg_salcls1 lg_salcls2 lg_salcls3 lg_salcls4 lg_salcls5 lg_salcls6 lg_salcls7 
		  lg_totord lg_totsale
		  lg_recmon
		  lg_ordcls1 lg_ordcls2 lg_ordcls3 lg_ordcls4 lg_ordcls5 lg_ordcls6 lg_ordcls7
		  /selection=none;
		  partition rolevar=train(train='1');
	output out=pred2 p=yhat;  
run;

%split(pred2,pred2_test,pred2_train);
%gains(targamnt,yhat,pred2_test, pred2);
%gains(targamnt,yhat,pred2_train, pred2);

/************************3.Multiplicative model with stepwise************************/
proc glmselect data=dmef3;
	class ord185 ord285 ord385 ord485;
	model lg_targamnt=lg_salcls1 lg_salcls2 lg_salcls3 lg_salcls4 lg_salcls5 lg_salcls6 lg_salcls7 
		  lg_totord lg_totsale lg_recmon lg_tof lg_aoa lg_freq
		  lg_ordcls1 lg_ordcls2 lg_ordcls3 lg_ordcls4 lg_ordcls5 lg_ordcls6 lg_ordcls7
		  /selection=stepwise(sle=.05);
		  partition rolevar=train(train='1');
	output out=pred3 p=yhat;  
run;

%split(pred3,pred3_test,pred3_train);
%gains(targamnt,yhat,pred3_test, pred2);
%gains(targamnt,yhat,pred3_train, pred2);




/************************4.Multiplicative model with ridge************************/
proc standard data=dmef3 mean=0 std=1 out=dmef3_z;
var lg_targamnt lg_salcls1 lg_salcls2 lg_salcls3 lg_salcls4 lg_salcls5 lg_salcls6 lg_salcls7 
		  lg_totord lg_totsale lg_recmon lg_tof lg_aoa lg_freq
		  lg_ordcls1 lg_ordcls2 lg_ordcls3 lg_ordcls4 lg_ordcls5 lg_ordcls6 lg_ordcls7
		  ord185 ord285 ord385 ord485;
run;

proc reg data=dmef3_z ridge=0 to .03 by .0005 outest=ridge;
	model lg_targamnt=lg_salcls1 lg_salcls2 lg_salcls3 lg_salcls4 lg_salcls5 lg_salcls6 lg_salcls7 
		  lg_totord lg_totsale lg_recmon lg_tof lg_aoa lg_freq ord185 ord285 ord385 ord485
		  lg_ordcls1 lg_ordcls2 lg_ordcls3 lg_ordcls4 lg_ordcls5 lg_ordcls6 lg_ordcls7;
	weight train;
	output out=pred4 p=yhat; 
run;

/*result: choose lambda=.01*/

proc reg data=dmef3_z ridge=.01 outest=ridge;
	model lg_targamnt=lg_salcls1 lg_salcls2 lg_salcls3 lg_salcls4 lg_salcls5 lg_salcls6 lg_salcls7 
		  lg_totord lg_totsale lg_recmon lg_tof lg_aoa lg_freq ord185 ord285 ord385 ord485
		  lg_ordcls1 lg_ordcls2 lg_ordcls3 lg_ordcls4 lg_ordcls5 lg_ordcls6 lg_ordcls7;
	weight train;
	output out=pred4 p=yhat residual=zhat; 
run;

proc sql;
select train, count(zhat) as n, sum(zhat**2) as SSE, sum(zhat**2)/count(zhat) as MSE from pred4
group by train;


%split(pred4,pred4_test,pred4_train);
%gains(targamnt,yhat,pred4_test, pred2);
%gains(targamnt,yhat,pred4_train, pred2);


/************************5.Two-step model************************/
proc logistic data=dmef3 descending;
	model response=lg_salcls1 lg_salcls2 lg_salcls3 lg_salcls4 lg_salcls5 lg_salcls6 lg_salcls7 
		  lg_totord lg_totsale lg_recmon lg_tof lg_aoa lg_freq ord185 ord285 ord385 ord485
		  lg_ordcls1 lg_ordcls2 lg_ordcls3 lg_ordcls4 lg_ordcls5 lg_ordcls6 lg_ordcls7;
	weight train;
	output out=pred5_prob p=prob;
	run;

proc glmselect data=dmef3;
	model targamnt=lg_salcls1 lg_salcls2 lg_salcls3 lg_salcls4 lg_salcls5 lg_salcls6 lg_salcls7 
		  lg_totord lg_totsale ord185 ord285 ord385 ord485 recmon
		  lg_ordcls1 lg_ordcls2 lg_ordcls3 lg_ordcls4 lg_ordcls5 lg_ordcls6 lg_ordcls7
		  /selection=none;
		  partition rolevar=train(train='1');
	weight tr;
	output out=pred5_value p=value;
run;

proc sql;
	create table pred5_pv as
	select * from mpred5_value as a
		right join
	pred5_prob as b
		on a.custno=b.custno;
quit;

data pred5;
	set pred5_pv;
	if prob=. then prob=0;
	if value=. then value=0;
	yhat=prob*value;
run;

%split(pred5,pred5_test,pred5_train);
%gains(targamnt,yhat,pred5_test, pred2);
%gains(targamnt,yhat,pred5_train, pred2);

/************************6.Two-step model with stepwise and other variables************************/
proc glmselect data=dmef3;
	model lg_targamnt=lg_salcls1 lg_salcls2 lg_salcls3 lg_salcls4 lg_salcls5 lg_salcls6 lg_salcls7 
		  lg_totord lg_totsale lg_recmon lg_tof lg_aoa lg_freq ord185 ord285 ord385 ord485
		  lg_ordcls1 lg_ordcls2 lg_ordcls3 lg_ordcls4 lg_ordcls5 lg_ordcls6 lg_ordcls7
		  /selection=stepwise(sle=.05);
		  partition rolevar=train(train='1');
	weight tr;
	output out=pred6_value p=value;  
run;

proc sql;
	create table pred6_pv as
	select * from pred6_value as a
		right join
	pred5_prob as b
		on a.custno=b.custno;
quit;

data pred6;
	set pred6_pv;
	if prob=. then prob=0;
	if value=. then value=0;
	yhat=prob*value;
run;

%split(pred6,pred6_test,pred6_train);
%gains(targamnt,yhat,pred6_test, pred2);
%gains(targamnt,yhat,pred6_train, pred2);

