data heart;
input dose hr;
ldose=log(dose);
datalines;
2 60
2 58
4 63
4 62
8 67
8 65
16 70
16 70
32 74
32 73
;
run;

proc print data=heart;
run;

proc plot data=heart;
plot hr*ldose='o';
run;

proc reg data=heart;
model hr=ldose;
run;