data census;
input zip educ;
card;
60201 17
60202 16.5
60626 11
60645 14
run;

data housedat;
input name$ zip dollars;
cards;
John 60201 1234
Julie 60203 253
James 60645 875
Joe 60645 736
Jed 60202 143
run;
title "dataset housedat";

proc print data=housedat;
run;

proc sort data=census;
by zip;
proc sort data=housedat;
by zip;
run;

data cenhou;
merge census(in=a) housedat(in=b);
by zip;
if a and b;
run;

proc print data=cenhou;
run;