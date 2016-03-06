data date;
input 
@1 id 3. 
@5 DOB MMDDYY6. 
@12 ADMIT MMDDYY6. 
@18 DISCHENG 
@25 DX 1.
@26 FEE 5.;
Len_STAY = DISCHRG-ADMIT+1;
AGE=INT((ADMIT-DOB)/365.25);
if century=18 then age=age+100;
datalines;

