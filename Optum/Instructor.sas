%let q9 = Q9_1 Q9_2 Q9_3 Q9_4 Q9_5 Q9_6 Q9_7;
%let q10 = Q10_1 Q10_2 Q10_3 Q10_4 Q10_5;
%let instructor = I1-I23;

data instructor;
infile "/sscc/home/c/ccn371/optum/instructor.csv" firstobs=2 dsd dlm=","
termstr=cr truncover;
input &instructor &q9 &q10 Q14;
run;

proc print data=instructor(obs=20);
run;

proc means data=instructor;
var &q9 &q10 Q14;
run;

proc freq data=instructor;
tables &q9 &q10 Q14;
run;

proc means data=instructor maxdec=2;
var Q9_1 Q10_1 Q14;
class &instructor;
run;



