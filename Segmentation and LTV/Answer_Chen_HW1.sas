/*Read in CPK*/

DATA cpk;
  INFILE "/sscc/datasets/imc498/littlesasbook/cpk.dat";
  INPUT
   STOREID 1-5
   Q1 6
   Q2 7
   Q3 8
   Q4 9-10
   Q5 11
   Q6a 12
   Q6b 13
   Q6c 14
   Q6d 15
   Q6e 16
   Q6f 17
   Q7a 18
   Q7b 19
   Q7c 20
   Q7d 21
   Q8a 22
   Q8b 23
   Q8c 24
   Q8d 25
   Q9 26
   Q10a 27
   Q10b 28
   Q11 29
   Q12 30
   Q13A 31-32
   Q13B 33-34
   Q13C 35-36
   Q14A 37-38
   Q14B 39-40
   Q14C 41-42
   Q15 43-44
   GENDER 45
;
  LABEL
   STOREID="STORE-ID"
   Q1="Overall experience at CPK"
   Q2="Overall value at CPK"
   Q3="Lunch/dinner"
   Q4="Main menu item ordered"
   Q5="Ordered before"
   Q6a="Taste of food"
   Q6b="Freshness of food"
   Q6c="Portion Size"
   Q6d="Temp appropriateness"
   Q6e="Value for money"
   Q6f="Q6A: reorder item?"
   Q7a="Speed/attentiveness of waiter"
   Q7b="attitude of server"
   Q7c="server knowledge/helpful"
   Q7d="overall service from staff"
   Q8a="attractive decor"
   Q8b="clean"
   Q8c="comfortable"
   Q8d="overall atmosphere"
   Q9="area to improve"
   Q10a="two most important aspects"
   Q10b="two most important aspects"
   Q11="visit again?"
   Q12="number times at cpk"
   Q13A="# cpk 30 day dine-in"
   Q13B="# cpk 30 day take-out"
   Q13C="# cpk 30 day delivery"
   Q14A="# other 30 day dine-in"
   Q14B="# other 30 day take-out"
   Q14C="# other 30 day delivery"
   Q15="number in party"
   GENDER="GENDER"
;
PROC FORMAT;
  VALUE cpkfmtsone
  5 = "Excellent"
  4 = "Very Good"
  3 = "Good"
  2 = "Fair"
  1 = "Poor"
  ;
RUN;
PROC FORMAT;
  VALUE cpkfmtstwo
  1 = "Lunch"
  2 = "Dinner"
  ;
RUN;
PROC FORMAT;
  VALUE cpkfmtsthree
  1 = "Yes"
  2 = "No"
  ;
RUN;
PROC FORMAT;
  VALUE cpkfmtsfour
  1 = "Decor"
  2 = "Taste of food"
  3 = "Service"
  4 = "New Items"
  5 = "Value"
  6 = "Other"
  ;
RUN;
PROC FORMAT;
  VALUE cpkfmtsfive
  1 = "Innovate"
  2 = "Friendly"
  3 = "Convenience"
  4 = "Exciting"
  5 = "Price"
  ;
RUN;
PROC FORMAT;
  VALUE cpkfmtssix
  0 = "no"
  1 = "yes"
  ;
RUN;
PROC FORMAT;
  VALUE cpkfmtsseven
  1 = "First visit"
  2 = "2-4 times"
  3 = "5-10 times"
  4 = "11-20 times"
  5 = "20+ times"
  ;
RUN;
PROC FORMAT;
  VALUE cpkfmtseight
  1 = "Male"
  2 = "Female"
  ;
RUN;
PROC CONTENTS DATA=cpk;
RUN;
PROC PRINT DATA=cpk(OBS=10) NOOBS;
  FORMAT Q1 Q2 Q6A Q6B Q6C Q6D Q6E Q7A Q7B Q7C Q7D Q8A Q8B Q8C Q8D cpkfmtsone.
     	Q3 cpkfmtstwo.
     	Q5 Q11 Q6F cpkfmtsthree.
     	Q9 cpkfmtsfour.
     	Q10A Q10B cpkfmtsfive.
     	Q12 cpkfmtsseven.
     	GENDER cpkfmtseight.
;
RUN;
PROC MEANS DATA=cpk N NMISS MEAN MIN MAX MAXDEC=2;
  VAR Q1 Q2 Q5 Q11 Q6A Q6B Q6C Q6D Q6E Q7A Q7B Q7C Q7D Q8A Q8B Q8C Q8D
  	Q12 Q13A Q13B Q13C Q14A Q14B Q14C;
RUN;
PROC UNIVARIATE DATA=cpk PLOT;
  VAR Q1 Q2;
RUN;

/*Read in employee*/

DATA employee;
  INFILE "/sscc/datasets/imc498/littlesasbook/employee.csv" DSD FIRSTOBS=2 TERMSTR=CR;
  INPUT empnum
    	annsalry
    	gender
    	ageyrs
    	expyrs
    	trainlev
 	;
   LABEL
 	empnum="employee number"
 	annsalry="annual salary in dollars"
 	gender="1 for female"
 	ageyrs="age in years"
 	expyrs="experience in years"
 	trainlev="training level"
 	;
RUN;
PROC CONTENTS DATA=employee;
RUN;
PROC PRINT DATA=employee (OBS = 10);
RUN;
PROC MEANS DATA=employee N MEAN MIN MAX MAXDEC=2;
RUN;

/*Read in german book orders*/

LIBNAME chris "/sscc/datasets/imc498/littlesasbook";
DATA trans;
  SET chris.order2;
  LABEL
  BrandID="Brand ID"
  orddate="Order Date"
  price="Price"
  CampId="Campus ID"
  id="ID"
  ordnum="Order Number"
  sku="SKU"
  qty="Quantity"
  campnum="Campus Number" 
  ;
 
RUN;
PROC CONTENTS DATA=trans;
RUN;
PROC PRINT DATA=trans (OBS=10);
RUN;
PROC MEANS DATA=trans N NMISS MEAN MIN MAX MAXDEC=2;
RUN;




/*Prepare to roll up*/

PROC SQL;
  CREATE TABLE newtrans AS
	SELECT *,
       	qty*price AS totamt LABEL="Total Amount",
       	MAX(CALCULATED totamt) AS maxspend,
       	MIN(CALCULATED totamt) AS minspend,
       	MAX(orddate) AS today LABEL="Last record date" FORMAT=DATE9.
	FROM trans
	WHERE BrandId = "1"
	;
QUIT;
PROC PRINT DATA=newtrans (OBS=10);
RUN;

/*Rolling up at order level*/

PROC SQL;
  CREATE TABLE rollup_order AS
	SELECT id, ordnum, SUM(qty) AS qty_sum LABEL="Total Items Per Order",
       	SUM(totamt) AS totamt_sum LABEL="Bill Size Per Order",
       	MIN(orddate) AS orddate_first LABEL="Order Date" FORMAT=DATE9.,
       	MIN(today) AS today LABEL="Last record date" FORMAT=DATE9.
	FROM newtrans
	GROUP BY id, ordnum
	;
QUIT;
PROC PRINT DATA=rollup_order (OBS=10);
RUN;
PROC CONTENTS DATA=rollup_order;
RUN;
PROC MEANS DATA=rollup_order N NMISS MEAN MIN MAX MAXDEC=2;
RUN;

/*Rolling up at customer level*/

PROC SQL;
  CREATE TABLE rollup_id AS
	SELECT UNIQUE id, COUNT(ordnum) AS freq LABEL="Frequency",
       	SUM(qty_sum) AS itemhist LABEL="Total Item Per Customer",
       	SUM(totamt_sum) AS monetary LABEL="Monetary",
       	(today-MIN(orddate_first))/365.25 AS TOF LABEL="Time on file",
       	(today-MAX(orddate_first))/365.25 AS recency LABEL="Recency",
       	CALCULATED itemhist/ CALCULATED freq AS AOS LABEL="Average Order Size",
       	CALCULATED monetary/ CALCULATED freq AS AOA LABEL="Average Order Amount",
       	CASE(CALCULATED freq)
           	WHEN 1 THEN .
           	ELSE ((CALCULATED TOF)-(CALCULATED recency))/((CALCULATED freq)-1)
           	END AS lambda LABEL="Interpurchase time",
       	CASE(CALCULATED TOF)
           	WHEN 0 THEN .
           	ELSE CALCULATED monetary/CALCULATED TOF
           	END AS AmtPerYr LABEL="Amount Spend per Year"
	FROM rollup_order
	GROUP BY id
	;
QUIT;
PROC PRINT DATA=rollup_id (OBS=10);
RUN;
PROC MEANS DATA=rollup_id N NMISS MEAN MIN MAX MAXDEC=2;
RUN;
