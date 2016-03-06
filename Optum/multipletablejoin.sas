data qifeng1;
input id $ score;
datalines;
1 23
2 34
3 45
;
run;

data qifeng2;
input id $ reb;
datalines;
1 10
2 5
3 6
;
run;

data qifeng3;
input id $ asi;
datalines;
1 5
2 7
3 9
;
run;

data qifeng4;
input id $ blk;
datalines;
1 5 
2 1
3 2
;
run;

data qifeng5;
input id $ stl;
datalines;
1 3
2 5
3 7
;
run;


proc sql;
select coalesce(qifeng1.id,qifeng2.id,qifeng3.id,qifeng4.id,qifeng5.id) as id, score, reb, blk, asi, stl from qifeng1,qifeng2,qifeng3,qifeng4,qifeng5
where qifeng1.id=qifeng2.id=qifeng3.id=qifeng4.id=qifeng5.id
;











