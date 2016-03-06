data test1;
input name $ type $;
datalines;
kobe nba
alex mlb
tim nba
sam mlb
run;

data test2;
input celebrity $ follower $;
datalines;
kobe chris
alex kobe
tim derek
kobe tim
sam tim
run;

proc print data=test1;
run;

proc print data=test2;
run;

data test3;
set test1;
where type='nba';
rename type=type1;
rename name=follower;
run;

data test4;
set test1;
where type='mlb';
rename type=type2;
rename name=celebrity;
run;

proc print data=test3;
run;

proc print data=test4;
run;

proc sort data=test2 out=test21;
by follower;
run;

proc sort data=test2 out=test22;
by celebrity;
run;

proc sort data=test3 out=test31;
by follower;
run;

proc sort data=test4 out=test41;
by celebrity;
run;

data test5;
merge test31 test21;
by follower;
run;

proc sort data=test5 out=test51;
by celebrity;
run;

proc print data=test5;
run;

data test6;
merge test41 test51;
by celebrity;
run;

proc print data=test6;
run;

data test7;
set test6;
where type1='nba' and type2='mlb';
run;

proc print data=test7;
run;

proc contents data=test7;
run;
