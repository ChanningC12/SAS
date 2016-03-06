DATA one;
INPUT id x;
DATALINES;
1 1
2 2
3 3
4 4
RUN;

DATA two;
INPUT id y;
DATALINES;
1 1
2 2
3 3
5 5
RUN;

data onetwo;
merge one(in=a) two(in=b);
by id;
if a and b;
run;

proc print data=onetwo;
run;
