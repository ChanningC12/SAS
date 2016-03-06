data emps;
	input first $ gender $  hireyear;
	cards;
	Stacey F 2006
	Gloria F 2007
	James M 2007
run;

data emps2008;
	input first $ gender $ hireyears;
	cards;
	brett M 2008
	renee F 2008
run;

data niubi;
	set emps(rename=(hireyear=hireyears)) emps2008;
	by hireyears;
run;

proc print data=niubi;
run;
 