libname sscc "/sscc/datasets/imc498/airmiles2";

data assign22;
SET sscc.posts;
proc sort data=assign22;
by extref;
Run;

data assign221;
set assign22;
by extref;
total_length_char=length(content);
total_length_word=countw(content);
IF first.extref;
keep extref total_length_word total_length_char;
RUN;

proc print data=assign221(obs=10);
run;

proc sort data=sscc.key out=assign231;

proc print data=assign231;
run;
by extref;
run;

data assign233;
merge assign231 assign221(in=post);
retain tx;
if post then tx=1;
else tx=0;
by extref;
run;

proc print data=assign233(obs=250);
run;

proc means data=assign233;
run;



data assign21;
SET sscc.trans;
proc sort data=sscc.trans;
by collector_number;
Run;

data assign211;
set assign21;
by collector_number;
Retain Y0 Y1 Y2 Y3;
IF first.collector_number Then do; 
  Y0=0;
  Y1=0;
  Y2=0; 
  Y3=0;
END;
DIFF=Tdate-"01JAN2010"D;
if 0<=diff<=340  THEN Y0=Y0+AM_ISSUED;
else if 340<diff<=354 THEN Y1=Y1+AM_ISSUED;
else if 354<diff<=368 THEN Y2=Y2+AM_ISSUED;
else if 368<diff<=382 THEN Y3=Y3+AM_ISSUED;
if last.collector_number;
keep collector_number Y0 Y1 Y2 Y3;
RUN;

proc sort data=assign211 out=assign241;
by collector_number;
run;

proc sort data=assign233 out=assign242;
by collector_number;
run;


data assign243;
merge assign241 assign242;
by collector_number;
run;

proc print data=assign243(obs=250);
run;

proc means data=assign243;
run;



data assign251;
set assign243;
where tx=1;
run;

proc reg data=assign251;
model y1=y0 total_length_word;
model y2=y0 total_length_word;
model y3=y0 total_length_word;
run;

proc reg data=assign251;
model y1=y0 total_length_char;
model y2=y0 total_length_char;
model y3=y0 total_length_char;
run;



DATA assign34;
  SET sscc.posts(WHERE=(Name = "What are you redeeming for thi"
  AND "07DEC2010"d <= cdate <= "20DEC2010"d));

content = LOWCASE(content);
IF INDEX(content,"camera")
+INDEX(content,"mixer")
+INDEX(content,"laptop")
+INDEX(content,"netbook")
+INDEX(content,"electronic")
+INDEX(content,"computer")
+INDEX(content,"vacuum")
+INDEX(content,"vaccum")
+INDEX(content,"television")
+INDEX(content,"camara") > 0 THEN award = 1;
ELSE IF INDEX(content, "gift card")
+INDEX(content, "giftcard")
+INDEX(content, "gift cert")
+INDEX(content,"movie")
+INDEX(content,"cineplex")
+INDEX(content,"gas card")
+INDEX(content,"gas coup")
+INDEX(content,"restaurant")
+INDEX(content,"grocer") > 0
THEN award = 2;
ELSE IF INDEX(content, " trip")
+INDEX(content,"trip to")
+INDEX(content,"trip home")
+INDEX(content,"fly to")
+INDEX(content," cruise")
+INDEX(content,"seaworld")
+INDEX(content,"busch gard")
+INDEX(content,"disney")
+INDEX(content,"vegas")
+INDEX(content,"vacation")
+INDEX(content,"airline")
+INDEX(content,"travel")
+INDEX(content,"air fare")
+INDEX(content,"air tick")
+INDEX(content,"flight")
+INDEX(content,"europe") > 0 THEN award = 3;
run;

proc print data=assign34;
where award=.;
run;

proc freq data=assign34;
table award;
run;


proc sort data=assign233 out=part1;
by extref;
run;

proc sort data=assign34 out=part2;
by extref;
run;

data assign3;
merge part1 part2;
by extref;
run;

proc print data=assign3(obs=200);
run;




