libname orion '/sscc/datasets/imc498';
data qiqifeng;
	set orion.sales(keep=last_name salary country job_title hire_date);
	if upcase(country) = 'US' then do;
	bonus=500;freq='once a year';
	end;
	else if upcase(country)='AU' then do;
	bonus=300;freq='twice a year';
	end;
	newsalary=1.1*salary;
	compensation=sum(newsalary,bonus);
	bonusmonth=month(hire_date);
run;

proc print data=qiqifeng;
run;