libname orion '/sscc/datasets/imc498/SQLdata';

proc sql;
select Employee_ID, salary, salary*.10 as Bonus
from orion.Employee_Payroll;
quit;

proc sql;
selcet Job_Title, salary, case scan(Job_Title,-1,' ')
when 'I' then salary*.05
when 'II' then salary*.07
when 'III' then salary*.10
when 'IV' then salary*.12
else salary*.08
end as Bonus
from orion.Staff;
quit;

proc sql;
create table work.birth_months as
select Employee_ID, Birth_Date,
month(Birth_Date) as Birth_Month, Employee_gender
from orion.Employee_Payroll;
describe table work.birth_months;
select * from work.birth_months;
quit;

proc sql;
select Employee_ID,Employee_Gender,
int((today()-Birth_Date)/365.25) as Age
from orion.Employee_Payroll;
quit;

proc sql;
select distinct Department from orion.Employee_Organization;
/*unique value of department*/
quit;

proc sql;
select Employee_ID, Job_Title, Salary from orion.Staff where Salary>112000;
quit;

proc sql;
select Employee_ID, Employee_Gender, Salary, Salary*.10 as Bonus, 
calculated Bonus/2 as Half
from orion.Employee_Payroll where calculated Bonus<3000;
/*calculated*/
quit;

proc sql;
select Employee_ID, Salary
from orion.Employee_Payroll
where Employee_Hire_Date<'01Jan1979'd
order by Salary desc;
quit;

proc sql;
title 'Annual Bonuses for Active Employee';
select Employee_ID label='Employee Number', 'Bonus is:', salary*.05 format=comma12.2
from orion.Employee_Payroll
where Employee_Term_Date is missing
order by salary desc;
quit;
title;

proc sql;
   select count(*) as Count
      from orion.Employee_Payroll
      where Employee_Term_Date is missing
;
quit;


