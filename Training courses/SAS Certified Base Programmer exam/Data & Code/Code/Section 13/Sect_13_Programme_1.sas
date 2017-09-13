/*************************************************
*
* Data Processing With SAS
* The Analytics Store
*
* Examples: Section 13 Programme 1
*
* Experimenting with proc freq
*
**************************************************/

/* Load some CSV files */
data sasdata.mth_end_bal_ext;
	infile 'C:\SAS TRAINING\Data & Code\Data\mth_end_bal_ext.csv' DLM=',';
	input Account Month ddmmyy10. Type $	Balance;
	format Month ddmmyy10. Balance 11.2;
run;

data sasdata.mth_end_bal;
	infile 'Enter File path\mth_end_bal_2.csv' DLM=',';
	input  Account OpenDate ddmmyy8. Type $ Balance;
	format OpenDate ddmmyy8. Balance dollar10.2;
run;


/* Print a dataset */
proc print data = sasdata.mth_end_bal;
run;


/* sort the datset */
proc sort data = sasdata.mth_end_bal;
 by Type;
run;


/* Print a dataset grouping by a by-variable and putting reports 
on different pages */
proc print data = sasdata.mth_end_bal;
	by Type;
	pageby Type;
run;


/* Print a dataset including a total of a selected varaible */
proc print data = sasdata.mth_end_bal;
	sum Balance;
run;


/* Print a dataset including a total of a selected varaible and 
groups with sub-totals*/
proc print data = sasdata.mth_end_bal;
	by Type;
	sumby Type;
	sum balance;
run;

proc sort data = sasdata.mth_end_bal 
				out = sasdata.mth_end_typ_srt;
	by Type;
run;

proc print data = sasdata.mth_end_typ_srt;
	by Type;
	sum balance;
run;

proc print data = sasdata.mth_end_typ_srt;
	by Type;
	sum balance;
    id Type;
run;

proc print data = sasdata.mth_end_typ_srt;
	var Account Type Balance;
	by Type;
	sum balance;
    id Type;
run;








