data hw12;
infile '/sscc/datasets/imc498/littlesasbook/employee.csv' 
firstobs=2 dlm=',' dsd missover termstr=cr;
input 
empnum $
annsalary
gender
ageyrs
expyrs
trainlev
;

label
empnum = 'employee number'
annsalary = 'annual salary in dollars'
gender = '1 if the person is female, 0 for male'
ageyrs = 'age in years'
expyrs = 'experience in years'
trainlev = 'training level (1, 2, or 3)'
run;

proc print data=hw12;
run;

proc means data=hw12 n mean min max;
run;

proc format;
value sex
0="male"
1="female"
;

proc means data=hw12;
var annsalary;
class gender;
format gender sex.;
run;



