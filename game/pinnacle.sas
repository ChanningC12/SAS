libname pb "/sscc/home/c/ccn371/game";
%let all= promotion meet_expectation
volunteer roster athlete_coach_experience facility living food
training outdoor pbteam;

data feedback;
infile "/sscc/home/c/ccn371/game/feedback.csv" 
firstobs=2 dsd dlm="," termstr=cr truncover;
input portion $ overall ltr promotion meet_expectation
volunteer roster athlete_coach_experience facility living food
training outdoor length pbteam;
run;

proc sql;
create table china as
select * from feedback
where portion = '1';

proc corr data=feedback;
var overall ltr &all;
run;

proc factor data=china corr rotate=varimax fuzz=.3 reorder;
var overall ltr &all;
run;

proc factor data=china corr rotate=varimax fuzz=.3 reorder;
var overall ltr promotion meet_expectation facility living food
outdoor pbteam;
run;