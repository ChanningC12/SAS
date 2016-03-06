libname orion "/sscc/datasets/imc498/SQLdata";

proc sql;
select distinct Department from orion.Employee_Organization;
quit;

proc sql;
select Employee_ID, Job_Title, Salary from orion.Staff
where Salary>112000;
quit;

proc sql;
select Employee_ID label='Employee Identifier', Employee_Gender, Salary, Salary*0.10 as Bonus
from orion.Employee_Payroll
where calculated Bonus<3000
order by calculated Bonus desc;
quit;

proc sql;
title 'Annual Bonuses for Active Employees';
select Employee_ID label='Employee Number', 'Bonus is: ', Salary*0.05 format=comma12.2
from orion.Employee_Payroll
where Employee_Term_Date is missing
order by Salary desc;
quit;

proc sql;
select Employee_ID, sum(qtr1,qtr2,qtr3,qtr4) label='Annual Donation' format=comma9.2
from orion.Employee_Donations
where Paid_By="Cash or Check"
order by 2 desc;
quit;





