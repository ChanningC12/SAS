%let c1= Q4_2 Q4_4;
%let c2= Q5_2 Q5_3 Q5_6;
%let c3= Q6_1 Q6_2;
%let c4= Q7_1 Q7_2;
%let c5= Q8_1-Q8_23;
%let c6= Q16_2-Q16_6;
%let q = Q9_1 Q9_2 Q9_3 Q9_4 Q9_5 Q9_6 Q9_7 Q10_1 Q10_2 Q10_3 Q10_4 Q10_5 Q14;
%let qq= qq1-qq13; 
data ins_per;
infile "/sscc/home/c/ccn371/optum/Instructor Performance By Course.csv" 
firstobs=2 dsd dlm=',' 
termstr=cr truncover;
input Q3 I1_1-I1_2 I2_1-I2_3 I3_1-I3_2 I4_1-I4_2 I5_1-I5_23 I6_1-I6_5 &q;
run;

data ins_per;
set ins_per;
where Q9_1 gt 0;
run;

proc print data=ins_per(obs=20);
run;

/*course1*/
%macro ins1(I,P);
proc means data=ins_per maxdec=2;
var Q9_1 Q10_1 Q14;
where &I=1 and Q3=1;
title "&P";
run;
%mend ins1;

%ins1(I=I1_1,P=I1_1);
%ins1(I=I1_2,P=I1_2);

/*course2*/
%macro ins2(I,P);
proc means data=ins_per maxdec=2;
var Q9_1 Q10_1 Q14;
where &I=1 and Q3=2;
title "&P";
run;
%mend ins2;

%ins2(I=I2_1,P=I2_1);
%ins2(I=I2_2,P=I2_2);
%ins2(I=I2_3,P=I2_3);

/*course3*/
%macro ins3(I,P);
proc means data=ins_per maxdec=2;
var Q9_1 Q10_1 Q14;
where &I=1 and Q3=3;
title "&P";
run;
%mend ins3;

%ins3(I=I3_1,P=I3_1);
%ins3(I=I3_2,P=I3_2);

/*course4*/
%macro ins4(I,P);
proc means data=ins_per maxdec=2;
var Q9_1 Q10_1 Q14;
where &I=1 and Q3=4;
title "&P";
run;
%mend ins4;

%ins4(I=I4_1,P=I4_1);
%ins4(I=I4_2,P=I4_2);

/*course5*/
%macro ins5(I,P);
proc means data=ins_per maxdec=2;
var Q9_1 Q10_1 Q14;
where &I=1 and Q3=5;
title "&P";
run;
%mend ins5;

%ins5(I=I5_1,P=I5_1);
%ins5(I=I5_2,P=I5_2);
%ins5(I=I5_3,P=I5_3);
%ins5(I=I5_4,P=I5_4);
%ins5(I=I5_5,P=I5_5);
%ins5(I=I5_6,P=I5_6);
%ins5(I=I5_7,P=I5_7);
%ins5(I=I5_8,P=I5_8);
%ins5(I=I5_9,P=I5_9);
%ins5(I=I5_10,P=I5_10);
%ins5(I=I5_11,P=I5_11);
%ins5(I=I5_12,P=I5_12);
%ins5(I=I5_13,P=I5_13);
%ins5(I=I5_14,P=I5_14);
%ins5(I=I5_15,P=I5_15);
%ins5(I=I5_16,P=I5_16);
%ins5(I=I5_17,P=I5_17);
%ins5(I=I5_18,P=I5_18);
%ins5(I=I5_19,P=I5_19);
%ins5(I=I5_20,P=I5_20);
%ins5(I=I5_21,P=I5_21);
%ins5(I=I5_22,P=I5_22);
%ins5(I=I5_23,P=I5_23);

/*course6*/
%macro ins6(I,P);
proc means data=ins_per maxdec=2;
var Q9_1 Q10_1 Q14;
where &I=1 and Q3=6;
title "&P";
run;
%mend ins6;

%ins6(I=I6_1,P=I6_1);
%ins6(I=I6_2,P=I6_2);
%ins6(I=I6_3,P=I6_3);
%ins6(I=I6_4,P=I6_4);
%ins6(I=I6_5,P=I6_5);

