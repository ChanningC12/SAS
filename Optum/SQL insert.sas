proc sql;
create table new
(state char(2),
	date num informat=date9. format=date9.,
	population num);

proc sql;
insert into new
set state='IL',
	date='01MAY2015'd,
	population=123492
set state='CA',
	date='18OCT1990'd,
	population=234532;
	
proc sql;
select * from new;

proc sql;
describe table new;