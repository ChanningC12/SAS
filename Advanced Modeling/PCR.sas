proc factor data = pcr.m255_sas fuzz=.3 reorder corr scree residuals method = principal;
var item13 item14 item15 item16 item17 item18 item19 item20 item21 item22 item23 item24 ;
run;