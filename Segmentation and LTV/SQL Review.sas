libname sqldata "/sscc/datasets/imc498/SQLdata";

proc sql;
select Employee_ID, Employee_Gender, Salary from sqldata.Employee_Payroll
where Employee_Gender="F"
order by Salary desc;
quit;

proc print data=sqldata.Employee_Payroll(obs=20);
run;

proc sql;
create table gendersalary as 
select sum(Salary) as Salary_tot
from sqldata.Employee_Payroll
group by Employee_Gender;
quit;

proc print data=gendersalary;
run;

proc sql;
select * from sqldata.employee_payroll;
quit;

proc sql;
describe table sqldata.employee_payroll;
quit;

proc sql;
select distinct employee_gender from sqldata.employee_payroll;
quit;

proc sql;
select employee_id, salary, salary*.1 as bonus,
calculated bonus/2 as half from sqldata.employee_payroll
where calculated bonus lt 3000;
quit;

proc sql;
select job_Title, salary, 
case scan(job_Title,-1,' ')
when 'I' then salary*0.05
when 'II' then salary*0.07
when 'III' then salary*0.10
when 'IV' then salary*0.12
else salary*0.08
end as bonus from sqldata.staff;
quit;

proc sql;
select employee_id, job_title, salary from sqldata.staff
where salary ge 112000;
quit;

proc sql;
select employee_id, salary from sqldata.employee_payroll
where employee_hire_date lt '01jan1979'd 
order by salary desc;
quit;

proc sql;
select employee_id label='employee identifier', sum(qtr1,qtr2,qtr3,qtr4)
'Annual Donation' format=dollar7.2, recipients from sqldata.employee_donations
where paid_by='Cash or Check'
order by 2 desc;
quit;

%let units=4;
proc print data=sqldata.Order_Fact;
where quantity gt &units;
run;





