data try;
input player $ score;
datalines;
kobe 22
kobe 32
lbj 22
kd 34
lbj 45
kd 31
kobe 81
kd 46
kobe .
;


proc sort data=try;
by player;
run;

data try1;
set try;
where score ne missing;
run;

proc print data=try1;
run;

data tryout;
set try;
by player;

keep player totscore score games;
retain player totscore games;

if first.player then do;
totscore=0;

end;
totscore=totscore+score;

if last.player then do;

output;
end;


proc print data=tryout;
run;













