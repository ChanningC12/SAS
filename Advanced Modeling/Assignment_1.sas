libname modeling "/sscc/home/d/dyo754/Desktop/Data/Modeling";

/*FILE IMPORT*/
proc import datafile="/sscc/home/d/dyo754/Desktop/Data/Modeling/product.csv"  
 run;
 
proc import datafile="/sscc/home/d/dyo754/Desktop/Data/Modeling/review.csv" 
 replace out=modeling.review dbms=csv;
 run;

proc import datafile="/sscc/home/d/dyo754/Desktop/Data/Modeling/conversion.csv" 
 replace out=modeling.conversion dbms=csv;
 run;
 
proc import datafile="/sscc/home/d/dyo754/Desktop/Data/Modeling/display.csv" 
 replace out=modeling.display dbms=csv;
 run;

/*COMMENT THE DATASETS*/
 data modeling.product;
 set modeling.product;
 label product_base_url="home page";     /*label the variable is a good coding habit*/
 label gender="gender of target group";
 label review_count="number of reviews";
 label l2_review_count="level 2 number of reviews";
  run; 
 
 data modeling.review;
 set modeling.review;
 label source="web or email";
 label reviewer_type="verified/anonymous";
  run;

*learn to use rename statement;
 data modeling.conversion;
 set modeling.conversion(rename=(ordered_page_id=page_id)); /*rename the variable*/
 label uid="user id";
  run;

 data modeling.display;
 set modeling.display;
 label uid="user id";
 label review_count="# of views when exposed";
 label star_rating="star rating when exposed";
  run;


/*SORT THE DATASETS*/
proc sort data=modeling.product;
 by page_id;
proc sort data=modeling.review;
 by product_id;
proc sort data=modeling.conversion;
 by page_id;
proc sort data=modeling.display;
 by page_id;
run;


/*Problem 3*/
proc sql;
create table modeling.one_review as
select * from modeling.product
where review_count=1;

proc sql;
create table modeling.comparison as
select * from
modeling.one_review as a inner join modeling.review as b
on a.product_id=b.product_id;

proc means data=modeling.comparison mean median;
var review_rating;
class reviewer_type;
run;

proc univariate data=modeling.comparison plot;
var review_rating;
class reviewer_type;
run;