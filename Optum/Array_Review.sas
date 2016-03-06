data example;
input a b c d;
length loga logb logc logd 4;
array x{*} a b c d;
array logx{*} loga logb logc logd;
Do i=1 to DIM(x);
logx{i}=log(x{i});
end;
drop i;
datalines;
1 4 5 2
6 3 6 3
7 5 3 6
run;

proc print data=example noobs;
format loga logb logc logd 5.3;
run;


data reversesurvey;
input x1-x6;
array x{*} x1-x6;
Do i=1 to DIM(x);
x{i}=6-x{i};
end;
drop i;
datalines;
1 2 2 3 1 2
3 2 1 2 3 2
3 3 4 3 4 2
1 1 1 2 1 1
run;

proc print data=reversesurvey noobs;
run;

data example1;
input sat1-sat3 imp1-imp3;
array sat{*} sat1-sat3;
array imp{*} imp1-imp3;
length prod1-prod3 4;
array prod{*} prod1-prod3;
DO i=1 to DIM(prod);
prod{i}=sat{i}*imp{i};
end;
drop i;
datalines;
1 4 5 2 2 5
3 3 1 3 4 1
2 5 3 4 4 3
run;

proc print data=example1 noobs;
run;