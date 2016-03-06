data mydata;
input color $ x y amount;
cards;
red 1 2 12.73
blue 3 4 23.91
green 5 6 83.33
run;

proc sql;
select *
from mydata;

select color, x
from mydata
order by x desc;

select color,x,y
from mydata
where x>2
order by 2;
