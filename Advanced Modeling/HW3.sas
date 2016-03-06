libname hw2a "/sscc/home/e/ehm853/PR_Drugstore/DSS";
libname hw2b "/sscc/home/c/ccn371/Advanced Marketing Models";

/*problem 1*/
/*get category name, brand name, etc.*/
proc sql;
create table assign3_1a as
select * from hw2b.assign2_final as a 
	left join hw2a.products as b
	on a.product_id=b.product_id;
	
proc print data=assign3_1a(obs=10);
run;

proc contents data=assign3_1a;
run;

/*select the top categories, ignore sexual well being categories*/
proc freq data=assign3_1a order=freq;
tables category_name_complete;
run;

/*NewVar=SCAN(string,n<,delimiters>); 
-returns the nth ‘word’ in the string*/
data assign3_1b;
set assign3_1a;
sub_category=scan(category_name_complete,4,':');
if sub_category="styling products" then sub_category="styling_products";
run;

proc freq data=assign3_1b order=freq;
tables sub_category;
run;

proc sql;
select distinct brand_name from assign3_1b
	where sub_category="toners";
	
/*chose the top 10 sub_category*/
/*moisturizer*/
%let cats=moisturizers;

data assign3_1_&cats;
set assign3_1b;
if sub_category="&cats";
run;

proc freq data=assign3_1_&cats order=freq;
tables brand_name;
run;

proc corr data=assign3_1_&cats;
var logprice log2wc log2wc2 review_rating verified novote frachelp;
run;

proc logistic data=assign3_1_&cats descending;
class verified novote;
model buy=logprice log2wc log2wc2 review_rating verified novote frachelp;
run;


/*lotions*/
%let cats=lotions;

data assign3_1_&cats;
set assign3_1b;
if sub_category="&cats";
run;

proc freq data=assign3_1_&cats order=freq;
tables brand_name;
run;

proc corr data=assign3_1_&cats;
var logprice log2wc log2wc2 review_rating verified novote frachelp;
run;

proc logistic data=assign3_1_&cats descending;
class verified novote;
model buy=logprice log2wc log2wc2 review_rating verified novote frachelp;
run;


/*face*/
%let cats=face;

data assign3_1_&cats;
set assign3_1b;
if sub_category="&cats";
run;

proc freq data=assign3_1_&cats order=freq;
tables brand_name;
run;

proc corr data=assign3_1_&cats;
var logprice log2wc log2wc2 review_rating verified novote frachelp;
run;

proc logistic data=assign3_1_&cats descending;
class verified novote;
model buy=logprice log2wc log2wc2 review_rating verified novote frachelp;
run;


/*eyes*/
%let cats=eyes;

data assign3_1_&cats;
set assign3_1b;
if sub_category="&cats";
run;

proc freq data=assign3_1_&cats order=freq;
tables brand_name;
run;

proc corr data=assign3_1_&cats;
var logprice log2wc log2wc2 review_rating verified novote frachelp;
run;

proc logistic data=assign3_1_&cats descending;
class verified novote;
model buy=logprice log2wc log2wc2 review_rating verified novote frachelp;
run;


/*shampoos*/
%let cats=shampoos;

data assign3_1_&cats;
set assign3_1b;
if sub_category="&cats";
run;

proc freq data=assign3_1_&cats order=freq;
tables brand_name;
run;

proc corr data=assign3_1_&cats;
var logprice log2wc log2wc2 review_rating verified novote frachelp;
run;

proc logistic data=assign3_1_&cats descending;
class verified novote;
model buy=logprice log2wc log2wc2 review_rating verified novote frachelp;
run;


/*cleansers*/
%let cats=cleansers;

data assign3_1_&cats;
set assign3_1b;
if sub_category="&cats";
run;

proc freq data=assign3_1_&cats order=freq;
tables brand_name;
run;

proc corr data=assign3_1_&cats;
var logprice log2wc log2wc2 review_rating verified novote frachelp;
run;

proc logistic data=assign3_1_&cats descending;
class verified novote;
model buy=logprice log2wc log2wc2 review_rating verified novote frachelp;
run;


/*shaving*/
%let cats=shaving;

data assign3_1_&cats;
set assign3_1b;
if sub_category="&cats";
run;

proc freq data=assign3_1_&cats order=freq;
tables brand_name;
run;

proc corr data=assign3_1_&cats;
var logprice log2wc log2wc2 review_rating verified novote frachelp;
run;

proc logistic data=assign3_1_&cats descending;
class verified novote;
model buy=logprice log2wc log2wc2 review_rating verified novote frachelp;
run;


/*conditioners*/
%let cats=conditioners;

data assign3_1_&cats;
set assign3_1b;
if sub_category="&cats";
run;

proc freq data=assign3_1_&cats order=freq;
tables brand_name;
run;

proc corr data=assign3_1_&cats;
var logprice log2wc log2wc2 review_rating verified novote frachelp;
run;

proc logistic data=assign3_1_&cats descending;
class verified novote;
model buy=logprice log2wc log2wc2 review_rating verified novote frachelp;
run;


/*lips*/
%let cats=lips;

data assign3_1_&cats;
set assign3_1b;
if sub_category="&cats";
run;

proc freq data=assign3_1_&cats order=freq;
tables brand_name;
run;

proc corr data=assign3_1_&cats;
var logprice log2wc log2wc2 review_rating verified novote frachelp;
run;

proc logistic data=assign3_1_&cats descending;
class verified novote;
model buy=logprice log2wc log2wc2 review_rating verified novote frachelp;
run;


/*toothpaste*/
%let cats=toothpaste;

data assign3_1_&cats;
set assign3_1b;
if sub_category="&cats";
run;

proc freq data=assign3_1_&cats order=freq;
tables brand_name;
run;

proc corr data=assign3_1_&cats;
var logprice log2wc log2wc2 review_rating verified novote frachelp;
run;

proc logistic data=assign3_1_&cats descending;
class verified novote;
model buy=logprice log2wc log2wc2 review_rating verified novote frachelp;
run;


/*styling_products*/
%let cats=styling_products;

data assign3_1_&cats;
set assign3_1b;
if sub_category="&cats";
run;

proc freq data=assign3_1_&cats order=freq;
tables brand_name;
run;

proc corr data=assign3_1_&cats;
var logprice log2wc log2wc2 review_rating verified novote frachelp;
run;

proc logistic data=assign3_1_&cats descending;
class verified novote;
model buy=logprice log2wc log2wc2 review_rating verified novote frachelp;
run;


/*interaction among toothpaste+shving+styling+eyes*/
data assign3_1b_interact;
set assign3_1b;
if sub_category="toothpaste" or
	sub_category="eyes" or
	sub_category="shaving" or
	sub_category="styling_products";
run;

proc corr data=assign3_1b_interact;
var logprice log2wc log2wc2 review_rating verified novote frachelp;
run;

proc logistic data=assign3_1b_interact descending;
class verified novote sub_category;
model buy=logprice log2wc log2wc2 review_rating verified novote frachelp
	sub_category sub_category*logprice sub_category*review_rating
	sub_category*verified;
run;


/*problem 2*/
data product(drop=page_id);
set hw2a.products;
npage_id=input(page_id,8.);
rename npage_id=page_id;
run;

data assign3_2a;
set product;
sub_category=scan(category_name_complete,4,":");
if sub_category="styling products" then sub_category="styling_products";
run;

proc freq data=assign3_2a order=freq;
tables sub_category;
run;

/*toothpaste*/
%let cats=toothpaste;

data assign3_2_&cats;
set assign3_2a;
if sub_category="&cats";
run;

/*eyes*/
%let cats=eyes;

data assign3_2_&cats;
set assign3_2a;
if sub_category="&cats";
run;

/*shaving*/
%let cats=shaving;

data assign3_2_&cats;
set assign3_2a;
if sub_category="&cats";
run;

/*styling_products*/
%let cats=styling_products;

data assign3_2_&cats;
set assign3_2a;
if sub_category="&cats";
run;


proc sql;
create table assign3_2aa as
	select * from hw2a.display as a
	full join
	hw2a.conversion as b
	on a.uid=b.uid;

proc print data=assign3_2aa(obs=10);
run;

proc contents data=assign3_2aa;
run;

data assign3_2aaa;
set assign3_2aa;
if volume=1 then volume_level="1";
else if volume>1 and volume<5 then volume_level="2";
else if volume>=5 then volume_level="3";
run;

proc print data=assign3_2aaa(obs=20);
run;

proc means data=assign3_2aaa maxdec=2;
run;

















	
