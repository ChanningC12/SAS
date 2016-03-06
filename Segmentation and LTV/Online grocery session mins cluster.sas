libname grocery '/sscc/datasets/imc486/Cahill/grocery';
libname cc '/sscc/home/c/ccn371/Segmentation LTV';

data cluster_mins;
merge cc.channel_new cc.customer1;
by cnsm_id;
run;

proc print data=cluster_mins(obs=25);
run;

proc means data=cluster_mins;
var tot_mins_tot Andph_mins_tot Andta_mins_tot Kindle_mins_tot other_mins_tot
rim_mins_tot winph_mins_tot ipad_mins_tot iphone_mins_tot 
ipod_mins_tot web_mins_tot;
class cluster;
title 'Session mins by cluster';
run;

proc means data=cluster_mins;
where baby=1;
var tot_mins_tot Andph_mins_tot Andta_mins_tot Kindle_mins_tot other_mins_tot
rim_mins_tot winph_mins_tot ipad_mins_tot iphone_mins_tot 
ipod_mins_tot web_mins_tot;
title 'Session mins Baby';
run;

proc means data=cluster_mins;
where drink=1;
var tot_mins_tot Andph_mins_tot Andta_mins_tot Kindle_mins_tot other_mins_tot
rim_mins_tot winph_mins_tot ipad_mins_tot iphone_mins_tot 
ipod_mins_tot web_mins_tot;
title 'Session mins Drink';
run;