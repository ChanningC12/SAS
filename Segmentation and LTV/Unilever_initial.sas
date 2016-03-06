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

	retain order_amt dairy_order dairy_amt 
fro_order fro_amt bev_order bev_amt 
groc_order groc_amt hb_order hb_amt;
	
	if first.ord_id then do;
		order_amt = 0;
		dairy_order=0;
		dairy_amt=0;
		fro_order=0;
		fro_amt=0;
		bev_order=0;
		bev_amt=0;
		groc_order=0;
		groc_amt=0;
		hb_order=0;
		hb_amt=0;
		
	end;
	
	if item_tot = . then item_tot = 0;
	
	order_amt = order_amt+item_tot;
	
	if index(minor_cat,'DAIRY ') gt 0 then do;
		dairy_order = 1;
		dairy_amt = dairy_amt+item_tot;
	end;

	if index(minor_cat,'FROZEN ') gt 0 then do;
		fro_order = 1;
		fro_amt = fro_amt+item_tot;
	end;

	if index(minor_cat,'BEVERAGES') gt 0 then do;
		bev_order = 1;
		bev_amt = bev_amt+item_tot;
	end;

	if index(minor_cat,'GROC ') gt 0 then do;
		groc_order = 1;
		groc_amt = groc_amt+item_tot;
	end;

	if index(minor_cat,'HB ') gt 0 then do;
		hb_order = 1;
		hb_amt = hb_amt+item_tot;
	end;

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
	
proc means data=order_level;
run;

proc freq data=order_level;
tables owner;
run;

proc sort data=order_level;
by cnsm_id;
run;

data customer;
set order_level;
by cnsm_id;

	keep cnsm_id cus_tot dairy_tot fro_tot bev_tot
frstdt lastdt tenure recency times groc_tot hb_tot;

	retain cus_tot dairy_tot fro_tot bev_tot frstdt lastdt 
tenure recency times groc_tot hb_tot;

	if first.cnsm_id then do;
	frstdt = '31DEC2050'd;
	lastdt = '31DEC1905'd;
	
	cus_tot = 0;
	dairy_tot=0;
	fro_tot=0;
	bev_tot=0;
	groc_tot=0;
	hb_tot=0;
	times=0;
	end;
	
	if frstdt gt dlv_dt then frstdt = dlv_dt;
	if lastdt lt dlv_dt then lastdt = dlv_dt;
	cus_tot = cus_tot+order_amt;
	
	dairy_tot = dairy_tot+dairy_amt;
	fro_tot = fro_tot+fro_amt;
	bev_tot = bev_tot+bev_amt;
	groc_tot=groc_tot+groc_amt;
	hb_tot=hb_tot+hb_amt;
	times=times+1;
	
	if last.cnsm_id then do;
	
	tenure=('25JUN2013'd-frstdt)/365.25;
	recency=('25JUN2013'd-lastdt)/365.25;	
	output;
	end;
run;

proc print data=customer(obs=100);
format frstdt ddmmyy9.;
format lastdt ddmmyy9.;
run;

proc means data=customer;
run;

data cc.unilever_customer;
set customer(keep=cnsm_id cus_tot dairy_tot 
fro_tot bev_tot groc_tot hb_tot times tenure recency);
run;












