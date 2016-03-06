libname final "/sscc/home/c/ccn371/Advanced Marketing Models"; /*libname to assign specific name to the directory */
/*prepare data*/
data final.finaldata; 
infile "/sscc/home/c/ccn371/Advanced Marketing Models/finaldata.csv" /*Read in csv file from server*/
firstobs=2 dsd dlm="," termstr=cr truncover;
input Cust_ID $ Buy_Lag Num_Prior_Purch Dol Buy_Lag_Visits Last_Email_Imp_Lag 
		Last_Ad_Imp_Lag Purchase SEM_B SEM_NB Display Email;
run;

proc print data=final.finaldata; /*Proc print*/
run;

data final.finaldata_old;
set final.finaldata;
if Num_Prior_Purch gt 0;   /*Reset the file, people who made purchase before*/
run;

data final.finaldata_new;
set final.finaldata;
if Num_Prior_Purch=0; /* New buyer, no previous buy*/
run;

/*Logistic regression doesn't work well in this case*/
proc logistic data=final.finaldata_old descending;  /*Logistic regression*/
model Purchase=Buy_Lag Num_Prior_Purch Dol Buy_Lag_Visits Last_Email_Imp_Lag 
		Last_Ad_Imp_Lag SEM_B SEM_NB Display Email;
run;

proc logistic data=final.finaldata_new descending;
model Purchase=Dol SEM_B SEM_NB Display Email;
run;

proc logistic data=final.finaldata descending;
model Purchase=Buy_Lag Num_Prior_Purch Dol Buy_Lag_Visits Last_Email_Imp_Lag 
		Last_Ad_Imp_Lag SEM_B SEM_NB Display Email;
run;
/*end logistic regression*/

/*See multiple linear regression model*/
proc reg data=final.finaldata_old;  
model Dol=Buy_Lag Num_Prior_Purch Buy_Lag_Visits Last_Email_Imp_Lag 
		Last_Ad_Imp_Lag SEM_B SEM_NB Display Email;
where Purchase=1; /* only apply to purchase=1 item*/
run;

proc reg data=final.finaldata_new;
model Dol=SEM_B SEM_NB Display Email;
run;
/*end multiple regression*/











