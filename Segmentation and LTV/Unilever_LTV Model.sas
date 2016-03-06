libname grocery '/sscc/datasets/imc486/Cahill/grocery';
libname cc '/sscc/home/c/ccn371/Segmentation LTV';

data unilever;
set grocery.lookup;
if index(owner, 'UNILEVER') gt 0;
run;

proc print data=unilever(obs=10);
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

proc print data=prod_detail(obs=10);
run;


proc sql;
select sum(item_tot) as brand_dol, brnd_desc from prod_detail
group by brnd_desc;
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
select distinct brnd_desc from order_level;
quit;
	
proc sql;
select sum(order_amt) as brand_dol, brnd_desc from order_level
group by brnd_desc;
quit;	

proc sql;
select sum(order_amt) as brand_dol from order_level;
quit;	




data season;
set order_level;
if dlv_dt lt '01AUG2012'd and dlv_dt gt '30JUN2012'd then period=1;
if dlv_dt lt '01SEP2012'd and dlv_dt gt '30JUL2012'd then period=2;
if dlv_dt lt '01OCT2012'd and dlv_dt gt '31AUG2012'd then period=3;
if dlv_dt lt '01NOV2012'd and dlv_dt gt '30SEP2012'd then period=4;
if dlv_dt lt '01DEC2012'd and dlv_dt gt '31OCT2012'd then period=5;
if dlv_dt lt '01JAN2013'd and dlv_dt gt '30NOV2012'd then period=6;
if dlv_dt lt '01FEB2013'd and dlv_dt gt '31DEC2012'd then period=7;
if dlv_dt lt '01MAR2013'd and dlv_dt gt '31JAN2013'd then period=8;
if dlv_dt lt '01APR2013'd and dlv_dt gt '28FEB2013'd then period=9;
if dlv_dt lt '01MAY2013'd and dlv_dt gt '31MAR2013'd then period=10;
if dlv_dt lt '01JUN2013'd and dlv_dt gt '30APR2013'd then period=11;
run;

	
proc print data=season(obs=30);
run;

proc means data=season sum;
class period;
var order_amt;
run;


/*roll up to each month*/
proc sort data=season;
by cnsm_id;
run;

data month1;
set season;
where period=1;
by cnsm_id;

keep cnsm_id period cus_tot1;
retain cus_tot1;

if first.cnsm_id then do;
cus_tot1=0;
end;
cus_tot1=cus_tot1+order_amt;
if last.cnsm_id then do;
output;
end;
run;


data month2;
set season;
where period=2;
by cnsm_id;

keep cnsm_id period cus_tot2;
retain cus_tot2;

if first.cnsm_id then do;
cus_tot2=0;
end;
cus_tot2=cus_tot2+order_amt;
if last.cnsm_id then do;
output;
end;
run;


data month3;
set season;
where period=3;
by cnsm_id;

keep cnsm_id period cus_tot3;
retain cus_tot3;

if first.cnsm_id then do;
cus_tot3=0;
end;
cus_tot3=cus_tot3+order_amt;
if last.cnsm_id then do;
output;
end;
run;


data month4;
set season;
where period=4;
by cnsm_id;

keep cnsm_id period cus_tot4;
retain cus_tot4;

if first.cnsm_id then do;
cus_tot4=0;
end;
cus_tot4=cus_tot4+order_amt;
if last.cnsm_id then do;
output;
end;
run;


data month5;
set season;
where period=5;
by cnsm_id;

keep cnsm_id period cus_tot5;
retain cus_tot5;

if first.cnsm_id then do;
cus_tot5=0;
end;
cus_tot5=cus_tot5+order_amt;
if last.cnsm_id then do;
output;
end;
run;


data month6;
set season;
where period=6;
by cnsm_id;

keep cnsm_id period cus_tot6;
retain cus_tot6;

if first.cnsm_id then do;
cus_tot6=0;
end;
cus_tot6=cus_tot6+order_amt;
if last.cnsm_id then do;
output;
end;
run;


data month7;
set season;
where period=7;
by cnsm_id;

keep cnsm_id period cus_tot7;
retain cus_tot7;

if first.cnsm_id then do;
cus_tot7=0;
end;
cus_tot7=cus_tot7+order_amt;
if last.cnsm_id then do;
output;
end;
run;


data month8;
set season;
where period=8;
by cnsm_id;

keep cnsm_id period cus_tot8;
retain cus_tot8;

if first.cnsm_id then do;
cus_tot8=0;
end;
cus_tot8=cus_tot8+order_amt;
if last.cnsm_id then do;
output;
end;
run;


data month9;
set season;
where period=9;
by cnsm_id;

keep cnsm_id period cus_tot9;
retain cus_tot9;

if first.cnsm_id then do;
cus_tot9=0;
end;
cus_tot9=cus_tot9+order_amt;
if last.cnsm_id then do;
output;
end;
run;


data month10;
set season;
where period=10;
by cnsm_id;

keep cnsm_id period cus_tot10;
retain cus_tot10;

if first.cnsm_id then do;
cus_tot10=0;
end;
cus_tot10=cus_tot10+order_amt;
if last.cnsm_id then do;
output;
end;
run;


data month11;
set season;
where period=11;
by cnsm_id;

keep cnsm_id period cus_tot11;
retain cus_tot11;

if first.cnsm_id then do;
cus_tot11=0;
end;
cus_tot11=cus_tot11+order_amt;
if last.cnsm_id then do;
output;
end;
run;



data month15;
merge month1 month2 month3 month4 month5;
by cnsm_id;
drop period;
if cus_tot1=. then cus_tot1=0;
if cus_tot2=. then cus_tot2=0;
if cus_tot3=. then cus_tot3=0;
if cus_tot4=. then cus_tot4=0;
if cus_tot5=. then cus_tot5=0;
if cus_tot5 ne 0;
if cus_tot1+cus_tot2+cus_tot3+cus_tot4 ne 0;
run;

proc print data=month15(obs=30);
run;

data month15_prob;
set month15;
if cus_tot4 ne 0 then R0=1;
else R0=0;

if cus_tot3 ne 0 and cus_tot4=0 then R1=1;
else R1=0;

if cus_tot2 ne 0 and cus_tot3=0 and cus_tot4=0 then R2=1;
else R2=0;

if cus_tot1 ne 0 and cus_tot2=0 and cus_tot3=0 and cus_tot4=0 then R3=1;
else R3=0;

run;

proc print data=month15_prob(obs=30);
run;

proc freq data=month15_prob;
tables R0 R1 R2 R3;
run;


data month26;
merge month2 month3 month4 month5 month6;
by cnsm_id;
drop period;
if cus_tot2=. then cus_tot2=0;
if cus_tot3=. then cus_tot3=0;
if cus_tot4=. then cus_tot4=0;
if cus_tot5=. then cus_tot5=0;
if cus_tot6=. then cus_tot6=0;
if cus_tot6 ne 0;
if cus_tot2+cus_tot3+cus_tot4+cus_tot5 ne 0;
run;

proc print data=month26(obs=30);
run;

data month26_prob;
set month26;
if cus_tot5 ne 0 then R0=1;
else R0=0;

if cus_tot4 ne 0 and cus_tot5=0 then R1=1;
else R1=0;

if cus_tot3 ne 0 and cus_tot4=0 and cus_tot5=0 then R2=1;
else R2=0;

if cus_tot2 ne 0 and cus_tot3=0 and cus_tot4=0 and cus_tot5=0 then R3=1;
else R3=0;

run;

proc print data=month26_prob(obs=30);
run;

proc freq data=month26_prob;
tables R0 R1 R2 R3;
run;


data month37;
merge month3 month4 month5 month6 month7;
by cnsm_id;
drop period;
if cus_tot3=. then cus_tot3=0;
if cus_tot4=. then cus_tot4=0;
if cus_tot5=. then cus_tot5=0;
if cus_tot6=. then cus_tot6=0;
if cus_tot7=. then cus_tot7=0;
if cus_tot7 ne 0;
if cus_tot3+cus_tot4+cus_tot5+cus_tot6 ne 0;
run;

proc print data=month37(obs=30);
run;

data month37_prob;
set month37;
if cus_tot6 ne 0 then R0=1;
else R0=0;

if cus_tot5 ne 0 and cus_tot6=0 then R1=1;
else R1=0;

if cus_tot4 ne 0 and cus_tot5=0 and cus_tot6=0 then R2=1;
else R2=0;

if cus_tot3 ne 0 and cus_tot4=0 and cus_tot5=0 and cus_tot6=0 then R3=1;
else R3=0;

run;

proc print data=month37_prob(obs=30);
run;

proc freq data=month37_prob;
tables R0 R1 R2 R3;
run;




data month48;
merge month4 month5 month6 month7 month8;
by cnsm_id;
drop period;
if cus_tot4=. then cus_tot4=0;
if cus_tot5=. then cus_tot5=0;
if cus_tot6=. then cus_tot6=0;
if cus_tot7=. then cus_tot7=0;
if cus_tot8=. then cus_tot8=0;
if cus_tot8 ne 0;
if cus_tot4+cus_tot5+cus_tot6+cus_tot7 ne 0;
run;

proc print data=month48(obs=30);
run;

data month48_prob;
set month48;
if cus_tot7 ne 0 then R0=1;
else R0=0;

if cus_tot6 ne 0 and cus_tot7=0 then R1=1;
else R1=0;

if cus_tot5 ne 0 and cus_tot6=0 and cus_tot7=0 then R2=1;
else R2=0;

if cus_tot4 ne 0 and cus_tot5=0 and cus_tot6=0 and cus_tot7=0 then R3=1;
else R3=0;

run;

proc print data=month48_prob(obs=30);
run;

proc freq data=month48_prob;
tables R0 R1 R2 R3;
run;




data month59;
merge month5 month6 month7 month8 month9;
by cnsm_id;
drop period;
if cus_tot5=. then cus_tot5=0;
if cus_tot6=. then cus_tot6=0;
if cus_tot7=. then cus_tot7=0;
if cus_tot8=. then cus_tot8=0;
if cus_tot9=. then cus_tot9=0;
if cus_tot9 ne 0;
if cus_tot5+cus_tot6+cus_tot7+cus_tot8 ne 0;
run;

proc print data=month59(obs=30);
run;

data month59_prob;
set month59;
if cus_tot8 ne 0 then R0=1;
else R0=0;

if cus_tot7 ne 0 and cus_tot8=0 then R1=1;
else R1=0;

if cus_tot6 ne 0 and cus_tot7=0 and cus_tot8=0 then R2=1;
else R2=0;

if cus_tot5 ne 0 and cus_tot6=0 and cus_tot7=0 and cus_tot8=0 then R3=1;
else R3=0;

run;

proc print data=month59_prob(obs=30);
run;

proc freq data=month59_prob;
tables R0 R1 R2 R3;
run;





data month610;
merge month6 month7 month8 month9 month10;
by cnsm_id;
drop period;
if cus_tot6=. then cus_tot6=0;
if cus_tot7=. then cus_tot7=0;
if cus_tot8=. then cus_tot8=0;
if cus_tot9=. then cus_tot9=0;
if cus_tot10=. then cus_tot10=0;
if cus_tot10 ne 0;
if cus_tot6+cus_tot7+cus_tot8+cus_tot9 ne 0;
run;

proc print data=month610(obs=30);
run;

data month610_prob;
set month610;
if cus_tot9 ne 0 then R0=1;
else R0=0;

if cus_tot8 ne 0 and cus_tot9=0 then R1=1;
else R1=0;

if cus_tot7 ne 0 and cus_tot8=0 and cus_tot9=0 then R2=1;
else R2=0;

if cus_tot6 ne 0 and cus_tot7=0 and cus_tot8=0 and cus_tot9=0 then R3=1;
else R3=0;

run;

proc print data=month610_prob(obs=30);
run;

proc freq data=month610_prob;
tables R0 R1 R2 R3;
run;





data month711;
merge month7 month8 month9 month10 month11;
by cnsm_id;
drop period;
if cus_tot7=. then cus_tot7=0;
if cus_tot8=. then cus_tot8=0;
if cus_tot9=. then cus_tot9=0;
if cus_tot10=. then cus_tot10=0;
if cus_tot11=. then cus_tot11=0;
if cus_tot11 ne 0;
if cus_tot7+cus_tot8+cus_tot9+cus_tot10 ne 0;
run;

proc print data=month711(obs=30);
run;

data month711_prob;
set month711;
if cus_tot10 ne 0 then R0=1;
else R0=0;

if cus_tot9 ne 0 and cus_tot10=0 then R1=1;
else R1=0;

if cus_tot8 ne 0 and cus_tot9=0 and cus_tot10=0 then R2=1;
else R2=0;

if cus_tot7 ne 0 and cus_tot8=0 and cus_tot9=0 and cus_tot10=0 then R3=1;
else R3=0;

run;

proc print data=month711_prob(obs=30);
run;

proc freq data=month711_prob;
tables R0 R1 R2 R3;
run;




data allmonth;
merge month1 month2 month3 month4 month5 month6 month7
month8 month9 month10 month11;
by cnsm_id;
run;

proc print data=allmonth(obs=30);
run;

proc means data=allmonth;
var cus_tot1 cus_tot2 cus_tot3 cus_tot4 cus_tot5 cus_tot6
cus_tot7 cus_tot8 cus_tot9 cus_tot10 cus_tot11;
run;


data allmonth2;
set allmonth;
drop period;
if cus_tot1=. then cus_tot1=0;
if cus_tot2=. then cus_tot2=0;
if cus_tot3=. then cus_tot3=0;
if cus_tot4=. then cus_tot4=0;
if cus_tot5=. then cus_tot5=0;
if cus_tot6=. then cus_tot6=0;
if cus_tot7=. then cus_tot7=0;
if cus_tot8=. then cus_tot8=0;
if cus_tot9=. then cus_tot9=0;
if cus_tot10=. then cus_tot10=0;
if cus_tot11=. then cus_tot11=0;
if cus_tot11 ne 0;
if cus_tot1+cus_tot2+cus_tot3+cus_tot4+cus_tot5+cus_tot6+cus_tot7+cus_tot8+cus_tot9+cus_tot10+cus_tot11 ne 0;
run;

proc print data=allmonth2(obs=30);
run;

proc means data=allmonth2;
run;

data allmonth_prob;
set allmonth2;
if cus_tot10 ne 0 then R0=1;
else R0=0;

if cus_tot9 ne 0 and cus_tot10=0 then R1=1;
else R1=0;

if cus_tot8 ne 0 and cus_tot9=0 and cus_tot10=0 then R2=1;
else R2=0;

if cus_tot8=0 and cus_tot9=0 and cus_tot10=0 then R3=1;
else R3=0;

run;

proc print data=allmonth_prob(obs=30);
run;

proc freq data=allmonth_prob;
tables R0 R1 R2 R3;
run;


data month911;
merge month9 month10 month11;
by cnsm_id;
if cus_tot9 = . then cus_tot9=0;
if cus_tot10 = . then cus_tot10=0;
if cus_tot11 = . then cus_tot11=0;
tot_amt=cus_tot9+cus_tot10+cus_tot11;
run;

proc print data=month911(obs=30);
run;

proc means data=month911 n sum mean;
var tot_amt;
run;







