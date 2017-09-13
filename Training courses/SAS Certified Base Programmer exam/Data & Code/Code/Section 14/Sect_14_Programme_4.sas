/*************************************************
*
* Data Processing With SAS
* The Analytics Store
*
* Examples: Section 14 Programme 4
*
* Using IF - THEN and DO - END statements in SAS
*
**************************************************/


/* Read in a CSV file and use if - then statements to 
conidtionally create a new varaible */ 
data sasdata.mth_end_bal;
	infile 'C:\SAS TRAINING\Data & Code\Data\mth_end_bal_2.csv' DLM=',';
	input  Account OpenDate ddmmyy8. 
							Type $ Balance;
	if Type = 'Current' then
		Interest = Balance * 0.0002;
	else 
		Interest = Balance * 0.001;
		
	format OpenDate ddmmyy8. Balance dollar10.2 Interest dollar10.2;
run;

proc print data = sasdata.mth_end_bal;
run;

proc contents data = sasdata.mth_end_bal;
run;


/* A better version that uses nested if else sdttatements */
data sasdata.mth_end_bal;
	infile 'C:\SAS TRAINING\Data & Code\Data\mth_end_bal_2.csv' DLM=',';
	input  Account OpenDate ddmmyy8. 
							Type $ Balance;
	if Type = 'Current' then
		Interest = Balance * 0.0002;
	else if Type = 'Cashsave' then
		Interest = Balance * 0.001;
		
	format OpenDate ddmmyy8. Balance dollar10.2 Interest dollar10.2;
run;

proc print data = sasdata.mth_end_bal;
run;

proc contents data = sasdata.mth_end_bal;
run;


/* A version of the previous programme that utilises DO - END blocks 
to perform multiple statements within an IF - THEN statement */
data sasdata.mth_end_bal;
	infile 'C:\SAS TRAINING\Data & Code\Data\mth_end_bal_2.csv' DLM=',';
	input  Account OpenDate ddmmyy8. 
							Type $ Balance;
	if Type = 'Current' then
		DO;
			Interest = Balance * 0.0002;
			New_Balance = Balance + Interest - 0.10;
		END;
	else if Type = 'Cashsave' then
		DO;
			Interest = Balance * 0.001;
			New_Balance = Balance + Interest;
		END;
		
	format OpenDate ddmmyy8. Balance dollar10.2 Interest dollar10.2 New_Balance dollar10.2;
run;

proc print data = sasdata.mth_end_bal;
run;

proc contents data = sasdata.mth_end_bal;
run;
