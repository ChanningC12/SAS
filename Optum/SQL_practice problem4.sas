/*problem 11: */

data population;
input state $ population;
datalines;
                Texas                                20851820
                Georgia                               8186453
                Washington                            5894121
                Arizona                               5130632
                Alabama                               4447100
                Oklahoma                              3450654
                Connecticut                           3405565
                Iowa                                  2926324
                West_Virginia                         1808344
                Idaho                                 1293953
                Maine                                 1274923
                New_Hampshire                         1235786
                North_Dakota                            642200
                Alaska                                  626932
;
run;

proc sql;
select * from population;

/*problem 12: macro*/
data feature;
input name $ type $ location $ area $ height depth length;
datalines;
Aconcagua        Mountain    Argentina               .     22834         .         .
Amazon           River       South_America           .         .         .      4000
Amur             River       Asia                    .         .         .      2700
Andaman          Sea            .                218100         .      3667         .
Angel_Falls      Waterfall   Venezuela               .      3212         .         .
Annapurna        Mountain    Nepal                   .     26504         .         .
Aral_Sea         Lake        Asia                25300         .       222         .
Ararat           Mountain    Turkey                  .     16804         .         .
Arctic           Ocean          .               5105700         .     17880         .
Atlantic         Ocean          .              33420000         .     28374         .
;
run;

proc sql;
select * from feature;

proc sql noprint;
select count(distinct type) into :n
from feature;
select distinct type into :type1 - :type%left(&n)
from feature;
quit;

%macro makeds;
%do i=1 to &n;
data &&type&i (drop=type);
set feature;
if type="&&type&i";
run;
%end;
%mend makeds;
%makeds;

/*problem 13*/
data tem;
input city $ country $ avg_high avg_low;
datalines;
              Algiers             Algeria                90        45
              Amsterdam           Netherlands            70        33
              Athens              Greece                 89        41
              Auckland            New_Zealand            75        44
              Bangkok             Thailand               95        69
              Beijing             China                  86        17
              Belgrade            Yugoslavia             80        29
              Berlin              Germany                75        25
              Bogota              Colombia               69        43
              Bombay              India                  90        68
;
run;

proc sql;
select * from tem;


options fmtsearch=(sashelp.mapfmts);
proc sql;
create table extreme as 
select country, round((mean(avg_high-32)/1.8) as high,
	input (put(country,$glcsmn.),best.) as ID
from tem
where calculated ID is not missing and country in 
	(select name from



