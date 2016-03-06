libname orion '/sscc/datasets/imc498/SQLdata';

proc sql;
select Employee_ID, Salary, 
case scan(Job_Title,-1,'')
when 'I' then Salary*0.05
when 'II' then Salary*0.07
when 'III' then Salary*0.10
when 'IV' then Salary*0.12
else Salary*0.08
end as Bonus
from orion.Staff;
quit;

proc sql;
create table work.birth_months as
select Employee_ID, Birth_Date, month(Birth_Date) as Birth_Month, Employee_gender
from orion.Employee_Payroll;
describe table work.birth_months;
select * from work.birth_months;
quit;

