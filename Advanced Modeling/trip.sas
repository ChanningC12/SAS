libname trip "/sscc/home/c/ccn371/Advanced Marketing Models";
/*prepare data*/
proc import datafile="/sscc/home/c/ccn371/Advanced Marketing Models/trip1.csv" 
 replace out=trip.trip_1 dbms=csv;
 run;
 
proc print data=trip.trip_1(obs=20);
run;

proc import datafile="/sscc/home/c/ccn371/Advanced Marketing Models/trip2.csv" 
 replace out=trip.trip_2 dbms=csv;
 run;
 
proc print data=trip.trip_2(obs=20);
run;

proc import datafile="/sscc/home/c/ccn371/Advanced Marketing Models/tripmonth.csv" 
 replace out=trip.trip_3 dbms=csv;
 run;

proc sql;
create table trip.trip_final as 
select * from trip.trip_1
union
select * from trip.trip_2;
quit;

proc sql;
create table trip.trip_final2 as
select * from trip.trip_final as a inner join trip.trip_3 as b
on a.Trip_ID=b.Trip_ID;

proc print data=trip.trip_final2(obs=20);
run;

/*summary of statistics*/
proc univariate data=trip.trip_final2;
class Subscriber_Type;
var Duration Start_Date;
run;

/*frequency tables*/
proc freq data=trip.trip_final2 order=freq;
tables Start_Terminal End_Terminal Bike Subscriber_Type Month;
run;

proc freq data=trip.trip_final2 order=freq;
tables Start_Terminal*End_Terminal;
run;

/*identify relevant distinct numbers*/ 
proc sql;
create table disc as
select Start_Terminal, End_Terminal, avg(Duration) as duration, count(Trip_ID) as count from trip.trip_final
group by Start_Terminal, End_Terminal
order by calculated duration desc;
quit;

proc print data=disc(obs=20);
run;

/*compare means among groups*/
proc means data=trip.trip_final2 maxdec=2 N min max mean mode skewness std;
class Subscriber_Type;
var Duration;
run;

proc means data=trip.trip_final2 maxdec=2 N min max mean mode skewness std;
class Start_Terminal;
var Duration;
run;

proc means data=trip.trip_final2 maxdec=2 N min max mean mode skewness std;
class End_Terminal;
var Duration;
run;

proc freq data=trip.trip_final2 order=freq;
tables Start_Station End_Station;
where Subscriber_Type="Subscriber";
run;

proc freq data=trip.trip_final2 order=freq;
tables Start_Station End_Station;
where Subscriber_Type="Customer";
run;

proc sgplot data=trip.trip_final2;
vbox Duration/category=Subscriber_Type;
run;

proc sql;
select count(distinct Bike) as bike, count(distinct Start_Terminal) as start, count(distinct End_Terminal) as end
from trip.trip_final;

/*ANOVA to test the significance on difference*/
proc glm data=trip.trip_final2;
class Start_Terminal;
model duration = Start_Terminal / solution;
means Start_Terminal / duncan;
run;

proc glm data=trip.trip_final2;
class Subscriber_Type;
model duration = Subscriber_Type / solution;
means Subscriber_Type / tukey;
run;

proc glm data=trip.trip_final2;
class Month;
model duration = Month / solution;
means Month / duncan lsd tukey;
run;

proc anova data=trip.trip_final2;
class Month;
model duration = Month;
means Month / lsd tukey;
run;




