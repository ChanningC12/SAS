libname orion '/sscc/datasets/imc498/SQLdata';

%let units=4;
proc print data=orion.Order_Fact;
where Quantity>&units;
var Order_Date Product_ID Quantity;
title "Orders exceeding &units uits";
run;
