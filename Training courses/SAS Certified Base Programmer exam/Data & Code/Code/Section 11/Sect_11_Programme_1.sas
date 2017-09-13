/*************************************************
*
* Data Processing With SAS
* The Analytics Store
*
* Examples: Section 11 Programme 1
*
* Experimeting with DATA steps
*
**************************************************/
libname sasdata 'c:\SASDATA';

/* Read in and print a simple space delimited file */ 
data sasdata.mth_end_bal;
	infile 'C:\SAS TRAINING\Data & Code\Data\mth_end_bal_1.txt';
	input  Account OpenDate Type Balance;
run;

proc print data = sasdata.mth_end_bal;
run;


/* Correct the DATA step so that Type is a character variable */
data sasdata.mth_end_bal;
	infile ' C:\SAS TRAINING\Data & Code\Data\mth_end_bal_1.txt';
	input  Account OpenDate Type $ Balance;
run;

proc print data = sasdata.mth_end_bal;
run;


/* Correct the DATA step so that it uses a data informat */
data sasdata.mth_end_bal;
	infile 'C:\SAS TRAINING\Data & Code\Data\mth_end_bal_1.txt';
	input  Account OpenDate ddmmyy8. Type $ Balance;
run;

proc print data = sasdata.mth_end_bal;
run;


/* Correct the DATA step so that it uses correct output data formats */
data sasdata.mth_end_bal;
	infile 'C:\SAS TRAINING\Data & Code\Data\mth_end_bal_1.txt';
	input  Account OpenDate ddmmyy8. Type $ Balance;
	format OpenDate ddmmyy8. Balance dollar10.2;
run;

proc print data = sasdata.mth_end_bal;
run;


/* Read in the same dataset as a comma separated file */
data sasdata.mth_end_bal;
	infile ' C:\SAS TRAINING\Data & Code\Data\mth_end_bal_2.csv' DLM=',';
	input  Account OpenDate ddmmyy8. Type $ Balance;
	format OpenDate ddmmyy8. Balance dollar10.2;
	
run;

proc print data = sasdata.mth_end_bal;
run;

proc contents data = sasdata.mth_end_bal;
run;
