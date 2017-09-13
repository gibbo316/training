/*************************************************
*
* Data Processing With SAS
* The Analytics Store
*
* Examples: Section 13 Programme 0
*
* Experimenting with proc sort
*
**************************************************/

libname sasdata "C:\SASDATA";


/* Read in a CSV file and sort it by the Balance variable */
data sasdata.mth_end_bal;
	infile 'C:\SAS TRAINING\Data & Code\Data\mth_end_bal_2.csv' DLM=',';
	input  Account OpenDate ddmmyy8. Type $ Balance;
	format OpenDate ddmmyy8. Balance dollar10.2;
run;

proc sort data = sasdata.mth_end_bal 
				out = sasdata.mth_end_bal_srt;
	by Balance;
run;

proc print data = sasdata.mth_end_bal;
run;

proc print data = sasdata.mth_end_bal_srt;
run;


/* Sorting in descending order */
proc sort data = sasdata.mth_end_bal 
				out = sasdata.mth_end_bal_srt;
	by descending Balance;
run;

proc print data = sasdata.mth_end_bal_srt;
run;


/* Sorting by two varaibles */
proc sort data = sasdata.mth_end_bal 
				out = sasdata.mth_end_bal_srt;
	by Type descending Balance;
run;

proc print data = sasdata.mth_end_bal_srt;
run;


/* Sorting by three varaibles */
proc sort data = sasdata.mth_end_bal 
				out = sasdata.mth_end_bal_srt;
	by OpenDate Type descending Balance;
run;

proc print data = sasdata.mth_end_bal_srt;
run;
