libname gro '/sscc/datasets/imc486/Cahill/grocery';


/*
General idea:
1.select the variables(demographics, key categories, RFM)
2.Roll up order level, customer level, clean the data
3.Do k means


merge orderprod(in=a) and look
data prod_detail;
merge orderprod(in=a) lookup(in=b);
by pod_id;

if a ;
item_tot=it_qy*it_pr_qy;


then roll up by order:

proc sort data=prod_detail out=order_detail;
by ord_id;
run;

data order_level;
set order_detail;
by ord_id;

retain order_amt baby_orders baby_amt deli_order deli_amt;

if first.ord_id then do;
order_amt=0;
baby_order=0;
baby_amt=0;
deli_order=0;
deli_amt=0;
end;

if item_tot=. then item_tot=0;
order_amt=order_amt+item_tot;
if index(minor_cat, 'BABY') gt 0 then do;
baby_order=1;
baby_tot=baby_tot+item_tot;
end;

if index(minor_cat, 'DELI ') gt 0 then do;  SPACE HERE
deli_order=1;
deli_tot=deli_tot+item_tot;
end;

if last.ord_id then output;
run;

proc sort data=gro.order out=ord_date;
by ord_id;
run;

data order_level;
merge order_level(in=a) ord_data(in=b);
by ord_id;

if a and b;
run;



proc sort data=order_level out=customer_detail;
by cust_id;
run;

data customer;
set order_level;
by cnsm_id;

retain cus_tot deli_tot baby_tot frstdt lastdt;

if first.cnsm_id then do;
frstdt='31DEC2050'd.;
lastdt='31DEC1950'd;
cus_tot=0;
deli_tot=0;
baby_tot=0;

end;
if frstdt gt dlv_dt then frstdt_dt=dlv_dt;
if lastdt lt dlv_dt then lastdt=dlv_dt;

cus_tot=cus_tot+order_amt;

baby_tot=baby_tot+baby_amt;
deli_tot=deli_tot+deli_amt;

if last.cnsm_id then do;
deli_pct=deli_tot/cus_tot;

output;
end;



Date roll up, second most important metric;

proc sort data=gro.order out=ord_date;
by ord_id;
run;

data order_level;
merge order_level(in=a) ord_data(in=b);
by ord_id;

if a and b;
run;



*/
proc sql;
select distinct minor_cat from gro.lookup;
quit;

proc print data=gro.cust(obs=20);
run;

proc freq data=gro.cust;
tables marital_stat;
run;

proc means data=gro.cust;
run;

proc print data=gro.lookup(obs=20);
run;

proc means data=gro.lookup;
run;

proc print data=gro.order(obs=20);
run;

proc means data=gro.order;
run;

proc print data=gro.ordprod(obs=20);
run;

proc means data=gro.ordprod;
run;

proc print data=gro.session(obs=20);
run;

proc means data=gro.session;
run;
