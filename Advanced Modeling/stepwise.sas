proc import datafile="/sscc/home/c/ccn371/Advanced Marketing Models/click.csv" 
 replace out=click dbms=csv;
 run;
 
proc print data=click;
run;

proc reg data=click;
model sales = ad reps fair good outstand / selection=backward;
run;



proc import datafile="/sscc/home/c/ccn371/Advanced Marketing Models/bodyfat.csv" 
 replace out=bodyfat dbms=csv;
 run;

data bodyfat;
set bodyfat;
drop VAR1;
run;
 
proc print data=bodyfat;
run;

/*standardize first*/
proc standard data=bodyfat mean=0 std=1 out=Zbodyfat;
var x1-x3 y;
run;

proc reg data=Zbodyfat ridge=0 to 0.02 by 0.005 outest=ridge; /*ridge regression*/
model y=x1-x3;
run;

proc print data=ridge;
run;

proc sql;
select _RIDGE_ label="c", _RIDGE_*20 as lambda, x1 format=7.4,
x2 format=7.4,x3 format=7.4 from ridge;

/*LASSO*/
proc glmselect data=Zbodyfat;
model y=x1-x3 / selection=lasso;
run;






