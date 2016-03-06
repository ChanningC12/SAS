data try;
input cus type $ amt;
datalines;
1 bball 10
1 football 22
1 football 45
2 bball 45
2 bball 43
2 bball 22
2 bball 13
2 football 18
2 football 43
2 football 26
1 bball 58
1 bball 23
;
run;

proc print data=try;
run;

proc sort data=try out=trynow;
by cus;
run;

proc print data=trynow;
run;

data qifeng;
set trynow;
by cus;

retain totamt tot_bball tot_football;

keep cus totamt tot_bball tot_football;

if first.cus then do;
totamt=0;
tot_bball=0;
tot_football=0;

end;
totamt=totamt+amt;
if type='bball' then tot_bball=tot_bball+amt;
if type='football' then tot_football=tot_football+amt;
if last.cus then do;

output;
end;

proc print data=qifeng;
run;








