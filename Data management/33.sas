libname sscc "/sscc/datasets/imc498/airmiles2";
 
data assign22;
SET sscc.posts;
proc sort data=assign22;
by extref;
Run;
 
data assign221;
set assign22;
by extref;
Retain total_length_word total_length_char;
if first.extref then DO;
total_length_char=0;
total_length_word=0;
END;
total_length_char=length(content)+total_length_char;
total_length_word=countw(content)+total_length_word;
If last.extref;
RUN;

PROC means DATA=assign221;
RUN;

PROC print DATA=assign221(obs=20);
RUN;

proc sort data=sscc.key out=assign231;
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
 
proc means data=assign233(obs=250);
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
+INDEX(content,"ipod")
+INDEX(content,"i pod")
+INDEX(content,"watch")
+INDEX(content,"phone")
+INDEX(content,"olympus")
+INDEX(content,"digital")
+INDEX(content,"dvd")
+INDEX(content,"cd")
+INDEX(content,"xbox")
+INDEX(content,"ipad")
+INDEX(content,"playstation")
+INDEX(content,"magazine")
+INDEX(content,"microwave")
+INDEX(content,"tv")
+INDEX(content,"macbook")
+INDEX(content,"macbookpro")
+INDEX(content,"waffle maker")
+INDEX(content,"telescope")
+INDEX(content,"canon")
+INDEX(content,"comforter")
+INDEX(content,"panasonic")
+INDEX(content,"sport chek")
+INDEX(content,"sport chek")
+INDEX(content,"maker") > 0 THEN award = 1;
ELSE IF INDEX(content, "gift card")
+INDEX(content,"giftcard")
+INDEX(content,"gift cards")
+INDEX(content,"gifit cards")
+INDEX(content,"gift cert")
+INDEX(content,"tickets")
+INDEX(content,"movies")
+INDEX(content,"movie")
+INDEX(content,"cineplex")
+INDEX(content,"gas card")
+INDEX(content,"gas coup")
+INDEX(content,"restaurant")
+INDEX(content,"theature")
+INDEX(content,"certificates")
+INDEX(content,"cetificates")
+INDEX(content,"coupons")
+INDEX(content,"passes")
+INDEX(content,"metro")
+INDEX(content,"hotel")
+INDEX(content,"hbc")
+INDEX(content,"starbucks")
+INDEX(content,"disneyworld")
+INDEX(content,"stocking")
+INDEX(content,"grocer") > 0 THEN award = 2;

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
+INDEX(content,"europe")
+INDEX(content,"florida")
+INDEX(content,"greece")
+INDEX(content,"seaworld")
+INDEX(content,"cruise")
+INDEX(content,"europe")
+INDEX(content,"new work")
+INDEX(content,"somewhere warm")
+INDEX(content,"universal studio")
+INDEX(content,"cuba")
+INDEX(content,"some place warm")
+INDEX(content,"busch garden")
+INDEX(content,"round-trip")
+INDEX(content,"snowboarding")
+INDEX(content,"flight")
+INDEX(content,"trip")
+INDEX(content,"cold")
+INDEX(content,"vancouver")
+INDEX(content,"caribean")
+INDEX(content,"get away")
+INDEX(content,"airplane") > 0 THEN award = 3;
run;
/*add lines to the code to handle the missing value*/
 
proc print data=assign34;
where award=.;
run;
 
data group;
set assign34;
    array awarda {*} _numeric_;
    do j=1 to dim(awarda);
    if awarda(j)= . then awarda(j)=0;
    end;  
    drop J;
    run;
/*Turn missing into 0*/    
    
proc freq data=group;
   table award;
   RUN;
/*calculate the percentages of items being classified, 90.3% have been classfied*/

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
 
proc means data=assign3(obs=200);
run; 
