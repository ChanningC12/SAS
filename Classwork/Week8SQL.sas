libname orion '/sscc/datasets/imc498/SQLdata';

proc sql;
select distinct(Marital_Status)
from orion.Employee_payroll;
quit;

proc sql feedback;
select employee_payroll.employee_ID,employee_gender, Marital_status,
Recipients from orion.Employee_payroll
/*select all the data*/
inner  join/*or try left join here*/
orion.Employee_donations
on Employee_payroll.Employee_ID=Employee_donations.Employee_ID
where Marital_Status='M';
quit;
/*no sort requirement to do the process*/