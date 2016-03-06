data compound;
amount=50000;
rate=0.045;
yearly=amount*rate;
quarterly+((quarterly+amount)*rate/4);
quarterly+((quarterly+amount)*rate/4);
quarterly+((quarterly+amount)*rate/4);
quarterly+((quarterly+amount)*rate/4);
run;

proc print data=compound noobs;
run;

data invest;
do year=1 to 30 until(capital>270000);
capital+5000;
capital+(capital*0.045);
end;
run;
proc print data=invest noobs;
format capital dollar14.2;
run;

data invest;
do year=1 to 30 while(capital<270000);
capital+5000;
capital+(capital*0.045);
end;
run;
proc print data=invest noobs;
format capital dollar14.2;
run;

data investment(drop=quarter);
do year=1 to 5;
capital+5000;
do quarter=1 to 4;
capital+(capital*(0.045/4));
end;
output;
end;
run;

proc print data=investment noobs;
run;

libname orion "/sscc/datasets/imc498";
data charity;
set orion.employee_donations;
keep employee_id qtr1-qtr4;
qtr1=qtr1*1.25;
qtr2=qtr2*1.25;
qtr3=qtr3*1.25;
qtr4=qtr4*1.25;
run;

proc print data=charity noobs;
run;

data charity2;
set orion.employee_donations;
keep employee_id qtr1-qtr4;
array contrib{4} qtr1-qtr4;
do i=1 to 4;
contrib{i}=contrib{i}*1.25;
end;
run;

proc print data=charity2;
run;

data charity3;
set orion.employee_donations;
keep employee_id qtr1-qtr4;
array contrib{*} qtr: ;
do i=1 to dim(contrib);
contrib{i}=contrib{i}*1.25;
end;
run;

proc print data=charity3;
run;

data test;
set orion.employee_donations;
array val{4} qtr1-qtr4;
tot1=sum(of qtr1-qtr4);
tot2=sum(of val{*});
run;

proc print data=test;
var employee_id tot1 tot2;
run;


d
