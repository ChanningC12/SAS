
data ss;
input id $ city $;
datalines;
1 Beijing
2 Shanghai
3 Chicago
4 LA
5 NewYork
6 Paris
;
run;

data tt;
input id $ price;
datalines;
1 14
2 8
3 9
4 19
5 23
6 13
;
run;

proc print data=ss;
run;

proc print data=tt;
run;


proc sql;
create table mm as
select COALESCE(ss.id,tt.id) as id, city, price
from ss,tt
where ss.id=tt.id
;

proc print data=mm;
run;

proc sql;
title "Niubier than Paris";
select * from mm
where price gt (select price from mm where city="Paris");







