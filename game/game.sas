libname game "/sscc/home/c/ccn371/game";

data game;
infile "/sscc/home/c/ccn371/game/Game.csv" firstobs=2 
dsd dlm=',' termstr=cr truncover;
input player_id $ date campaign $ ltv ac ad_network $ game $ geographic $
device $ targeting $;
informat date mmddyy9.;
format date mmddyy9.;
run;

proc sql;
create table newgame as
select *, (ltv-ac) as net_ltv from game;

proc sql;
create table combination as
select distinct ad_network,game,geographic,device,targeting from newgame;

proc sql;
create table cbnum as
select monotonic() as cbnum , * from combination;

proc sql;
create table aaa as
select coalesce(newgame.ad_network,cbnum.ad_network) as ad,
coalesce(newgame.game,cbnum.game) as game,
coalesce(newgame.geographic,cbnum.geographic) as geographic,
coalesce(newgame.device,cbnum.device) as device,
coalesce(newgame.targeting,cbnum.targeting) as targeting, net_ltv,cbnum
from newgame full join cbnum
on newgame.ad_network=cbnum.ad_network and 
newgame.game=cbnum.game and 
newgame.geographic=cbnum.geographic and
newgame.device=cbnum.device and
newgame.targeting=cbnum.targeting;

proc print data=aaa(obs=20);
run;

proc freq data=aaa;
tables cbnum;
run;

proc sql;
create table bbb as
select mean(net_ltv) as ltv, cbnum
from aaa
group by cbnum;

proc sql;
create table ccc as 
select coalesce(bbb.cbnum,cbnum.cbnum) as cbnum, ltv, 
ad_network,game,geographic,device,targeting
from bbb,cbnum
where bbb.cbnum=cbnum.cbnum;

proc sql;
select * from ccc
order by ltv desc;



proc glm data=newgame;
class geographic device ad_network targeting game;
model net_ltv = geographic device ad_network targeting game / solutions;
means geographic device ad_network targeting game / DUNCAN;
run;
