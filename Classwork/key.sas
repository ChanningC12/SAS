data assignment3;
infile "/sscc/datasets/imc498/airmiles2/key.txt"
firstobs=2 dsd dlm="09"x termstr=cr;
informat extref $25. userid $11.;
input extref $ userid $;
run;
proc print data=assignment3(obs=10);
run;

