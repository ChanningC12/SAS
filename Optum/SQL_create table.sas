Proc SQL;
Create Table mydata
(color CHAR(6),
x NUM,
y NUM,
amt NUM,
birthday DATE FORMAT=mmddyy10.);

Describe Table mydata;

Insert Into
mydata(color,x,y,amt,birthday)
Values
("Red",1,2,12.73,"01Jan1960"d)
Values
("Blue",3,4,23.91,"15JUN1983"d)
Values
("Green",5,6,83.33,"20FEB1997"d);

Select * from mydata;

Alter Table mydata
Add logy NUM, xsqr NUM
Drop birthday;

Update mydata Set logy=LOG(y);
Update mydata set xsqr=x*x;

Select x,y,xsqr,logy
from mydata;

Alter Table mydata
Add xsqrbin NUM;
Update mydata
Set xsqrbin=
(Case
	When (xsqr<10) Then 1
	Else 2
END);

Select x,xsqr,xsqrbin
From mydata;