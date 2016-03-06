/*We want to retrieve the names of all salespeople 
that have more than 1 order from the tables above. 
You can assume that each salesperson only has one ID.*/

data salesperson;
input ID $ name $ Age Salary;
datalines;
1 Abe 61 140000
2 Bob 34 44000
5 Chris 34 40000
7 Dan 41 52000
8 Ken 57 115000
11 Joe 38 38000
;
run;

data orders;
input number order_date cust_id $ salesperson_id $ Amount;
informat order_date date9.;
format order_date date9.;
datalines;
10 '02AUG1996'd 4 2 540
20 '30JAN1999'd 4 8 1800
30 '14JUL1995'd 9 1 460
40 '29JAN1998'd 7 2 2400
50 '03FEB1998'd 6 7 600
60 '02MAR1998'd 6 7 720
70 '06MAY1998'd 9 7 150
;
run;

proc sql inobs=6;
select * from salesperson;

proc sql;
select * from orders;

proc sql;
select name, salesperson_ID from salesperson, orders
where salesperson.ID=orders.salesperson_id
group by salesperson_ID,name
having count(orders.salesperson_id) gt 1;

proc sql;
create table agg as
select COALESCE(salesperson.ID,orders.salesperson_id) as S_ID,
sum(orders.Amount) as sumamt, min(today()-orders.order_date) as recency
  from salesperson, orders
where salesperson.ID=orders.salesperson_id
group by S_ID;

proc sql;
select * from agg feedback;





