data geo;
t=0;p=0;St=1; output;
t=1;p=0.2;St=1-p;output;
Do t=2 to 25;
p=p*0.8;
St=St-p;
output;
end;
run;

proc sgplot data=geo;
step X=t Y=p;
xaxis label='Cancelation Time(t)';
yaxis label='Probablity P(T=t)';
run;

proc sgplot data=geo;
step X=t Y=St;
xaxis label='Cancelation Time(t)';
yaxis label='Survival Function S(t)';
run;
