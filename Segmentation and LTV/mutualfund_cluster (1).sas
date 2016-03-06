{\rtf1\ansi\ansicpg1252\cocoartf1265\cocoasubrtf190
{\fonttbl\f0\fmodern\fcharset0 Courier;}
{\colortbl;\red255\green255\blue255;}
\margl1440\margr1440\vieww15020\viewh15340\viewkind0
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural

\f0\fs24 \cf0 libname mydata "/courses/u_northwestern.edu1/i_638478/c_7857/imc486" access=readonly;\
 proc contents data=mydata.investdata; run;\
 proc print data=mydata.investdata(obs=50); run;\
 proc means data=mydata.investdata; format opendt date.; run;\
 \
 proc sort data=mydata.investdata out=invest; by cust_num;\
run;\
\
data test;\
\
	dat = 17827;\
proc print; var dat; format dat date.; run;\
proc freq data=mydata.investdata; tables category; run;\
/*\
5	acct_num	Num	8	Account Number\
4	age	Num	8	Customer Age\
3	balance	Num	8	Account Balance\
2	category	Char	6	Fund Category\
1	cust_num	Num	8	Customer Number\
6	opendt	Num	8	Account Open Date  max = 17827 [22oct2008]\
*/\
\
data rollup;\
	set invest;\
	by cust_num;\
	\
	retain frstdt totbal numact tot_bond tot_equity tot_other numactive;\
	keep cust_num frstdt totbal numact  numactive tot_bond tot_equity tot_other risk_level\
		pct_bond age num_category age_fill;\
	\
	if first.cust_num then do;\
		frstdt = '31DEC2020'd;\
		totbal =0;\
		numact=0;\
		numactive=0;\
		tot_bond = 0; \
		tot_equity =0; \
		tot_other =0;\
	end;\
	\
	/*total balance, balance by type */\
	\
	if frstdt > opendt then frstdt = opendt;\
	totbal=totbal+balance;\
	numact=numact+1;\
	if balance gt 0 then numactive=numactive+1;\
	\
	if category = 'bonds' then tot_bond = tot_bond + balance; \
	if category = 'equity' then tot_equity = tot_equity + balance; \
	if category = 'other' then tot_other = tot_other + balance; \
\
\
	\
	if last.cust_num then do;\
		tenure = '22OCT2008'd - frstdt;\
		num_category = (tot_bond>0)+(tot_equity>0)+(tot_other>0);\
		if totbal gt 0 then pct_bond = tot_bond/totbal; else pct_bond =  0;\
		if totbal gt 0 then risk_level = (tot_bond*1 + tot_equity*2 + tot_other*1)/totbal;\
			else risk_level = 0;\
		if age lt 18 then age_fill = 54.5; else age_fill = age;\
		\
	output;\
	end;\
	\
	run;\
	proc means; var age; where age gt 18; run;\
	proc freq; tables age; run;\
	\
	\
	/* exclude inactives*/\
	\
	data rollup_active;\
		set rollup;\
		where totbal gt 0;\
		\
		run;\
		\
		proc factor data=rollup_active rotate=varimax reorder out=fact nfactors=4;\
		var frstdt totbal numactive tot_bond tot_equity tot_other risk_level\
		 num_category age_fill;\
		 run;\
		\
	/* Initial Seeds */\
proc fastclus data=fact maxcluster=75 maxiter =1 mean=seed;\
var factor1-factor4;\
\
proc sort data=seed;\
		by descending _freq_;\
		\
proc freq data=seed; \
run;\
/* Cluster iteration  */\
proc fastclus data=fact maxclusters=6 drift seed=seed(obs=6) maxiter=100 converge=0 ;\
var factor1-factor4;\
\
\
proc fastclus data=fact maxclusters=7 drift seed=seed(obs=7) \
maxiter=100;  var factor1-factor4;\
run;\
	/*Locking in the Seeds */\
proc fastclus data=fact maxclusters=7 seed=seed(obs=7) \
maxiter=100 strict=1 mean=seed\
var factor1-factor4;\
\
/* Final Cluster Solution */\
proc fastclus data=fact maxclusters=7 seed=seed(obs=7) \
maxiter=0 replace=none out=scores;\
var factor1-factor4;\
\
run;}