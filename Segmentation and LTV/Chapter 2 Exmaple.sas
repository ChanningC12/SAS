data np;
input time sections count @@;
datalines;
0 0 370  1 0 9  1 1 127  1 2 119  1 3 55  1 4 34  1 5 55  1 6 34
1 7 21   2 0 3  2 1 72  2 3 68  2 4 48   2 5 74  2 6 48  2 7 29
3 0 1  3 1 43  3 2 107  3 3 48  3 4 40  3 5 63  3 6 52  3 7 38  4 1 21
4 2 58  4 3 39  4 4 32  4 5 47  4 6 30  4 7 25  5 1 15  5 2 40  5 3 23
5 4 25  5 5 51  5 6 38  5 7 32  6 1 21  6 2 67  6 3 54  6 4 39  6 5 90
6 6 59  6 7 71  7 1 15  7 2 47  7 3 31  7 4 51  7 5 103  7 6 67  7 7 96
;
run;

proc print data=np;
run;

data rootnp;
set np;
rootcount=sqrt(count);
run;

proc print data=rootnp;
run;


ods graphics on;
proc kde data=rootnp;
bivar time sections /
plot=contour bwm=0.8;
freq rootcount;
run;
ods graphics off;

proc sgplot data=np;
bubble x=time y=sections size=count / datalabel=count;
run;

proc fastclus data=np maxc=5 converge=0 drift;
var time sections;
freq count;
run;





