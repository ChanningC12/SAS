libname orion '/sscc/datasets/imc498/littlesasbook';
option mcompilenote=all;
%Macro Customers;
proc print data=orion.customer_dim;
var Customer_Group Customer_Name Customer_Gender Customer_Age;
where Customer_Group contains "&type";
title "&type Customers";
run;
%mend Customers;

%let type=Internet;
%Customers 
/*call the macro*/