data a;
input p_id money;
cards;
1 10
2 20
3 30 
4 40
;
run;

data b;
input r_id p_id value;
cards;
100 1 600
101 1 639
102 1 675
201 2 773
202 2 778
203 2 799
301 3 888
312 3 899
401 4 1002
404 4 1432
;
run;

proc sql;
select * from a,b 
