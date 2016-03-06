data quest;
input id 1-3 age 4-5 gender $ 6 
race $ 7 marital $ 8 educ $ 9
pres $ 10 arms $ 11 cities $ 12;
if 0<= age <= 20 then agegrp=1;
if 20<age<=40 then agegrp=2;
if 40<age<=60 then agegrp=3;
if age>60 then agegrp=4;
label
marital='marital status'
educ='education level'
pres='president doing a good job'
arms='arms budget increase'
cities='federal aid to cities';
datalines;
001091111232
002452222422
003351324442
004271111121
005682132333
006651243425
run;

proc format;
value $educ '1'='high school or less'
'2'='two year college'
'3'='four year college'
'4'='graduate degree';

proc print data=quest;
run;

proc means data=quest maxdec=2 n mean std;
title 'questionnaire analysis';
var age;
run;

proc freq data=quest;
title 'frequency counts for categorical variables';
tables gender race marital educ pres arms cities;
run;