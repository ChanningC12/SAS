/*question 4: create easy to read percentile*/
data sub;
input state $ answer $;
datalines;
NY       YES  
NY       YES  
NY       YES  
NY       YES  
NY       YES  
NY       YES  
NY       NO   
NY       NO   
NY       NO   
NC       YES 
NC       NO
NC       YES 
NC       NO
NC       YES 
NC       NO
NC       YES 
NC       NO
;
run;

proc print data=sub;
run;

proc sql;
select state, sub.answer, count(state) as count,
calculated count / subtotal as percent format=percent8.2
from sub,
(select answer,count(*) as Subtotal from sub
group by answer) as survey2
where sub.answer = survey2.answer
group by sub.answer,state;


proc sql;
create table sub2 as
select *, count(answer) as count
from sub
group by state, answer;

proc sql;
select *, sum(count) as total, count/calculated total as percent format=percent8.2
from sub2
group by answer;




/*question 5*/

data dup;
input lastname $ firstname $ city $ state $;
datalines;
Smith       John        Richmond    Virginia
Johnson     Mary        Miami       Florida 
Smith       John        Richmond    Virginia
Reed        Sam         Portland    Oregon  
Davis       Karen       Chicago     Illinois
Davis       Karen       Chicago     Illinois
Thompson    Jennifer    Houston     Texas   
Smith       John        Richmond    Virginia
Johnson     Mary        Miami       Florida 
;
run;

proc sql;
select * from dup;

proc sql;
select *, count(*) as count from dup
group by lastname, firstname, city, state
having count(*) gt 1;


/*question 6*/
data hie;
input ID $ LastName $ FirstName $ Supervisor $;
datalines;
1001    Smith       John           1002   
1002    Johnson     Mary           None   
1003    Reed        Sam            None   
1004    Davis       Karen          1003   
1005    Thompson    Jennifer       1002   
1006    Peterson    George         1002   
1007    Jones       Sue            1003   
1008    Murphy      Janice         1003   
1009    Garcia      Joe            1002  
;
run;

proc sql;
select * from hie;


proc sql;
title 'Expanded Employee and Supervisor Data';
select A.ID label="Employee ID",
trim(A.FirstName) || ' ' || A.LastName label="Employee_Name",
B.ID label="Supervisor ID",
trim(B.FirstName) ||' '|| B.LastName label="Supervisor_Name"
from hie A, hie B
where A.Supervisor_Name = B.ID and A.Supervisor_Name is not missing;

/*

How It Works
This solution uses a self-join (reflexive join) to match employees and 
their supervisors. The SELECT clause assigns aliases of A and B 
to two instances of the same table and retrieves data from each instance. 
From instance A, the SELECT clause
selects the ID column and assigns it a label of Employee ID
selects and concatenates the FirstName and LastName columns 
into one output column and assigns it a label of Employee Name.

From instance B, the SELECT clause
selects the ID column and assigns it a label of Supervisor ID
selects and concatenates the FirstName and LastName columns 
into one output column and assigns it a label of Supervisor Name.
In both concatenations, the SELECT clause uses the TRIM function 
to remove trailing spaces from the data in the FirstName column, 
and then concatenates the data with a single space and 
the data in the LastName column to produce a single character value 
for each full name.
trim(A.FirstName)||' '||A.LastName label="Employee Name"
When PROC SQL applies the WHERE clause, the two table instances are joined. 
The WHERE clause conditions restrict the output to only 
those rows in table A that have a supervisor ID that matches 
an employee ID in table B. This operation provides a 
supervisor ID and full name for each employee in the original table, 
except for those who do not have a supervisor.
 where A.Supervisor=B.ID and A.Supervisor is not missing;
Note:   Although there are no missing values in the Employees table, 
you should check for and exclude missing values from your results to 
avoid unexpected results. For example, 
if there were an employee with a blank supervisor ID number and 
an employee with a blank ID, then they would produce an erroneous 
match in the results.  [cautionend]
*/











