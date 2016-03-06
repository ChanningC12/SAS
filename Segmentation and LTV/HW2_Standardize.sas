libname hw2 "/sscc/datasets/imc486/Cahill";

proc contents data=hw2.bookorder_customer_unix;
run;

proc factor data=hw2.bookorder_customer_unix nfactors=9 rotate=varimax
reorder;
var AOA AOS AmtPerYear TOF freq itemhist lambda monetary recency;
run;

/*by default, factor analysis gives all the factors greater than 1
Look at:
1. Variance Explained by Each Factor
2. Rotated Factor Pattern: 
*/




