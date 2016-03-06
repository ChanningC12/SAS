data reading;
input group $ words @@;
datalines;
X 700 X 850 X 820 X 640 X 920
Y 480 Y 460 Y 500 Y 570 Y 580
Z 500 Z 550 Z 480 Z 600 Z 610
;
proc anova data=reading;
title 'ANOVA';
class group;
model words=group;
means group;
run;

proc glm data=reading;
class group;
model words=group;
contrast 'X vs. Y and Z' group -2 1 1;
contrast 'method Y vs Z' group 0 1 -1;
run;