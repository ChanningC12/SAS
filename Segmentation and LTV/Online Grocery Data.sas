libname grocery '/sscc/datasets/imc486/Cahill/grocery';

proc print data=grocery.cust(obs=10);
run;

proc print data=grocery.lookup(obs=10);
run;

proc print data=grocery.ordprod(obs=10);
run;

proc print data=grocery.order(obs=10);
run;

proc print data=grocery.session(obs=10);
run;

proc freq data=grocery.session;
tables plfm;
run;

proc means data=grocery.order min max n mean;
where cnsm_id='ak33787';
var ord_seq_num;
run;

proc means data=grocery.order min max n mean;
where cnsm_id='1629';
var ord_seq_num;
run;

proc means data=grocery.order min max n mean;
where cnsm_id='1955';
var ord_seq_num;
run;