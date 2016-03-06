libname imc "/sscc/datasets/imc498/littlesasbook";

proc contents data=imc.order2;
run;

proc print data=imc.order2(obs=50);
run;

data line_tot;
set imc.order2;
lineamt=price * qty;
where BrandID='1';
run;

proc print data=line_tot(obs=50);
run;

proc sort data=line_tot;
by ordnum;
run;

data order_tot;
set line_tot;
by ordnum;

retain order_tot item_tot orddt_first;

keep id ordnum BrandID order_tot item_tot orddt_first;


if first.ordnum then do;
order_tot=0;
item_tot=0;
orddt_first="31DEC2040"d;

if lineamt=. then lineamt=0;

if orddate lt orddt_first then orddt_first=orddate;
order_tot=order_tot+lineamt;
item_tot=item_tot+qty;

end;
if last.ordnum then do;
output;
end;
run;

proc print data=order_tot(obs=50);
format orddt_first date9.;
run;

proc means data=order_tot;
run;


proc sort data=order_tot out=order_sort;
by id;
run;

data customer;
set order_sort;
by id;

retain firstdt lastdt freq itemhist monetary;

keep id firstdt lastdt tenure recency freq itemhist monetary 
AOS AOA lambda AmtPerYr;

if first.id then do;
firstdt='31DEC2040'd;
lastdt='31DEC1940'd;
freq=0;
itemhist=0;
monetary=0;
end;

if firstdt gt orddt_first then firstdt=orddt_first;
if lastdt lt orddt_first then lastdt=orddt_first;
freq=freq+BrandID;
itemhist=itemhist+item_tot;
monetary=monetary+order_tot;

if last.id then do;
tenure=('24MAY2005'd-firstdt)/365.25;
recency=('24MAY2005'd-lastdt)/365.25;
AOS=itemhist/freq;
AOA=monetary/freq;
lambda=(tenure-recency)/(freq-1);
AmtPerYr=monetary/tenure;
output;
end;
run;


proc print data=customer(obs=50);
run;

proc means data=customer;
run;






















