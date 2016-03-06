libname orion "/sscc/datasets/imc498/SQLdata";

%let units=4;
proc print data=orion.Order_Fact;
where Quantity > &units;
var Order_Date Product_ID Quantity;
title "Orders exceeding &units units";
run;

%let office=Sydney;
proc print data=orion.Employee_Addresses;
where City="&office";
var Employee_Name;
title "&office Employees";
run;

%let date1=25may2007;
%let date2=15jun2007;
proc print data=orion.Order_Fact;
where Order_Date between "&date1"d and "&date2"d;
var Order_Date Product_ID Quantity;
title "Orders between &date1 and &date2";
run;

