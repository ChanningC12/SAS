/*question 1*/

data sample;
input value weight gender $;
datalines;
2893.35 9.0868 F
56.13 26.2171 M
901.43 -4.0605 F
2942.68 -5.6557 M
621.16 24.3306 F
361.50 13.8971  M   
2575.09 29.3734 F   
2157.07 7.0687 M   
690.73 -40.1271 F   
2085.8 24.4795 M   
;
run;


proc print data=sample;
run;

proc sql;
title "Weigted Average from Sample Data";
select gender, sum(value*weight)/sum(weight) as WeightAverage
from (select gender, value,
case 
when weight gt 0 then weight
else 0
end as weight
from sample)
group by gender;


/*question 2*/
data oldstaff;
input id $ last $ first $ middle $ phone $ location $;
datalines;

5463      Olsen       Mary      K.        661-0012  R2342   
          6574      Hogan       Terence   H.        661-3243  R4456   
          7896      Bridges     Georgina  W.        661-8897  S2988   
          4352      Anson       Sanford   .         661-4432  S3412   
          5674      Leach       Archie    G.        661-4328  S3533   
          7902      Wilson      Fran      R.        661-8332  R4454   
          0001      Singleton   Adam      O.        661-0980  R4457   
          9786      Thompson    Jack       .        661-6781  R2343  
;
run;

proc print data=oldstaff;
run;


data newstaff;
input id $ last $ first $ middle $ phone $ location $;
datalines;
5463      Olsen       Mary      K.        661-0012  R2342   
          6574      Hogan       Terence   H.        661-3243  R4456   
          7896      Bridges     Georgina  W.        661-2231  S2987   
          4352      Anson       Sanford  .          661-4432  S3412   
          5674      Leach       Archie    G.        661-4328  S3533   
          7902      Wilson      Fran      R.        661-8332  R4454   
          0001      Singleton   Adam      O.        661-0980  R4457   
          9786      Thompson    John      C.        661-6781  R2343   
          2123      Chen        Bill      W.        661-8099  R4432   
;
run;

proc print data=newstaff;
run;

proc sql;
select * from newstaff 
except
select * from oldstaff
;

/*question 3*/
data bowl1;
input Fullname $ Bowler AvgScore;
datalines;
Alexander_Delarge     4224         164
John_T_Chance         4425           .
Jack_T_Colton         4264           .
     .                1412         141
Andrew_Shepherd       4189         185
;
run;

data bowl2;
input Firstname $ Lastname $ AMFNo AvgScore;
datalines;
Alex        Delarge          4224        156
Mickey      Raymond          1412          .
.              .             4264        174
Jack        Chance           4425          .
Patrick     O'Malley         4118        164
;
run;

proc print data=bowl1;
run;

proc print data=bowl2;
run;

options nodate nonumber linesize=80 pagesize=60;

proc sql;
title 'Averages from last year's league when possible';
title2 'Supplemented when available from prior year's league';
select coalesce












