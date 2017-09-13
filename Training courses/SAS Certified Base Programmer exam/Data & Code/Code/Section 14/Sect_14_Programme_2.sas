/*************************************************
*
* Data Processing With SAS
* The Analytics Store
*
* Examples: Section 14 Programme 2
*
* Creating new variables in DATA steps
*
**************************************************/


/* Define a custom format so that we can print pound symbols */ 
proc format;
  picture pound LOW-<0='000,000,000.00' (PREFIX='-£')
                 0-HIGH='000,000,000.00' (PREFIX='£');
run;


/* In a DATA step read in a CSV file and create a new variable 
that converts a balance from dollars in sterling */ 
data sasdata.mth_end_bal;
	infile 'C:\SAS TRAINING\Data & Code\Data\mth_end_bal_2.csv' DLM=',';
	input  Account OpenDate ddmmyy8. 
							Type $ Balance;
	GBP_Balance = Balance * 0.6499 ;
	format OpenDate ddmmyy8. Balance dollar10.2 
						GBP_Balance pound10.2;
run;

proc print data = sasdata.mth_end_bal;
run;

proc contents data = sasdata.mth_end_bal;
run;


/* In a DATA step read in a CSV file and create a new variable 
that calculates an age from a date varaible */ 
data sasdata.mth_end_bal;
	infile 'C:\SAS TRAINING\Data & Code\Datamth_end_bal_2.csv' DLM=',';
	input  Account OpenDate ddmmyy8. 
							Type $ Balance;
	Age  = (Today() - OpenDate);	
	format OpenDate ddmmyy8. Balance dollar10.2 Age comma10.0;
run;
	
proc print data = sasdata.mth_end_bal;
run;

proc contents data = sasdata.mth_end_bal;
run;


/* In a DATA step read in a CSV file and create a new variable 
that calculates an age from a date varaible and converts this 
to years */
data sasdata.mth_end_bal;
	infile 'C:\SAS TRAINING\Data & Code\Datamth_end_bal_2.csv' DLM=',';
	input  Account OpenDate ddmmyy8. 
							Type $ Balance;
	Age  = (Today() - OpenDate)/365;	
	format OpenDate ddmmyy8. Balance dollar10.2 Age comma10.2;
run;

proc print data = sasdata.mth_end_bal;
run;

proc contents data = sasdata.mth_end_bal;
run;
