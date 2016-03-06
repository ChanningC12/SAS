libname trans "/sscc/datasets/imc498/airmiles/";

data rfm;
set trans.trans;
by id;
length rec freq freqA freqD totdols 4;
retain rec freq freqA freqD totdols;
if first.id then do;
rec=.;
freq=0;
freqA=0;
freqD=0;
totdols=0;
end;

freq=freq+1;
if codetype = "A" then freqA=freqA+1;
if codetype = "D" then freqD=freqA+1;
totdols = totdols + dollars;
if rec=. or rec lt date then rec=date;
if last.id;
keep id rec freq freqA freqD totdols;
run;

proc print data=rfm(obs=20);
run;
