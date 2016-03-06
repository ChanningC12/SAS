data diagnose;
input id $ dx1 dx2 dx3;
datalines;
01 3 4 .
02 1 2 3
03 4 5 . 
04 7 . .
;
run;

proc print data=diagnose;
run;

data new;
set diagnose;
array dxarray[3] dx1-dx3;
do i=1 to 3;
dx=dxarray[i];
if dx ne . then output;
end;

keep id dx;
run;

proc print data=new;
run;

data score;
input id $ s1 s2 s3;
datalines;
01 3 4 5
02 7 8 9
03 6 5 4 
;
run;

proc print data=score;
run;

data newscore;
set score;
array s[3] s1-s3;
do i = 1 to 3;
score=s[i];
output;
end;

keep id time score;
run;

proc print data=newscore;
run;

data wtone;
input id $ wt1-wt6;
datalines;
01 155 158 162 149 148 147
02 110 112 114 107 108 109
;
run;

proc print data=wtone;
run;

data wtmany;
set wtone;
array wts[2,3] wt1-wt6;
do cond=1 to 2;
do time=1 to 3;
weight=wts[cond,time];
output;
end;
end;
drop wt1-wt6;
run;

proc print data=wtmany;
run;

proc sort data=wtmany;
by id cond time;
run;

data wtone2;
array wt[2,3] wt1-wt6;
retain wt1-wt6;
set wtmany;
by id;
if first.id then do i=1 to 2;
do j=1 to 3;
wt[i,j]=.;
end;
end;
wt[cond,time]=weight;
if last.id then output;
keep id wt1-wt6;
run;

proc print data=wtone2;
run;





























