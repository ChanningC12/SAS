TITLE "Imported from CSV data set";
PROC IMPORT DATAFILE="/sscc/datasets/imc498/case12.csv" DBMS=CSV REPLACE OUT=casecsv;
RUN;
PROC CONTENTS DATA=casecsv;
RUN;