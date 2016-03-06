data assignment5;
infile "/sscc/datasets/imc498/airmiles2/names.csv" firstobs=2 dsd dlm=",";
informat sponsor_name $40. sponsor_cat $12. sponsor_code $4.;
input sponsor_name $ sponsor_cat $ sponsor_code $;
run;
proc print data=assignment5(obs=10);
run;

