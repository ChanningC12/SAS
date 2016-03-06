data elect;
input gender $ candid $;
datalines;
M DEWEY
F TRUMAN
M TRUMAN
M DEWEY
F TRUMAN
run;

proc freq data=elect;
tables candid*gender / chisq;
run;


data chisq;
input group $ outcome $ count;
datalines;
control dead 20
control alive 80
drug dead 10
drug alive 90
run;

proc freq data=chisq;
tables group*outcome / chisq;
weight count;
run;