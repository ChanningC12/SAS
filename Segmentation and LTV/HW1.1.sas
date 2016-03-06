data cpk;
infile '/sscc/datasets/imc498/littlesasbook/cpk.dat';
input 
STORE_ID 1-5
Q1 6
Q2 7 
Q3 8 
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
Q14A 37-38 
;
label 
STORE_ID = 'STORE-ID'
Q1 = 'Overall experience at CPK'
Q2 = 'Overall value at CPK'
Q3 = 'Lunch/dinner'
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
Q14A = '# other 30 day dine-in'
;
run;
proc print data=cpk(obs=20); 
run;

proc means data=cpk maxdec=2;
run;

proc format;
value rating
5="Excellent"
4="Very Good"
3="Good"
2="Fair"
1="Poor"
;

proc freq data=cpk;
table Q1 Q2;
format Q1 Q2 rating.;
run;

