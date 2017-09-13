/*************************************************
*
* Data Processing With SAS
* The Analytics Store
*
* Examples: Section 18 Programme 3
*
* Performing dataset match merging
*
**************************************************/

/* Read in account details and customer details CSV files */
data sasdata.mrg_bal_mult;
	infile 'C:\SAS TRAINING\Data & Code\Data\mrg_bal_mult.csv' DLM=',' firstobs = 2;
	input  Account Date ddmmyy10. Balance;
	format Date ddmmyy10. Balance dollar10.2;
run;

proc sort data = sasdata.mrg_bal_mult out = sasdata.mrg_bal_mult_srt;
	by Account Date;
run;

proc print data = sasdata.mrg_bal_mult_srt;
run;

data sasdata.mrg_cust;
	infile 'enter_filepath/mrg_cust.csv' DLM=',' firstobs = 2;
	length LastName $ 32;
	input  Account LastName $ FirstName $ County $;
run;

proc sort data = sasdata.mrg_cust  out = sasdata.mrg_cust_srt;
	by Account;
run;

proc print data = sasdata.mrg_cust_srt;
run;


/* Perform a match merge of the two datasets using in statements to 
control the merge type */
data sasdata.mrg_bal_cust;
	merge sasdata.mrg_bal_mult_srt sasdata.mrg_cust_srt;
	by Account; 
run;

proc print data = sasdata.mrg_bal_cust;
run;


/* Perform a match merge of the two datasets using in statements to 
control the merge type */
data sasdata.mrg_bal_cust;
	merge sasdata.mrg_bal_mult_srt (in = in_bal) sasdata.mrg_cust_srt (in = in_cust);
	by Account;
	if (in_bal = 1) | (in_cust = 1) then output; 
run;

proc print data = sasdata.mrg_bal_cust;
run;

/* Perform a match merge of the two datasets using in statements to 
control the merge type */
data sasdata.mrg_bal_cust;
	merge sasdata.mrg_bal_mult_srt (in = in_bal) sasdata.mrg_cust_srt (in = in_cust);
	by Account;
	if (in_bal = 1) & (in_cust = 1) then output; 
run;

proc print data = sasdata.mrg_bal_cust;
run;

/* Perform a match merge of the two datasets using in statements to 
control the merge type */
data sasdata.mrg_bal_cust;
	merge sasdata.mrg_bal_mult_srt (in = in_bal) sasdata.mrg_cust_srt (in = in_cust);
	by Account;
	if (in_bal = 1) & (in_cust = 0) then output; 
run;

proc print data = sasdata.mrg_bal_cust;
run;

/* Perform a match merge of the two datasets using in statements to 
control the merge type */
data sasdata.mrg_bal_cust;
	merge sasdata.mrg_bal_mult_srt (in = in_bal) sasdata.mrg_cust_srt (in = in_cust);
	by Account;
	if (in_bal = 0) & (in_cust = 1) then output; 
run;

proc print data = sasdata.mrg_bal_cust;
run;

/* Perform a match merge of the two datasets using in statements to 
control the merge type */
data sasdata.mrg_bal_cust;
	merge sasdata.mrg_bal_mult_srt (in = in_bal) sasdata.mrg_cust_srt (in = in_cust);
	by Account;
	if (in_bal = 1) then output; 
run;

proc print data = sasdata.mrg_bal_cust;
run;

/* Perform a match merge of the two datasets using in statements to 
control the merge type */
data sasdata.mrg_bal_cust;
	merge sasdata.mrg_bal_mult_srt (in = in_bal) sasdata.mrg_cust_srt (in = in_cust);
	by Account;
	if (in_cust = 1) then output; 
run;

proc print data = sasdata.mrg_bal_cust;
run;
