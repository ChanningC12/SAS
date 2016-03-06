data product_cat;
infile "/sscc/datasets/imc498/finalexam/product_category.csv" firstobs=2 dsd dlm="," missover;
informat prod_num $6. prod_cat $12.;
input prod_num $ prod_cat $;
run;

proc print data=product_cat(obs=20);
run;

data invoice;
infile "/sscc/datasets/imc498/finalexam/invoice.csv" firstobs=2 dsd dlm="," missover;
informat cust_id $10.;
informat inv_dt mmddyy10.;
informat inv_num best4.;
informat line_num best2.;
informat prod_num $6.;
informat unit_prc best2.2;
informat order_qty best3.;
informat unit_cost best2.2;

format inv_dt mmddyy10.;

input 
cust_id $
inv_dt 
inv_num 
line_num 
prod_num $ 
unit_prc
order_qty 
unit_cost
;
revenue=unit_prc*order_qty;
run;

proc print data=invoice(obs=20);
run;

proc means data=invoice;
run;

proc sort data=invoice out=invoice1;
by inv_num;
run;

data invoice_rollupinvnum;
set invoice1;
year=year(INV_DT);
lineorder=UNIT_PRC*ORDER_QTY;
by inv_num;
retain ordersize;
if first.inv_num then do;
ordersize=0;
end;
ordersize+lineorder;
if last.inv_num;
run;

proc print data=invoice_rollupinvnum(obs=20);
run;

proc means data=invoice_rollupinvnum sum mean;
var ordersize;
class year;
run;

proc sort data=invoice out=invoice2;
by cust_id;
run;

proc print data=invoice2(obs=20);
run;

data invoice_rollupsales;
set invoice2;
by cust_id;
retain Y1 Y2 Y3;
if first.cust_id then do;
Y1=0;
Y2=0;
Y3=0;
end;
year=year(inv_dt);
if year=2009 then Y1=Y1+revenue;
else if year=2010 then Y2=Y2+revenue;
else if year=2011 then Y3=Y3+revenue;
if last.cust_id;
keep cust_id Y1 Y2 Y3;
run;

proc print data=invoice_rollupsales(obs=20);
run;

proc means data=invoice_rollupsales sum mean;
var Y1 Y2 Y3;
run;
 
data invoice_rolluporder;
set invoice2;
by cust_id;
retain O1 O2 O3;
if first.cust_id then do;
O1=0;
O2=0;
O3=0;
end;
year=year(inv_dt);
if year=2009 then O1=O1+order_qty;
else if year=2010 then O2=O2+order_qty;
else if year=2011 then O3=O3+order_qty;
if last.cust_id;
keep cust_id O1 O2 O3;
run;

proc print data=invoice_rolluporder(obs=20);
run;

proc means data=invoice_rolluporder sum mean;
var O1 O2 O3;
run;

data salesorder;
merge invoice_rollupsales invoice_rolluporder;
by cust_id;
run;

proc print data=salesorder(obs=20);
run;

data active09;
set invoice_rollupsales;
where Y1 > 0;
keep cust_id Y1;
run;

proc print data=active09(obs=20);
run;

data active10;
set invoice_rollupsales;
where Y2 > 0;
keep cust_id Y2;
run;

proc print data=active10(obs=20);
run;
data active11;
set invoice_rollupsales;
where Y3 > 0;
keep cust_id Y3;
run;

proc print data=active11(obs=20);
run;

proc means data=active09 n sum mean;
var Y1;
run;

proc means data=active10 n sum mean;
var Y2;
run;

proc means data=active11 n sum mean;
var Y3;
run;

data newcustomer;
set salesorder;
if Y1 ne 0 then startyear=2009;
if Y1 = 0 and Y2 ne 0 then startyear=2010;
if Y1 = 0 and Y2 = 0 and Y3 ne 0 then startyear=2011;
run;

proc print data=newcustomer(obs=20);
run;

proc means data=newcustomer n sum mean;
class startyear;
run;

proc freq data=product_cat;
tables prod_cat;
run;

proc sql;
select distinct prod_cat from product_cat;
quit;

proc sort data=product_cat out=product_cat2;
by prod_num;
run;

proc sort data=invoice out=invoice3;
by prod_num;
run;

data invoice_cat;
merge product_cat2 invoice3;
by prod_num;
year=year(inv_dt);
run;

proc print data=invoice_cat(obs=20);
run;

proc means data=invoice_cat sum mean;
class year prod_cat;
var revenue;
run;
