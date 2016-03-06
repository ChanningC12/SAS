Data example1;
Do i=1 to 5;
Output;
End;
Run;

Data example2;
i=0;
Do Until (i=5);
i=i+1;
Output;
End;
Run;

Data example3;
i=0;
Do While (i<5);
i=i+1;
Output;
End;
Run;

%macro ex(i);
proc print data=&i;
run;
%mend ex;

%ex(i=example1);
%ex(i=example2);
%ex(i=example3);



