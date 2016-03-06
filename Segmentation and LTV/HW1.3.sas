libname hwdata '/sscc/datasets/imc498/littlesasbook';

data order2;
set hwdata.order2;
where BrandID='1';
totamt=price*qty;
run;

proc print data=order2(obs=50);
run;

proc means data=order2;
run;

proc sql;
create table ordersql as
select id, count(BrandID) as freq, 
sum(totamt) as monetary, sum(qty) as itemhist from order2
group by id;
quit;

data order3;
set order2;
by id;
retain TOF monetary itemhist freq recency;
if first.id then do;
TOF=0;
monetary=0;
itemhist=0;
freq=0;
recency=9999;
end;
TOF=max(TOF,("24MAY2005"d - orddate)/365.25);
monetary=monetary+totamt;
itemhist=itemhist+qty;
freq=freq+BrandID;
recency=min(TOF,("24MAY2005"d - orddate)/365.25);
if last.id;
AOS=itemhist/freq;
AOA=monetary/freq;
lambda=(TOF-recency)/(freq-1);
AmtPerYr=monetary/TOF;
run;

proc print data=order3(obs=50);
title "customer level";
run;

proc print data=ordersql(obs=50);
title "SQL";
run;

proc means data=order3;
run;


proc sort data=order2 out=order5;
by ordnum;
run; 

data order4;
set order5;
by ordnum;
retain orderamt orderqty;
if first.ordnum then do;
orderamt=0;
orderqty=0;
end;
orderamt=orderamt+totamt;
orderqty=orderqty+qty;
if last.ordnum;
run;

proc print data=order4(obs=50);
title "order level";
run;

proc means data=order4 n mean min max;
run;


