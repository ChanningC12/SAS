libname grocery '/sscc/datasets/imc486/Cahill/grocery';
libname cc '/sscc/home/c/ccn371/Segmentation LTV';

proc print data=grocery.session(obs=10);
run;

proc freq data=grocery.session;
table dvce_type;
run;

proc sort data=grocery.session out=session;
by ord_id;
run;

data sess_mins;
set session;
where tot_sess_min_qy ge 0;
by ord_id;

keep ord_id tot_mins Andph_mins Andta_mins Kindle_mins other_mins
rim_mins winph_mins ipad_mins iphone_mins ipod_mins web_mins;


retain tot_mins Andph_mins Andta_mins Kindle_mins other_mins
rim_mins winph_mins ipad_mins iphone_mins ipod_mins web_mins;

if first.ord_id then do;
tot_mins=0;
Andph_mins=0;
Andta_mins=0;
Kindle_mins=0;
other_mins=0;
rim_mins=0;
winph_mins=0;
ipad_mins=0;
iphone_mins=0;
ipod_mins=0;
web_mins=0;

end;
tot_mins=tot_mins+tot_sess_min_qy;
if dvce_type='Android Ph' then Andph_mins=Andph_mins+tot_sess_min_qy;
if dvce_type='Android Ta' then Andta_mins=Andta_mins+tot_sess_min_qy;
if dvce_type='Kindle' then Kindle_mins=Kindle_mins+tot_sess_min_qy;
if dvce_type='Other' then other_mins=other_mins+tot_sess_min_qy;
if dvce_type='RIM Tablet' then rim_mins=rim_mins+tot_sess_min_qy;
if dvce_type='Windows Ph' then winph_mins=winph_mins+tot_sess_min_qy;
if dvce_type='iPad' then ipad_mins=ipad_mins+tot_sess_min_qy;
if dvce_type='iPhone' then iphone_mins=iphone_mins+tot_sess_min_qy;
if dvce_type='iPod' then ipod_mins=ipod_mins+tot_sess_min_qy;
if dvce_type='web' then web_mins=web_mins+tot_sess_min_qy;

if last.ord_id then do;
output;
end;

proc print data=sess_mins(obs=20);
run;

proc means data=sess_mins;
run;









