/*************************************************
*
* Data Processing With SAS
* The Analytics Store
*
* Examples: Section 13 Programme 2
*
* Experimenting with proc freq
*
**************************************************/

/* Load a CSV file */
data sasdata.mth_end_bal_ext;
	infile 'C:\SAS TRAINING\Data & Code\Data\mth_end_bal_ext.csv' DLM=',';
	input Account Month ddmmyy10. Type $	Balance;
	format Month ddmmyy10. Balance 11.2;
run;

/* Create a very simple frequency report */
proc freq data = sasdata.mth_end_bal;
 table Type;
run;


/* Create an overdrawn flag in the customer balances dataset to use 
in grouped fequency reports */
data sasdata.mth_end_bal_ext;
	set sasdata.mth_end_bal_ext;
	if Balance < 0 then Overdrawn_fl = 1;
	else Overdrawn_fl = 0;
run;


/* Create a grouped fequency reports */
proc freq data = sasdata.mth_end_bal_ext;
	table   Month * Overdrawn_fl;
run;


/* Create a grouped fequency report including Chi squared analysis */
proc freq data = sasdata.mth_end_bal_ext;
 table   Month * Overdrawn_fl / chisq ;
run;


/* Create a grouped fequency report including Chi squared analysis 
and using display options */
proc freq data = sasdata.mth_end_bal_ext;
 table   Month * Overdrawn_fl / chisq nopercent norow nocol;
run;


/* Create a grouped fequency report and output the result as a SAS 
dataset to allow further processing */
proc freq data = sasdata.mth_end_bal_ext;
 table   Month * Overdrawn_fl / chisq measures;
 output out=ChiSqData n nmiss pchi;
run;
