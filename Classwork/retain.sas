data test;
informat buydate MMDDYY10.;
input id buydate$ amt;
format buydate date9.;
cards;
1 12/04/2011 20
1 02/20/2012 10
1 03/02/2012 5
2 03/09/2011 100
3 11/30/2010 50
3 01/01/2012 25
run;	

proc print data=test;
run;

proc sort data=test out=rfm nodupkey;
by id;

data rfm;
set test;
by id;
retain r f m;
if first.id then do;
r=.; f=0; m=0;
end;

diff="09APR2012"d - buydate;
if r=. or diff<r then r=diff;
f=f+1;
m=m+amt;
if last.id;
keep id r f m;
run;

proc print data=rfm;
run;