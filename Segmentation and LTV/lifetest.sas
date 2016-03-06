data ch14_2;
input t c @@;
cards;
6 1 19 1 32 1 42 1 42 1 43 0 94 1 126 0 169 0 
207 1 211 0  227 0 253 1 255 0 270 0 310 0 316 0 335 0 346 0
;
run;

proc print data=ch14_2;
run;

proc lifetest data=ch14_2;
time t*c(0);
run;


data ch14_3;
do c=0 to 1;
do i=1 to 11;
input t f @@;
output;
end;
end;
cards;
0 90 1 76 2 51 3 25 4 20 5 7 6 4 7 1 8 3 9 2 10 21
0 0 1 0 2 0 3 12 4 5 5 9 6 9 7 3 8 5 9 5 10 26
;
run;

proc print data=ch14_3;
run;

proc lifetest data=ch14_3 method=life width=1 plots=(s);
time t*c(1);
freq f;
run;



