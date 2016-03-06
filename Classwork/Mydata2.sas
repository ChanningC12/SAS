data mydata;
input @1 color $5. @7 x 1. @9 y 1. @11 amt 5.2;
label color="color of car" x="number of dogs" 
y="favorite number" amt="dollar amt of last purchase";
lines;
red   1 2 12.73
blue  3 4 23.91
green 5 6 83.33
run;

proc print data=mydata;
run;

proc means data=mydata n mean;
run;