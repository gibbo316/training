/*************************************************
*
* Data Processing With SAS
* The Analytics Store
*
* Examples: Section 14 Programme 0
*
* Experimenting with keep and drop in DATA steps
*
**************************************************/

libname sasdata "C:\SASDATA";


/* Read in a CSV file and drop a number of varaibles */
data sasdata.mth_end_bal;
	infile 'C:\SAS TRAINING\Data & Code\Data\mth_end_bal_2.csv' DLM=',';
	input  Account OpenDate ddmmyy8. Type $ Balance;
	format OpenDate ddmmyy8. Balance dollar10.2;
	drop OpenDate Type;
run;

proc print data = sasdata.mth_end_bal;
run;

proc contents data = sasdata.mth_end_bal;
run;


/* Read in a CSV file and only a keep a small subset of varaibles */
data sasdata.mth_end_bal;
	infile 'C:\SAS TRAINING\Data & Code\Data\mth_end_bal_2.csv' DLM=',';
	input  Account OpenDate ddmmyy8. Type $ Balance;
	format OpenDate ddmmyy8. Balance dollar10.2;
	keep Account OpenDate;
run;

proc print data = sasdata.mth_end_bal;
run;

proc contents data = sasdata.mth_end_bal;
run;
