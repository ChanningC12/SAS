libname hw2a "/sscc/home/e/ehm853/PR Drugstore/DSS";
libname hw2b "/sscc/datasets/imc490b";

*Q1;
PROC SQL;
create table review_one as
select product_id, count(review_comments) as count, l2_status, reviewer_type
from hw2a.reviews
where l2_status = "Approved"
group by product_id
having calculated count eq 1;

DATA review_one;
SET review_one;
where reviewer_type = "Anonymous" or reviewer_type = "Verified";
RUN;

PROC PRINT DATA=review_one(obs=10);
RUN;

PROC CONTENTS DATA=review_one;
RUN;

PROC FREQ data=review_one;
tables reviewer_type;
RUN;


*Q2;


PROC SQL;
create table review_one2 as
select product_id, count(review_comments) as count, review_bottomline, 
review_rating,not_helpful,helpful, countw(review_comments) as wc,
created_date, ('01APR2015'd-datepart(created_date)) as reviewage,
case 
	when helpful = "0" and not_helpful="0" then 1
	else 0
	end as novote,
case 
	when reviewer_type = "Verified" then 1
	when reviewer_type = "Anonymous" then 0
	end as verified
from hw2a.reviews
group by product_id
having calculated count eq 1;


DATA review_one2;
SET review_one2;
if novote=0 then frachelp=helpful/(helpful+not_helpful);
RUN;

PROC PRINT DATA=review_one2(obs=10);
RUN;

PROC CONTENTS DATA=review_one2;
RUN;

PROC FREQ data=review_one2;
tables novote;
RUN;

PROC MEANS data=review_one2 maxdec=2;
RUN;

*Q3;
PROC SQL;
create table review_product as 
select * from review_one2 as a inner join hw2a.products as b
on a.product_id = b.product_id;

DATA review_product;
SET review_product;
keep product_id page_id brand_name category_name
count review_bottomline review_rating not_helpful helpful wc
novote verified reviewage frachelp;
RUN;

PROC PRINT data=review_product(obs=10);
RUN;

PROC CONTENTS data=review_product;
RUN;

PROC FREQ data=review_product;
TABLES review_bottomline;
RUN;

*Q4;
PROC SQL;
create table display_unique as 
select * from hw2a.display
where event_subtype = "reviews-visible";

PROC SUMMARY data=display_unique NWAY;
class uid page_id dt;
var volume valence;
output out=display_unique_one(drop=_type_) N=;
RUN;

PROC PRINT data=display_unique_one(obs=10);
RUN;

PROC CONTENTS data=display_unique_one;
RUN;


*Q5;
PROC SQL;
create table buy as
select * from display_unique_one(rename=(dt=dt_display)) as a 
	inner join
	hw2a.conversion(rename=(dt=dt_convert)) as b
	on a.page_id=b.page_id and a.uid=b.uid
;

DATA buy;
SET buy;
if dt_display=dt_convert then buy=1;
else buy=0;
RUN;

PROC PRINT data=buy(obs=10);
RUN;

PROC CONTENTS data=buy;
RUN;

PROC FREQ data=buy;
tables buy;
RUN;


*Q6;
DATA product_id;
SET hw2a.products;
npage_id=input(page_id, 8.);
keep product_id npage_id;
RUN;

PROC PRINT data=product_id(obs=10);
RUN;

PROC CONTENTS data=product_id;
RUN;


PROC SQL;
create table buy_review_one as
select * from review_product as a inner join buy_product_id as b
	on a.product_id = b.product_id;

PROC PRINT data=buy_review_one(obs=10);
RUN;

PROC PRINT data=buy(obs=10);
RUN;

PROC CONTENTS data=buy_review_one;
RUN;

PROC MEANS data=buy_review_one maxdec=2;
RUN;


PROC SQL;
create table buy_review_one2 as
select * from buy_review_one as a inner join buy as b 
on a.npage_id=b.page_id;

PROC PRINT data=buy_review_one2(obs=10);
RUN;

PROC CONTENTS data=buy_review_one2;
RUN;

PROC MEANS data=buy_review_one2 maxdec=2;
RUN;



DATA assign2_final;
	set buy_review_one2;
	log2wc=log2(wc);
	log2wc2=(log2wc)*(log2wc);
	logprice=log2(wc);
	if frachelp=0 then logithelp=log(.001/.999);
	if frachelp=1 then logithelp=log(.999/.001);
	if frachelp ne 0 or frachelp ne 1 then logithelp=log(frachelp/(1-frachelp));
	if review_bottomline eq missing then review_bottomline="NA";
keep buy logprice reviewage log2wc log2wc2 review_rating verified novote
logithelp frachelp review_bottomline;
RUN;

PROC PRINT data=assign2_final(obs=10);
RUN;

PROC CONTENTS data=assign2_final;
RUN;

PROC MEANS data=assign2_final maxdec=2;
RUN;


*Q7;
PROC CORR data=assign2_final;
var logprice reviewage log2wc log2wc2 review_rating verified novote logithelp;
RUN;

PROC LOGISTIC data=assign2_final descending;
model buy = logprice reviewage log2wc log2wc2 
review_rating verified novote logithelp;
RUN;



*Q8;
PROC LOGISTIC data=assign2_final descending;
model buy = logprice reviewage log2wc log2wc2 
review_rating verified novote frachelp;
RUN;


*Q9;
PROC CORR data=assign2_final;
var logprice reviewage log2wc log2wc2 review_rating verified novote frachelp
review_bottomline;
RUN;

PROC LOGISTIC data=assign2_final descending;
class review_bottomline;
model buy = logprice reviewage log2wc log2wc2 
review_rating verified novote frachelp review_bottomline;
RUN;

















