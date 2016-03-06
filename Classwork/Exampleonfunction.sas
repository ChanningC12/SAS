DATA mydata;
INFORMAT birthday mmddyy10.;
INPUT name$ x1 x2 x3 birthday;
sumx = SUM(OF x1-x3);
sum2 = x1 + x2 + x3;
meanx = MEAN(x1, x2, x3);
maxx = MAX(OF x1-x3);
age = ("04MAR2012"d-birthday)/365.25;
mon = MONTH(birthday);
namelen = LENGTH(name);
initial = SUBSTR(name, 1, 1);
rnd = RANUNI(12345);
FORMAT birthday DATE9. rnd 6.4;
DATALINES;
Mike 2 4 6 01/01/1960
Sally 5 . 7 10/15/1980
Ann 9 5 1 12/31/2010
RUN;
PROC PRINT DATA=mydata;
ID name;
RUN;