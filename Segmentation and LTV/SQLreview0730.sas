libname sscc "/sscc/datasets/imc498";

proc print data=sscc.employee(obs=10);
run;

proc sql outobs=10;
create table employee as 
select empnum, trainlev, ageyrs,
case trainlev
when 1 then 1
else 0
end as lovtrain
from sscc.employee;

select empnum,trainlev,lovtrain
from employee;

alter table employee
add agebin num;
update employee
set agebin=
(case 
when (ageyrs<40) then 1
when (ageyrs between 40 and 50) then 2
else 3
end);

select empnum,ageyrs,agebin
from employee;
