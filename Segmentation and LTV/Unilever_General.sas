libname grocery '/sscc/datasets/imc486/Cahill/grocery';
libname cc '/sscc/home/c/ccn371/Segmentation LTV';

data unilever;
set grocery.lookup;
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


proc sql;
select sum(item_tot) as brand_dol, brnd_desc from prod_detail
group by owner;
quit;	

proc sql;
select sum(item_tot) as brand_dol from prod_detail;
quit;	



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

proc sql;
select sum(order_amt) as brand_dol from order_level
group by owner;
quit;	
