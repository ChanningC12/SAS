libname orion '/sscc/datasets/imc498/littlesasbook';

%macro orderstats
(var=total_retail_price, class=order_type, decimals=2, stats=mean);
options nolabel;
title 'Order Stats';
proc means data=orion.order_fact maxdec=&decimals &stats;
var &var;
class &class;
run;
title;
%mend orderstats;

%orderstats ()
%orderstats (var=costprice_per_unit,class=quantity,stats=sum min mean max, decimals=0)