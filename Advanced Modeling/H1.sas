*libname statement;
libname pr "/sscc/datasets/imc490b";
libname amm "/sscc/home/c/ccn371/Advanced Marketing Models";

*Question 1;
*import 4 csv datasets and label names for variables;
proc import datafile="/sscc/datasets/imc490b/conversion.csv"
dbms=csv replace out=conversion1;
label 
	ordered_page_id="id for product/webpage"
	uid="vistor id";
run;

proc import datafile="/sscc/datasets/imc490b/display.csv"
dbms=csv replace out=display1;
label
	event_subtype="web action"
	page_id="id for product/webpage"
	uid="vistor id"
	star_rating="avg stars for page"
	review_count="num reviews";	
run;

proc import datafile="/sscc/datasets/imc490b/product.csv"
dbms=csv replace out=product1;
label 
	product_id="id for product"
	page_id="id for product/webpage"
	review_count="num reviews";	
run;

proc import datafile="/sscc/datasets/imc490b/review.csv"
dbms=csv replace out=review1;
label 
	review_id="id for review"
	product_id="id for product";
run;


*sort;
proc sort data=conversion1;
by ordered_page_id;
run;

proc sort data=display1;
by page_id;
run;

proc sort data=product1;
by page_id;
run;

proc sort data=review1;
by product_id;
run;


*print data and check the description;
proc print data=conversion1(obs=20);
title "Coversion";
run;

proc print data=display1(obs=20);
title "Display";
run;

proc print data=product1(obs=20);
title "Product";
run;

proc print data=review1(obs=20);
title "Review";
run;

proc contents data=conversion1;
run;

proc contents data=display1;
run;

proc contents data=product1;
run;

proc contents data=review1;
run;

*save data sets as permanent;
data amm.conversion;
set conversion1;
run;

data amm.display;
set display1;
run;

data amm.product;
set product1;
run;

data amm.review;
set review1;
run;


*Question2;
proc contents data=pr.conversion position;
run;

proc contents data=pr.display position;
run;

proc contents data=pr.productA position;
run;

proc contents data=pr.reviewA position;
run;

*means;
proc means data=pr.conversion maxdec=2;
run;

proc means data=pr.display maxdec=2;
run;

proc means data=pr.productA maxdec=2;
run;

proc means data=pr.reivewA maxdec=2;
run;

*print;
proc print data=pr.conversion(obs=10);
run;

proc print data=pr.display(obs=10);
run;

proc print data=pr.productA(obs=10);
run;

proc print data=pr.reivewA(obs=10);
run;

*frequency distribution;
proc freq data=pr.display order=freq;
tables event_subtype;
run;


*Question 3;
proc freq data=review1 order=freq;
tables reviewer_type;
run;

proc means data=review1 maxdec=2;
var review_rating review_length;
class reviewer_type;
run;

proc sql;
create table review_one as
select * from amm.product 
where review_count eq 1;

proc sql;
create table combination as 
select * from review_one as a inner join amm.review as b
on a.product_id = b.product_id;

proc sql;
select count(review_id) as num_review, avg(review_rating) as rating,
sum(helpful)/count(helpful) as fraction,
reviewer_type,review_length,product_id
from combination
where l2_status="Approved"
group by product_id;










