libname cpk '.';

data cpk10;
	infile '/sscc/datasets/imc498/cpk.dat';
input STORE_ID $ 1-5 
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
GENDER $ 45
;
label 
STORE_ID = 'STORE-ID'
Q1 = 'Overall experience at CPK'
Q2 = 'Overall value at CPK'
Q3 = 'Lunch/dinner'
Q4 = 'Main menu item ordered'
Q5 = 'Ordered before?'
Q6a = 'Taste of food'
Q6b = 'Freshness of food'
Q6c = 'Portion Size'
Q6d = 'Temp appropriateness'
Q6e = 'Value for money'
Q6f = 'Q6A: reorder item?'
Q7a = 'Speed/attentiveness of waiter'
Q7b = 'attitude of server'
Q7c = 'server knowledge/helpful'
Q7d = 'overall service from staff'
Q8a = 'attractive decor'
Q8b = 'clean'
Q8c = 'comfortable'
Q8d = 'overall atmosphere'
Q9 = 'area to improve'
Q10a = 'two most important aspects'
Q10b = 'two most important aspects'
Q11 = 'visit again?'
Q12 = 'number times at cpk'
Q13A = '# cpk 30 day dine-in'
Q13B = '# cpk 30 day take-out'
Q13C = '# cpk 30 day delivery'
Q14A = '# other 30 day dine-in'
Q14B = '# other 30 day take-out'
Q14C = '# other 30 day delivery'
Q15 = 'number in party'
GENDER = 'GENDER'
;
run;

proc contents data=cpk10; run;
proc means data=cpk10; run;

%let q6=q6a q6b q6c q6d q6e;/*store them in one variable*/
%let q7=q7a q7b q7c q7d;
%let q8=q8a q8b q8c q8d;
%let q10=q10c q10d q10e q10f q10g;
%let sat=&q6 &q7 &q8;

proc factor data=cpk10;
var &q6 &q7 &q8;
run;

proc factor data=cpk10;
var &sat;
run;

proc freq data=cpk10;
tables &sat;
tables q6a*(&q7);
run;

