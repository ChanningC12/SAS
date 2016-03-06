/*problem 7: simple group by*/
data grand;
input salesperson $ jan feb mar;
datalines;
Smith           1000        650        800
Johnson            0        900        900
Reed            1200        700        850
Davis           1050        900       1000
Thompson         750        850       1000
Peterson         900        600        500
Jones            800        900       1200
Murphy           700        800        700
Garcia           400       1200       1150
;
run;

proc sql;
select * from grand;

proc sql;
select sum(jan) as jantot, sum(feb) as febtot, sum(mar) as martot,
sum(calculated jantot,calculated febtot,calculated martot) as grandtot format=dollar10.
from grand;

/*problem 8, use substr function to group by*/
data report;
input site $ product $ invoice $ invoice_amt invoice_date $;
datalines;
V1009     VID010    V7679            598.5  980126     
V1019     VID010    V7688            598.5  980126     
V1032     VID005    V7771             1070  980309     
V1043     VID014    V7780             1070  980309     
V421      VID003    V7831             2000  980330     
V421      VID010    V7832              750  980330     
V570      VID003    V7762             2000  980302     
V659      VID003    V7730             1000  980223     
V783      VID003    V7815              750  980323     
V985      VID003    V7733             2500  980223     
V966      VID001    V5020             1167  980215     
V98       VID003    V7750             2000  980223 
;
run;

proc sql;
select * from report; 

proc sql;
title 'First Quarter Sales by Product';
select product,sum(Jan) label='Jan', sum(Feb) label='Feb',
sum(Mar) label='Mar'
from (select product,
	case 
		when substr(invoice_date,3,2)='01' then invoice_amt end as Jan,
	case 
		when substr(invoice_date,3,2)='02' then invoice_amt end as Feb,
	case
		when substr(invoice_date,3,2)='03' then invoice_amt end as Mar
from report)
group by product;

proc sql;
select product, invoice_amt, invoice_date,
	case 
		when substr(invoice_date,3,2)='01' then invoice_amt 
		end as Jan,
	case 
		when substr(invoice_date,3,2)='02' then invoice_amt 
		end as Feb,
	case
		when substr(invoice_date,3,2)='03' then invoice_amt 
		end as Mar
from report;


/*problem 9: sort by logics*/
data chores;
input project $ hours season $;
datalines;
weeding 48 summer
pruning 12 winter 
mowing 36 summer
mulching 17 fall
raking 24  fall    
raking 16  spring  
planting 8  spring  
planting 8  fall    
sweeping 3  winter  
edging 16  summer  
seeding 6  spring  
tilling 12  spring  
aerating 6  spring  
feeding 7  summer  
rolling 4  winter  
;
run;

proc sql;
select * from chores;

proc sql;
select sum(hours) as hours_tot, season
from (select hours, season,
	case
		when season="spring" then 1
		when season="summer" then 2
		when season="fall" then 3
		when season="winter" then 4
		else .
		end as sorter
	from chores)
group by season
order by sorter;

proc sql;
title "Garden Chores by Season in Logical Order";
select project, hours, season
from (select project, hours, season,
	case 
		when season="spring" then 1
		when season="summer" then 2
		when season="fall" then 3
		when season="winter" then 4
		else .
		end as sorter
		from chores)
order by sorter;


/*problem 10: conditional update*/

data sales;
input name $ department $ payrate gadgets whatnots;
datalines;
Lao_Che             M2    8     10193      1105
Jack_Colton         U2    6      9994      2710
Mickey_Raymond      M1    12      6103      1930
Dean_Proffit        M2    11      3000      1999
Antoinette_Lily     E1    20      2203      4610
Sydney_Wade         E2    15      4205      3010
Alan_Traherne       U2     4      5020      3000
Elizabeth_Bennett   E1    16     17003      3003
;
run;

proc sql;
select * from sales;

proc sql;
update sales
set payrate=case
			when gadgets gt 10000 then payrate+5
			when gadgets gt 5000 then
				case
					when department in ('E1','E2') then payrate+2
					else payrate+3
			end
			else payrate
			end;
update sales
set payrate=case
			when whatnots gt 2000 then
				case
				when substr(department,2,1)='1' then payrate+0.5
				else payrate+1
				end
			else payrate
			end;
select * from sales;









