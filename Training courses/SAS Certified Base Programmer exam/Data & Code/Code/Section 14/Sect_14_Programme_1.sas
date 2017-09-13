/*************************************************
*
* Data Processing With SAS
* The Analytics Store
*
* Examples: Section 14 Programme 1
*
* Playing with if and where statements in DATA steps
*
**************************************************/

libname sasdata "enter_file_path";


/* Read in a simple CSV file with some if statement filtering*/
data sasdata.mth_end_bal_filter;
	infile 'enter_file_path/mth_end_bal_2.csv' DLM=',';
	input  Account OpenDate ddmmyy8. Type $ Balance;
	format OpenDate ddmmyy8. Balance dollar10.2;
	* if (Balance > 500) & (OpenDate > '01jan2000'd);
	* if Balance IN (3391.29, 7038.79, 9808.87);
	* if (Type = 'Current') & (Balance > 5000);
	* if Balance > 1000;
	* if Balance < 1000;
	* if Name ^= .;
	* if Type ^= 'Cashsave';
	* if OpenDate > '01jan2000'd;
	if (Type = 'Cashsave') & (Balance > 5000);
run;

proc print data = sasdata.mth_end_bal_filter;
run;

proc contents data = sasdata.mth_end_bal_filter;
run;


/* Read in a simple CSV file and then perform where filtering 
with it in a second DATA step */ 
data sasdata.customers;
	infile 'enter_file_path/customer_list.csv' DLM=',';
	length LastName $ 32;
	informat Account 32.;
	input  Account OpenDate ddmmyy8. LastName $ FirstName $ County $;
	format OpenDate ddmmyy8.;
run;

data sasdata.customers_filtered;
	set sasdata.customers;
	*where OpenDate between '01jan2001'd and '31dec2001'd;
	*where FirstName like 'Br_an';
	where FirstName =* 'Shane';
	*where FirstName ? 'ian';
	*where Account ? '77';
	*where County IN('Dublin' 'Kildare');
run;

proc print data = sasdata.customers;
run;

proc print data = sasdata.customers_filtered;
run;