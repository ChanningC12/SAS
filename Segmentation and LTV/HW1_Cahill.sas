libname data '/sscc/datasets/imc498/littlesasbook';

/* analysis of employee dataset*/
/* 71 employees, salary level, age level, experience level in the company
Key Issue: Are their employees being compensated fairly?
*/
proc contents data=data.employee;
run;

proc freq data=data.employee;
tables female trainlev;

proc means data=data.employee;
var annsalry;
class female;
run;

*ageyrs annsalry empnum expyrs female trainlev;
/*do more copy and paste process, SAS is strict on spelling
Maybe women are not being compensate the same?
*/

proc means data=data.employee;
var annsalry;
class female trainlev;
run;
*salary levels are dependent by all the variables, so we need to add more 
variables into considerations;

proc means data=data.employee;
var annsalry;
class female expyrs;
run;

*The average is less interesting, interested in differiations from populations;

/*book order dataset*/

proc contents data=data.order2;
run;

proc print data=data.order2(obs=50);
run;

/*Often time, you have to look into the data files and figure out what they mean;
One variable that we always wanna see: CUSTOMER id, as identifier;
Second variable we always wanna see: DATE;
ordnum: unique order id; Multiple sku in one order;
sku: individual item level;
*/

/*before roll up, create*/
data line_tot;
	set data.order2;
	
	lineamt=price * qty;
	
	run;
/*if we have missing value, it mess up the rolling process*/

proc sort data=line_tot;
	by ordnum;
	run;

	
data order_tot;
	set line_tot;
	by ordnum;

/*create the sort and overwrite it*/

/* every time do roll up, prepare these pieces	
	retain ;
	keep ;
	
	if first.ordernum then do;
	
	end;
	
	if last.ordernum then do;

	end;
*/

/*carry order date with us, ordernum could have two different order date*/
	retain order_tot item_tot orddt_frst;
	keep id order_tot orddt_frst item_tot;
	
	if first.ordnum then do;
	order_tot=0;
	orddt_frst='31DEC2040'd;
/*initialize date with high value, we are looking for loweer dates
missing value of date represents really low value*/
	item_tot=0;
	end;
/*if any lineamt is missing, avoid mess up*/	
	if lineamt= . then lineamt=0;
	if orddate lt orddt_frst then orddt_frst=orddate;
	
	order_tot=order_tot+lineamt;
	item_tot=item_tot+qty;
	if last.ordnum then do;
	output;
	end;
	run;

proc means data=order_tot;
run;

/*146570 orders out of 500000 transactions*/
proc sort data=order_tot out=order_sort;
by id;
run;

data customer;
	set order_sort;
	by id;
	
	retain frstdt lasdt;
	keep id frstdt lasdt tenure;
	
	if first.id then do;
	frstdt='31DEC2040'd;
	lasdt='31DEC1940'd; /* for recency calculation*/
	
	end;
	label frstdt 'Customer First Order Date';
	
	if lasdt lt frst_dt then lasdt = frst_dt;
	if frstdt gt orddt_frst then frstdt =  orddt_frst;

	
	if last.id then do;
	tenure = ('24MAY2005'd - frstdt)/365.25; /*in years*/
	
	output;
	end;
	
	run;

	
	
	
	
	
	
	
	
	
	
	
	
	


