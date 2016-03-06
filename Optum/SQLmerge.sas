data one;
input id x;
datalines;
1 1
2 2
3 3
;
run;

data two;
input id y;
datalines;
1 1
2 2
4 4
;
run;

proc sql;

title "one";
select* from one;

title "two";
select* from two;

title "Cartesian";
select * from one, two;

title "inner join";
select * from one,two
where one.id=two.id;

title "left join";
select * from one left join two
on one.id = two.id;

title "left join with listed variable";
select one.id,x,y from one left join two
on one.id=two.id;

title "full join";
select one.id label "one.id", 
two.id label "two.id",x,y from one full join two
on one.id = two.id;

title "full join with listed variable";
select coalesce(one.id,two.id) as id, x, y
from one full join two
on one.id=two.id;

title "inner join with listed variable";
select coalesce(one.id,two.id) as id, x, y
from one,two
where one.id=two.id;

title "table alias";
select a.id,x,y
from one as a, two as b
where a.id=b.id;
