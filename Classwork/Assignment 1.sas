data assignment;
	infile "/sscc/datasets/imc498/airmiles/commtrans.txt"
	firstobs=2 dsd dlm='09'x termstr=crlf;
	informat sponsor_code $4. date yymmdd10.
		  issuance_offer_type_desc $20. 
	   	  issuance_offer_type_category $6.;;
	input COLECTOR_KEY COLLECTOR_NUMBER 
date SPONSOR_CODE $ SPONSOR_NAME $ ISSUANCE_OFFER_TYPE_DESC $ 
ISSUANCE_OFFER_TYPE_CATEGORY $ TXN_CNT AM_ISSUED;
	format yymmdd10.;
	run;

proc print data=assignment(obs=10);
run;
