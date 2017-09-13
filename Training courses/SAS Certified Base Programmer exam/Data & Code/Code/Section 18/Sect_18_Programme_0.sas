/*************************************************
*
* Data Processing With SAS
* The Analytics Store
*
* Examples: Section 18 Programme 0
*
* Performing dataset stacking
*
**************************************************/
libname sasdata "C:\SASDATA";

/* Read in three CSV files with account balances over multiple months */
data sasdata.trans_lst_100332;
	infile 'C:\SAS TRAINING\Data & Code\Data\transaction_list_multiple_100332.csv' DLM=',' firstobs=2;
	input  Account Trans_Date ddmmyy8. Amount;
	format Trans_Date ddmmyy8. Amount dollar10.2;
run;

proc print data=sasdata.trans_lst_100332;
run;

data sasdata.trans_lst_100475;
	infile 'C:\SAS TRAINING\Data & Code\Data\transaction_list_multiple_100475.csv' DLM=',' firstobs=2;
	input  Account Trans_Date ddmmyy8. Amount;
	format Trans_Date ddmmyy8. Amount dollar10.2;
run;

proc print data=sasdata.trans_lst_100475;
run;

data sasdata.trans_lst_100879;
	infile 'C:\SAS TRAINING\Data & Code\Data\transaction_list_multiple_100879.csv' DLM=',' firstobs=2;
	input  Account Trans_Date ddmmyy8. Amount Type $;
	format Trans_Date ddmmyy8. Amount dollar10.2;
run;

proc print data=sasdata.trans_lst_100879;
run;


/* Stack two datasets */ 
data sasdata.trans_lst_full;
	set sasdata.trans_lst_100332 sasdata.trans_lst_100475; 
run;

proc print data=sasdata.trans_lst_full;
run;


/* Stack three datasets */
data sasdata.trans_lst_full;
	set sasdata.trans_lst_100332 sasdata.trans_lst_100475 sasdata.trans_lst_100879; 
run;

proc print data=sasdata.trans_lst_full;
run;
