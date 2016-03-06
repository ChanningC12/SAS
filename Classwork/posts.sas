data posts;
	infile "/sscc/datasets/imc498/airmiles/posts.txt";
	input contentid $30. contenttype $12. title $80.
		  userid $30. extref $25. Name $30.;
run;

proc contents data=posts;
run;