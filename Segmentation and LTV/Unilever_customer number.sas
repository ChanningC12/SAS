libname grocery '/sscc/datasets/imc486/Cahill/grocery';
libname cc '/sscc/home/c/ccn371/Segmentation LTV';

data unilever;
set grocery.lookup;
where index(owner, 'UNILEVER') gt 0;
run;

proc sort data=unilever;
by pod_id;
run;

proc sort data=grocery.ordprod out=ordprod;
by pod_id;
run;

data prod_detail;
merge unilever(in=a) ordprod(in=b);
by pod_id;
if a and b;
item_tot = it_qy*it_pr_qy;
run;

proc sort data=prod_detail out=order_detail;
by ord_id;
run;

data order_level;
set order_detail;
by ord_id;

	retain order_amt;
	
	if first.ord_id then do;
		order_amt = 0;
	end;
	
	if item_tot = . then item_tot = 0;
	
	order_amt = order_amt+item_tot;
	
	if last.ord_id then output;
	
	run;

proc sort data=grocery.order out=ord_date;
by ord_id;
run;

data order_level;
	merge order_level(in=a) ord_date(in=b);
	by ord_id;
	if a and b;
	
	run;
	
proc print data=order_level(obs=30);
run;	

proc sort data=order_level; 
by cnsm_id;
run;

data customer;
	set order_level;
	by cnsm_id;

keep cnsm_id cus_tot;
retain cus_tot;

	if first.cnsm_id then do;
	
	cus_tot = 0;
	end;
	cus_tot=cus_tot+order_amt;
		if last.cnsm_id then do;
	output;
	end;

proc print data=customer(obs=30);
format frstdt ddmmyy9.;
format lastdt ddmmyy9.;
run;

proc means data=customer;
run;

data unilever_demo;
merge customer(in=a) grocery.cust(in=b);
by cnsm_id;
if a ;
run;

proc print data=unilever_demo(obs=30);
run;

proc contents data=unilever_demo;
run;

proc means data=unilever_demo;
run;

proc freq data=unilever_demo;
tables home_own_rent dwelling prkids marital_stat;
run;




