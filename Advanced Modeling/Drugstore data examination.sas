libname hw2a "/sscc/home/e/ehm853/PR Drugstore/DSS";
libname hw2b "/sscc/home/c/ccn371/Advanced Marketing Models";

proc freq data=hw2a.reviews order=freq; /*frequent table*/
tables source review_rating l2_status;
run;

proc freq data=hw2a.products order=freq;
tables sub_brand_name category_name category_code category_name_complete;
run;

proc sql;
create table tot_review as
select product_id, count(product_id) as review_c from hw2a.reviews
group by product_id;

proc print data=tot_review(obs=100);
run;

proc sql outobs=100;
select product_id,review_count from hw2a.products
order by product_id;

proc freq data=hw2a.display order=freq;
tables event_subtype;
run;