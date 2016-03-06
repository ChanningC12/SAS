libname modeling "/sscc/home/c/ccn371/Advanced Marketing Models";
libname pr "/sscc/home/e/ehm853/PR_Drugstore/DSS";

/*define buy*/
PROC SQL;
create table modeling.display_unique as 
select * from modeling.display
where event_subtype = "reviews-visible";

PROC SUMMARY data=modeling.display_unique NWAY; /*roll up volume and valence by uid, page_id and dt*/
class uid page_id dt;
var volume valence;
output out=modeling.display_unique_one(drop=_type_) N=;
RUN;

PROC PRINT data=modeling.display_unique_one(obs=10);
RUN;

PROC SQL;
create table modeling.buy as
select * from modeling.display_unique_one(rename=(dt=dt_display)) as a 
	inner join
	modeling.conversion(rename=(dt=dt_convert)) as b
	on a.page_id=b.page_id and a.uid=b.uid
;

DATA modeling.buy;
SET modeling.buy;
if dt_display=dt_convert then buy=1; /*if display date equals convert date, meaning the reviews had influence on purchase behavior right away*/
else buy=0;
RUN;

proc print data=modeling.buy(obs=20);
run;



data modeling.product (drop=page_id);
	set pr.products;
	npage_id = INPUT(page_id, 8.);
	rename npage_id=page_id;
run;

data modeling.conversion;
	set pr.conversion;
run;

data modeling.review;
	set pr.reviews;
run;

data modeling.display;
	set pr.display;
run;

proc means data=modeling.product n nmiss; /*nmiss counts missing values*/
run;

data modeling.qualify_review;
	set modeling.review;
	if l2_status="Approved";
	if reviewer_type="Verified" or reviewer_type="Anonymous";
run;

data modeling.new_review;
	set modeling.qualify_review;
	if helpful gt 0 or not_helpful gt 0 then novote=0;
	if helpful=0 and not_helpful=0 then novote=1;	
	wc=COUNTW(review_comments);
	if reviewer_type="Verified" then verified=1;
	else verified=0;
	reviewage='01APR2015'd-created_date;
/*adjust frachelp here*/
	frachelp=(helpful-not_helpful)/(helpful+not_helpful);
	if frachelp=. then frachelp=0;
	if frachelp=. then frachelp=0.5;
	keep product_id review_bottomline review_rating not_helpful 
		 helpful novote wc verified reviewage frachelp;
run;


proc sort data=modeling.new_review;
	by product_id;
run;

data modeling.one_review;
	set modeling.new_review;
	by product_id;
	review_c=0;
	retain review_c;
	if first.product_id then review_c=1;
	review_c=review_c+1;
	if last.product_id;
	if review_c ne 1 then delete;
	lg_wc=log2(wc+1);
	lg_wc2=log2(wc+1)*log2(wc+1);
	tot_vote=helpful+not_helpful;
run;

proc means data=modeling.one_review n nmiss mean;
run;

proc sql;
	create table modeling.one_review1 as
		select a.helpful, a.not_helpful, a.review_bottomline, a.review_rating, 
		a.product_id, a.novote, a.wc, a.verified, a.reviewage, a.frachelp,
		a.review_c, a.lg_wc, a.lg_wc2, b.page_id, b.product_id
		from modeling.one_review as a
			left join
		modeling.product as b 
			on a.product_id=b.product_id;
quit;


data modeling.one_review2;
set modeling.one_review1;
keep review_rating product_id verified frachelp tot_vote lg_wc lg_wc2 wc;
run;


proc means data=modeling.one_review2 n nmiss mean;
run;

data modeling.assign3_2a;
	set modeling.product;
	sub_category=scan(category_name_complete,4,':');
	if sub_category="styling products" then sub_category="styling_products";
	run;
	

proc sql;
create table modeling.conversion_prodid as 
select a.product_id,a.page_id, b.* from modeling.product as a full join modeling.conversion as b
on a.page_id=b.page_id;
quit;

proc sql;
create table modeling.product_conversion as 
select * from modeling.one_review2 as a right join modeling.conversion_prodid as b
on a.product_id=b.product_id;
quit;

data modeling.product_conversion;
set modeling.product_conversion;
if product_id=. then delete;
run;

proc print data=modeling.product_conversion(obs=10);
proc means data=modeling.product_conversion mean n nmiss;
run;


proc sql;
create table modeling.avg_median as 
select a.sub_category, a.product_id, b.* from modeling.assign3_2a as a right join modeling.product_conversion as b
on a.product_id=b.product_id;
quit;

proc sql; 
create table modeling.avg_median2 as
select sub_category, count(sub_category) as ncount, mean(unit_price) as avg_price, mean(wc) as avg_wc, median(unit_price) as median_price, median(wc) as median_wc
from modeling.avg_median
group by sub_category
order by ncount desc;
quit;

proc print data=modeling.avg_median2(obs=20);
run;

data modeling.highinvolve;
set modeling.avg_median2;
if avg_price gt median_price and avg_wc gt median_wc then high_involve=1;
else high_involve=0;
popular=_n_;
run;

proc print data=modeling.highinvolve(obs=20);
run;

proc sql;
create table modeling.final_prep as 
select a.*,b.* from modeling.highinvolve as a righ join modeling.avg_median as b
on a.sub_category=b.sub_category
where high_involve=1;
quit;

proc sql;
create table modeling.final_prep2 as
select distinct * from modeling.final_prep;


proc means data=modeling.final_prep2 n nmiss mean;
run;

proc sql;
create table modeling.final_prep3 as
select a.buy, b.* from modeling.buy as a inner join modeling.final_prep2 as b
on a.uid=b.uid and a.page_id=b.page_id;


proc print data=modeling.final_prep3(obs=50);
run;


data modeling.final_model ;
	set modeling.final_prep3;
	if sub_category = "moisturizers"
	or sub_category = "salon hair care"
	or sub_category = "power toothbrushes"
	or sub_category = "weight loss supplements"
	or sub_category = "hair, skin & nails"
	or sub_category = "hair removal"
	or sub_category = "skin care tools"
	or sub_category = "protein"
	or sub_category = "teeth whitening"
	or sub_category = "dha";
run;

proc print data=modeling.final_model(obs=20);
run;

proc corr data=modeling.final_model;
var frachelp verified review_rating lg_wc lg_wc2 unit_price;
run;

proc logistic data=modeling.final_model descending;
class sub_category; /*categorical variable in logistic model*/
model buy=frachelp verified review_rating lg_wc lg_wc2 unit_price;
run;
































