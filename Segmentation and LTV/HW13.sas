libname sscc "/sscc/datasets/imc498/littlesasbook";

data hw13;
set sscc.order2;
label
  BrandID="Brand ID"
  orddate="Order Date"
  price="Price"
  CampId="Campus ID"
  id="ID"
  ordnum="Order Number"
  sku="SKU"
  qty="Quantity"
  campnum="Campus Number" 
;

run;
proc print data=hw13(obs=20);
run;
proc means data=hw13 n min max mean maxdec=2;
run;

/*prepare to roll up*/
proc sql;
create table hw131 as
select *, 
qty*price as totamt label="Total Amount",
max(calculated totamt) as maxspend,
min(calculated totamt) as minspend,
max(orddate) as today label="Last record date" format=date9.
from hw13
where BrandId="1"
;
quit;

proc print data=hw131(obs=20);
run;

/*Rolling up at order level*/
proc sql;
create table rollup_order as
select id, ordnum, sum(qty) as totamt_sum label "Total ITems Per Order", 
sum(totamt) as totamt_sum label="Bill Size Per Order",
min(orddate) as orddate_first label="Order Date" format=date9.,
min(today) as today label="Last record date" format=date9.
from hw131
group by id, ordnum
;

quit;

proc print data=rollup_order(obs=20);
run;

proc means data=rollup_order n nmiss mean min max maxdec=2;
run;

/*Rolling up at customer level*/
proc sql;
create table rollup_customer as 
select unique id, count(ordernum) as freq label="frequency",
sum(qty_sum) as itemhist label="Total Item Per Customer",
sum(totamt_sum) as monetary label="Monetary",
(today-min(orddate_first))/365.25 as TOF label="Time on file",
(today-max(orddate_first))/365.25 as recency label="Recency",
calculated itemhist/calculated freq as AOS label="Average order size",
calculated monetary/calculated freq as AOA label="Average Order Amount",
case(calculated freq) 
when 1 then .
else ((calculated TOF)-(calculated recency))/((calculated freq)-1)
end as lambda label="interpurchase time",
case(calculated TOF) 
when 0 then .
else calculated monetary/calculated TOF
end as AmtPerYr label="Amount Spend per year"
from rollup_order
group by id
;
quit;

proc print data=rollup_customer(obs=20);
run;

proc means data=rollup_customer n nmiss mean min max maxdec=2;
run; 












