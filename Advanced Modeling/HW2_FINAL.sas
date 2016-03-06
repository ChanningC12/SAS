libname hw2a "/sscc/home/e/ehm853/PR Drugstore/DSS";
libname hw2b "/sscc/home/c/ccn371/Advanced Marketing Models";

/*preparing data, change the data type of page_id in products*/
data product (drop=page_id);
set hw2a.products;
npage_id=input(page_id,8.);
rename npage_id=page_id;
run;

data conversion;
set hw2a.conversion;
run;

data review;
set hw2a.reviews;
run;

data display;
set hw2a.display;
run;

/*reason for missing a lot of created_date*/
proc means data=review;
where product_id=1190285;
run;

/*problem 1*/
data qualify_review;
set review;
if l2_status="Approved";
if reviewer_type="Verified" or reviewer_type="Anonymous";
run;

proc print data=qualify_review(obs=10);
run;

/*problem 2*/
data new_review;
set qualify_review;
if helpful gt 0 or not_helpful gt 0 then novote=0;
if helpful eq 0 and not_helpful eq 0 then novote=1;
wc=countw(review_comments);
if reviewer_type="Verified" then verified=1;
else if reviewer_type ne "Verified" then verified=0;
reviewage=created_date-'01APR2015'd;
if novote=0 then frachelp=helpful/(helpful+not_helpful);
keep product_id review_bottomline review_rating not_helpful helpful
novote wc verified reviewage frachelp created_date;
run;

proc print data=new_review(obs=10);
run;

proc contents data=new_review;
run;

proc sort data=new_review;
by product_id;
run;

/*count the reviews on product_id level, keep the product_id that has only one review*/
data one_review;
set new_review;
by product_id;
review_c=0;
retain review_c;
if first.product_id then review_c=1;
review_c=review_c+1;
if last.product_id;
if review_c ne 1 then delete;
run;

/*problem 3*/
/*merge the product information with reviews, only keep one review product_id*/
proc sql;
create table prod_review as 
select * from hw2a.products as a 
	inner join 
	one_review as b
	on a.product_id=b.product_id;

/*keep only the relevant variables*/	
data prod_review;
set prod_review;
keep product_id model_id name brand_name category_name reviewage;
run;

proc print data=prod_review(obs=10);
run;

proc contents data=prod_review;
run;

proc means data=prod_review;
run;


/*problem 4*/
data display_unique;
set hw2a.display;
if event_subtype="reviews-visible";
run;

/*use proc summary to roll up, unique uid+page_id+dt combination*/
proc summary data=display_unique NWAY;
class uid page_id dt;
var volume valence;
output out=display_unique_sum(drop=_type_) N=;
run;

proc print data=display_unique_sum(obs=10);
run;


/*problem 5*/
/*to determine the effect of display, on the same day, if it was converted*/
proc sql;
create table d_c_buy as 
select * from display_unique_sum as a
	inner join hw2a.conversion as b
	on a.uid=b.uid and a.page_id=b.page_id and a.dt=b.dt;
	
data d_c_buy;
set d_c_buy;
buy=1;

proc print data=d_c_buy(obs=10);
run;

proc contents data=d_c_buy;
run;

/*merge back*/
proc sql;
create table disp_conv as
select * from display_unique_sum as a
	full join d_c_buy as b
	on a.uid=b.uid and a.page_id=b.page_id and a.dt=b.dt;

data disp_conv;
set disp_conv;
if buy ne 1 then buy=0;
run;

proc print data=disp_conv(obs=20);
run;

proc contents data=disp_conv;
run;

/*problem 6*/
proc sql;
create table disp_conv_prodid as 
select * from disp_conv as a
	left join product as b
	on a.page_id = b.page_id;
	
data dual_id;
set disp_conv_prodid;
keep page_id product_id;
run;

proc summary data=dual_id NWAY;
class page_id product_id;
var page_id product_id;
output out=dualid(drop=_type_) N=;
run;

proc contents data=one_review;
proc contents data=dualid;
run;

proc print data=dualid(obs=10);
run;

proc sql;
create table one_review_pageid as
select * from one_review as a
left join dualid as b
on a.product_id=b.product_id;
*data types are different;

proc print data=one_review_pageid(obs=30);
proc contents data=one_review_pageid;
run;

proc sql;
create table dc_one_review as 
select * from disp_conv as a
inner join one_review_pageid as b
on a.page_id=b.page_id;

proc print data=dc_one_review(obs=10);
run;

proc contents data=dc_one_review;
run;

/*in most cases novote=1 therefore frachelp=missing, and so logithelp=missing*/

/*fill in unit_price missing values according to the average product price*/
proc sql;
create table assign2_tmp_price as 
select mean(unit_price) as avg_price, uid, page_id,dt, volume, valence,unit_price,
	buy,helpful,not_helpful,review_bottomline,review_rating,product_id,novote,wc,
	verified,reviewage,frachelp
	from dc_one_review
group by product_id;

/*need to use else if to avoid overwriting the logithelp variable
  logprice calculation is changed from log2(unit_price) 
  to log2(avg_price) based on previous code*/
data hw2b.assign2_final(keep=product_id buy logprice reviewage log2wc log2wc2 
	review_rating verified novote logithelp wc frachelp review_bottomline);
set assign2_tmp_price;
log2wc=log2(wc);
log2wc2=(log2wc)**2;
logprice=log2(avg_price);
if frachelp=0 then logithelp=log(1/999);
else if frachelp=1 then logithelp=log(999);
else if frachelp ne 0 or frachelp ne 1 then logithelp=log(frachelp/(1-frachelp));
if logithelp=. then logithelp=0;
if frachelp=. then frachelp=0.5;
if review_bottomline=' ' then review_bottomline="NA";
run;

proc print data=hw2b.assign2_final(obs=10);
run;

proc contents data=hw2b.assign2_final;
run;

proc means data=hw2b.assign2_final;
run;

/*problem 7*/
proc corr data=hw2b.assign2_final;
var logprice reviewage log2wc log2wc2 review_rating verified novote logithelp;
run;

proc logistic data=hw2b.assign2_final descending;
class verified novote;
model buy=logprice reviewage log2wc log2wc2 review_rating logithelp;
run;

/*problem 8*/
proc logistic data=hw2b.assign2_final descending;
class verified novote;
model buy=logprice reviewage log2wc log2wc2 review_rating frachelp;
run;

/*problem 9*/
proc logistic data=hw2b.assign2_final descending;
class review_bottomline verified novote;
model buy=logprice reviewage log2wc log2wc2 review_rating frachelp;
run;


proc corr data=hw2b.assign2_final;
var logprice reviewage log2wc log2wc2 review_rating verified novote frachelp;
run;





















