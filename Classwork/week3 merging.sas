data emps11;
	input empid job $ salary;
	cards;
	1111 basketball 130000
	2222 football 120000
	3333 swimming 5000

run;
data emps12;
	input empid gender $ hireyear;
	cards;
	1111 M 2008
	2222 F 2008
	3333 M 2007
run;

data emps1112;
	merge emps11 emps12;
	by empid;
run;

proc print data=emps1112;
run;