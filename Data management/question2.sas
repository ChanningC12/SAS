libname ass "/sscc/datasets/imc498/airmiles2";

data newposts;
set ass.posts(keep=extref);
run;

proc print newposts(obs=10) noobs;
run;

proc sort data=ass.posts;
by extref;

proc sort data=ass.key;
by extref;

data postkey;
merge ass.posts ass.key;
by extref;
run;

proc print data=postkey(obs=20) noobs;
run;