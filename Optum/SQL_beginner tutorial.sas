data student;
input id $ first_name $ last_name $ age subject $ game $15.;
length game $15;
datalines;
100 Rahul Sharma 10 Science Cricket
101 Anjali Bhagwat 12 Maths Football
102 Stephen Fleming 09 Science Cricket
103 Shekar Gowda 18 Maths Badminton
104 Priya Chandra 15 Economics Chess
;
run;

proc sql;
select first_name, last_name from student;

proc sql;
select trim(first_name) || ' ' || + last_name as employee_name from student;

proc sql;
select first_name as name from student;

proc sql;
select *,1.5*age as newage from student
where calculated newage gt 15;

proc sql;
select trim(first_name) || ' ' || + last_name as name, age, game
from student
where age ge 10 and age le 15 and not game = "Football";

proc sql;
select * from student
where first_name LIKE 'S%' and game like 'C%';

proc sql;
select first_name, last_name, age from student 
where age Between 10 and 15;

proc sql;
select * from student
where game in ("Football" "Cricket");

proc sql;
select * from student
where game IS NULL;

proc sql;
select * from student
order by age DESC;

proc sql;
select count(*) from student
where age gt 10;

proc sql;
select distinct game from student;


proc sql;
create table student1 as 
select game, sum(age) as sumage, avg(age) as avgage ,max(age) as maxage,
min(age) as minage, count(age) as nage from student
group by game;

proc sql;
select * from student1;

proc sql;
INSERT into student
Values ('105','Channing','Cheng',24,'Statistics','Basketball');

proc sql;
select * from student;

proc sql;
INSERT into student (id,game)
Values ('106','Basketball');
select * from student;

proc sql;
update student 
set age=age+1
where age lt 15;

proc sql;
select * from student;

proc sql;
delete from student
where game = 'Chess';

proc sql;
create table employee as 
id(5),



