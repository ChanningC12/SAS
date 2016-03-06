libname modeling "/sscc/home/c/ccn371/Advanced Marketing Models";
libname pr "/sscc/home/e/ehm853/PR_Drugstore/DSS";

data modeling.product (drop=page_id);
	set pr.products;
	npage_id = INPUT(page_id, 8.); /*change the data type*/
	rename npage_id=page_id;
run;

data modeling.product_subcategory;
	set modeling.product;
	sub_category=scan(category_name_complete,4,':'); /*find the fourth value split by ":" */
	if sub_category="styling products" then sub_category="styling_products";
	run;

proc sql;
create table modeling.sales as 
select a.*,b.* from modeling.product_subcategory as a 
	right join
	modeling.conversion as b
	on a.page_id=b.page_id
	;

proc contents data=modeling.sales;
run;

data modeling.sales_category;
set modeling.sales;
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

proc contents data=modeling.sales_category;
run;

proc sql;
select sub_category,sum(unit_price) as category_revenue from modeling.sales_category
group by sub_category
order by category_revenue desc;
quit;

data modeling.qualify_review;
	set modeling.review;
	if l2_status="Approved";
	if reviewer_type="Verified" or reviewer_type="Anonymous";
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
run;

proc sql;
create table modeling.sales_categoryone as 
select a.*, b.* from modeling.sales_category as a
	left join modeling.one_review as b
	on a.product_id=b.product_id;

data modeling.sales_categoryone2;
set modeling.sales_categoryone;
if review_c=. then delete;
run;

proc means data=modeling.sales_categoryone2 n mean nmiss;
run;

proc sql;
select sub_category,sum(unit_price) as category_revenue from modeling.sales_categoryone2
group by sub_category
order by category_revenue desc;
quit;







