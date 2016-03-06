data example;
title "Very important people";
footnote "Analysis done by your name";
options ls=72 ps=30;
informat birthday mmddyy10.;
input name$ income birthday;
format birthday date9.;
lines;
Channing 500000 10/18/1990
Zhangmeng 400000 11/07/1988
Zuomin 200000 02/18/1991
run;

proc print data=example;
run;/*comment*/
