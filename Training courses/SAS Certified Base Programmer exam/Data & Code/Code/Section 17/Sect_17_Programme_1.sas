/*************************************************
*
* Data Processing With SAS
* The Analytics Store
*
* Examples: Section 17 Programme 1
*
* Looking back using the lag statement
*
**************************************************/


/* Read in a CSV file */
data sasdata.cust_bal_hist;
	infile 'C:\SAS TRAINING\Data & Code\Data\cust_bal_hist.csv' DLM=','  FIRSTOBS=2;
	input  Account Month ddmmyy10. Balance;
	format Month ddmmyy8. Balance dollar15.2;
run;

/* Using a lag statement calculate the change in balance from one month to the next */
proc sort data = sasdata.cust_bal_hist out = sasdata.cust_bal_hist_srt;
	by Month;
run;

data sasdata.cust_bal_hist_srt;
	set sasdata.cust_bal_hist_srt;
	drop Last_Month_Bal;
	Last_Month_Bal = lag(Balance);
	Difference = Balance - Last_Month_Bal;
	format Difference dollar15.2;
run;

proc print data = sasdata.cust_bal_hist_srt;
run;


/* Use a lage statement to claculate a moving average of the last 4 balances */
data sasdata.cust_bal_hist_srt;
	set sasdata.cust_bal_hist_srt;
	Moving_Average = mean(Balance, lag1(Balance), lag2(Balance), , lag3(Balance));
	format Moving_Average dollar15.2;
run;

proc print data = sasdata.cust_bal_hist_srt;
run;
