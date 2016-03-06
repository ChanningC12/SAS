/*SAS ignore missing values*/
data example;
input x1-x3;
sum1=sum(of x1-x3);
sum2=sum(x1,x2,x3);
sum3=x1+x2+x3; /*can not ignore missing values*/
mean1=mean(of x1-x3);
mean2=mean(x1,x2,x3);
mean3=(x1+x2+x3)/3; /*can not ignore missing values*/
n=N(of x1-x3);
nmiss=nmiss(of x1-x3);
std=std(of x1-x3);
datalines;
1 2 .
4 3 2
. . .
3 . .
4 4 4
run;

proc print data=example noobs;
run;

/* numeric to string conversion 
INPUT and PUT and reverse function
use INPUT to convert string to numeric
use PUT to convert numeric to string
*/
data example1;
input x s$;
xstr=put(x, 5.2);
xstr2=put(x,dollar4.);
snum=input(s,BEST.);
datalines;
1 10
2 20
3 30
run;

proc print data=example1 noobs;
run;

/*DATE
difference between two days: INTCK('unit',d1,d2)
*/