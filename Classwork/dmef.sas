libname dmef '/sscc/datasets/imc498/dmef1';

proc sql outoobs=20;
select *
from dmef.onecode;
quit;



proc sql;
select codetype, count(onecode.codetype)
from dmef.ONECODE, dmef.trans
where onecode.code=trans.code
group by codetype;
quit
group by codetype;
quit;