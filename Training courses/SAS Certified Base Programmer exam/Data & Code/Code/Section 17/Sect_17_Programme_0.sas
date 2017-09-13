/*************************************************
*
* Data Processing With SAS
* The Analytics Store
*
* Examples: Section 17 Programme 0
*
* Accumulating totals using retain statements and sum statements
*
**************************************************/

/* Read in a datset and sort it by a data varaible */
data sasdata.trans_lst;
	infile 'C:\SAS TRAINING\Data & Code\Data\transaction_list.csv' DLM=',';
	input  Account Trans_Date ddmmyy8. Amount;
	format Trans_Date ddmmyy8. Amount dollar10.2;
run;

proc sort data = sasdata.trans_lst out = sasdata.trans_lst_srt;
	by Trans_Date;
run;

/* Use a retain statement to accumulate a running total */
data sasdata.trans_lst_srt_ttl;
	set sasdata.trans_lst_srt;
	retain Running_Total 0;
	Running_Total = Running_Total + Amount;
	format Running_Total dollar10.2;
run;

proc print data = sasdata.trans_lst_srt_ttl;
run;


/* Accumulate the same running total but using a sum statement insteaed of a retain statement */
data sasdata.trans_lst_srt_ttl;
	set sasdata.trans_lst_srt;
	Running_Total + Amount;
	format Running_Total dollar10.2;
run;

proc print data = sasdata.trans_lst_srt_ttl;
run;
