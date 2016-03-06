data example9;
input string $ 1-5;
datalines;
12345
8 642
;
data unpack;
set example9;
array x[5];
do j=1 to 5;
x[j]=input(substr(string,j,1),1.);
end;
drop j;
run;

proc print data=unpack noobs;
title 'listing of unpack';
run;


data ex_11;
input string $ 1-10;
first=index(string,'XYZ');
first_C=indexc(string,'X','Y','Z');
datalines;
ABCXYZ1234
1234567890
ABCX1Y2Z29
ABCZZZXYZ3
;
proc print data=ex_11 noobs;
title 'Listing of Example 11';
run;







