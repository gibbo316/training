/*************************************************
*
* Data Processing With SAS
* The Analytics Store
*
* Examples: Section 18 Programme 1
*
* Performing dataset interleaving
*
**************************************************/

/* Read in three CSV files with account balances over multiple months 
sorting each by Trans_Date*/
data sasdata.trans_lst_100332;
	infile 'C:\SAS TRAINING\Data & Code\Data\transaction_list_multiple_100332.csv' DLM=',' firstobs=2;
	input  Account Trans_Date ddmmyy8. Amount;
	format Trans_Date ddmmyy8. Amount dollar10.2;
run;

proc sort data=sasdata.trans_lst_100332 out = sasdata.trans_lst_100332_srt;
	by Trans_Date;
run;

proc print data=sasdata.trans_lst_100332;
run;

data sasdata.trans_lst_100475;
	infile 'C:\SAS TRAINING\Data & Code\Data\transaction_list_multiple_100475.csv' DLM=',' firstobs=2;
	input  Account Trans_Date ddmmyy8. Amount;
	format Trans_Date ddmmyy8. Amount dollar10.2;
run;

proc sort data=sasdata.trans_lst_100475 out = sasdata.trans_lst_100475_srt;
	by Trans_Date;
run;

proc print data=sasdata.trans_lst_100475;
run;

data sasdata.trans_lst_100879;
	infile 'C:\SAS TRAINING\Data & Code\Data\transaction_list_multiple_100879.csv' DLM=',' firstobs=2;
	input  Account Trans_Date ddmmyy8. Amount Type $;
	format Trans_Date ddmmyy8. Amount dollar10.2;
run;

proc sort data=sasdata.trans_lst_100879 out = sasdata.trans_lst_100879_srt;
	by Trans_Date;
run;

proc print data=sasdata.trans_lst_100879;
run;


/* Interleave two datasets */ 
data sasdata.trans_lst_full_inter;
	set sasdata.trans_lst_100332_srt sasdata.trans_lst_100475_srt;
	by Trans_Date; 
run;

proc print data=sasdata.trans_lst_full_inter;
run;


/* Interleave three datasets */ 
data sasdata.trans_lst_full_inter;
	set sasdata.trans_lst_100332_srt sasdata.trans_lst_100475_srt sasdata.trans_lst_100879_srt;
	by Trans_Date; 
run;

proc print data=sasdata.trans_lst_full_inter;
run;
