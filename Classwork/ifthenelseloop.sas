libname sscc"/sscc/datasets/imc498";
data employee;
set sscc.employee;
if trainlev=1 then lowtrain=1;
else lowtrain=0;
if trainlev=2 then medtrain=1;
else medtrain=0;

if ageyrs<40 then agebin=1;
else if ageyrs<60 then agebin=2;
else agebin=3;
run;

proc print data=employee(obs=18);
id empnum;
var trainlev lowtrain medtrain ageyrs agebin;
run;