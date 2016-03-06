libname grocery '/sscc/datasets/imc486/Cahill/grocery';
libname cc '/sscc/home/c/ccn371/Segmentation LTV';

/* CHECK PRODUCT CATEGORY VALUES */
proc sql;
	select distinct minor_cat from grocery.lookup;
	quit;
	
/* CHECK BRAND  VALUES */
	
proc sort data=grocery.lookup(keep=pod_id minor_cat) out=lookup; by pod_id; 
run;

proc contents data=grocery.ordprod; run;
proc contents data=grocery.lookup; run;

/*Merge ordprod and lookup*/
proc sort data=grocery.ordprod out=orderprod; by pod_id;
run;

data prod_detail;
	merge orderprod(in=a) lookup(in=b);
	by pod_id;
if a ;

item_tot = it_qy*it_pr_qy;

run;


/*Roll up tp order level*/
proc sort data=prod_detail out = order_detail; 
by ord_id; 
run;

data order_level;
	set order_detail;
	by ord_id;
	
	retain order_amt baby_order baby_amt deli_order deli_amt dairy_order dairy_amt
fro_order fro_amt snack_order snack_amt 
bev_order bev_amt alc_order alc_amt fre_order fre_amt prod_order prod_amt
groc_order groc_amt hb_order hb_amt hg_order hg_amt hh_order hh_amt;
	
	if first.ord_id then do;
		order_amt = 0;
		baby_order = 0;
		baby_amt = 0;
		deli_order = 0;
		deli_amt= 0;
		dairy_order=0;
		dairy_amt=0;
		fro_order=0;
		fro_amt=0;
		snack_order=0;
		snack_amt=0;
		bev_order=0;
		bev_amt=0;
		alc_order=0;
		alc_amt=0;
		fre_order=0;
		fre_amt=0;
		prod_order=0;
		prod_amt=0;
		groc_order=0;
		groc_amt=0;
		hb_order=0;
		hb_amt=0;
		hg_order=0;
		hg_amt=0;
		hh_order=0;
		hh_amt=0;
		
	end;
	
	if item_tot = . then item_tot = 0;
	
	order_amt = order_amt+item_tot;
		
	if index(minor_cat,'BABY') gt 0 then do;
		baby_order = 1;
		baby_amt = baby_amt+item_tot;
	end;
	
	if index(minor_cat,'DELI ') gt 0 then do;
		deli_order = 1;
		deli_amt = deli_amt+item_tot;
	end;
	
	if index(minor_cat,'DAIRY ') gt 0 then do;
		dairy_order = 1;
		dairy_amt = dairy_amt+item_tot;
	end;

	if index(minor_cat,'FROZEN ') gt 0 then do;
		fro_order = 1;
		fro_amt = fro_amt+item_tot;
	end;

	if index(minor_cat,'SNACKS') gt 0 then do;
		snack_order = 1;
		snack_amt = snack_amt+item_tot;
	end;

	if index(minor_cat,'BEVERAGES') gt 0 then do;
		bev_order = 1;
		bev_amt = bev_amt+item_tot;
	end;

	if index(minor_cat,'ALCOHOL') gt 0 then do;
		alc_order = 1;
		alc_amt = alc_amt+item_tot;
	end;
	
	if index(minor_cat,'FRESH') gt 0 then do;
		fre_order = 1;
		fre_amt = fre_amt+item_tot;
	end;
	
	if index(minor_cat,'PRODUCE') gt 0 then do;
		prod_order = 1;
		prod_amt = prod_amt+item_tot;
	end;

	if index(minor_cat,'GROC ') gt 0 then do;
		groc_order = 1;
		groc_amt = groc_amt+item_tot;
	end;

	if index(minor_cat,'HB ') gt 0 then do;
		hb_order = 1;
		hb_amt = hb_amt+item_tot;
	end;

	if index(minor_cat,'HG ') gt 0 then do;
		hg_order = 1;
		hg_amt = hg_amt+item_tot;
	end;

	if index(minor_cat,'HH ') gt 0 then do;
		hh_order = 1;
		hh_amt = hh_amt+item_tot;
	end;

	if last.ord_id then output;
	
	run;

/*Merge order_level with ord_date to get ord_seq_num and date*/
proc sort data=grocery.order out=ord_date;
by ord_id;
where ord_seq_num ne .;
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

/*Roll up to customer level*/
proc sort data=order_level; 
by cnsm_id;
run;

data customer;
	set order_level;
	by cnsm_id;
/*"times" means frequency*/	
	keep cnsm_id cus_tot baby_tot deli_tot dairy_tot fro_tot snack_tot bev_tot alc_tot
fre_tot prod_tot frstdt lastdt tenure recency times
groc_tot hb_tot hg_tot hh_tot;

	retain cus_tot baby_tot deli_tot dairy_tot fro_tot snack_tot bev_tot alc_tot
fre_tot prod_tot frstdt lastdt tenure recency times
groc_tot hb_tot hg_tot hh_tot;
	
	if first.cnsm_id then do;
	frstdt = '31DEC2050'd;
	lastdt = '31DEC1905'd;
	
	cus_tot = 0;
	baby_tot = 0;
	deli_tot = 0;
	dairy_tot=0;
	fro_tot=0;
	snack_tot=0;
	bev_tot=0;
	alc_tot=0;
	fre_tot=0;
	prod_tot=0;
	groc_tot=0;
	hb_tot=0;
	hg_tot=0;
	hh_tot=0;
	times=0;
	end;
	
	if frstdt gt dlv_dt then frstdt = dlv_dt;
	if lastdt lt dlv_dt then lastdt = dlv_dt;
	cus_tot = cus_tot+order_amt;
	
	baby_tot = baby_tot+baby_amt;
	deli_tot=deli_tot+deli_amt;
	dairy_tot = dairy_tot+dairy_amt;
	fro_tot = fro_tot+fro_amt;
	snack_tot = snack_tot+snack_amt;
	bev_tot = bev_tot+bev_amt;
	alc_tot=alc_tot+alc_amt;
	fre_tot=fre_tot+fre_amt;
	prod_tot=prod_tot+prod_amt;
	groc_tot=groc_tot+groc_amt;
	hb_tot=hb_tot+hb_amt;
	hg_tot=hg_tot+hg_amt;
	hh_tot=hh_tot+hh_amt;
	times=max(ord_seq_num);
	
	if last.cnsm_id then do;
	
	deli_pct = deli_tot/cus_tot;
	tenure=('25JUN2013'd-frstdt)/365.25;
	recency=('25JUN2013'd-lastdt)/365.25;	
	output;
	end;


proc print data=customer(obs=30);
format frstdt ddmmyy9.;
format lastdt ddmmyy9.;
run;

proc means data=customer;
run;

/*
customer: cnsm_id, cus_tot, baby_tot, deli_tot, tenure, recency
cust:hhincome, educ
*/

data cc.customer1;
set customer(keep=cnsm_id cus_tot baby_tot deli_tot dairy_tot 
fro_tot snack_tot bev_tot alc_tot fre_tot prod_tot 
groc_tot hb_tot hg_tot hh_tot times tenure recency);
run;

proc print data=cc.customer1(obs=30);
run;

proc contents data=grocery.cust;
run;

proc print data=grocery.cust(obs=30);
run;



	
