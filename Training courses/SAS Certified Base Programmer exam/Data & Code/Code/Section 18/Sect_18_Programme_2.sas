/*************************************************
*
* Data Processing With SAS
* The Analytics Store
*
* Examples: Section 18 Programme 2
*
* Performing dataset merging
*
**************************************************/

data sasdata.mrg_bal;
	infile 'C:\SAS TRAINING\Data & Code\Data\mrg_bal.csv' DLM=',' firstobs = 2;
	input  Account Date ddmmyy10. Balance;
	format Date ddmmyy10. Balance dollar10.2;
run;

proc sort data = sasdata.mrg_bal out = sasdata.mrg_bal_srt;
	by Account;
run;

proc print data = sasdata.mrg_bal_srt;
run;

data sasdata.mrg_cust;
	infile 'C:\SAS TRAINING\Data & Code\Data\mrg_cust.csv' DLM=',' firstobs = 2;
	length LastName $ 32;
	input  Account LastName $ FirstName $ County $;
run;

proc sort data = sasdata.mrg_cust  out = sasdata.mrg_cust_srt;
	by Account;
run;

proc print data = sasdata.mrg_cust_srt;
run;

data sasdata.mrg_bal_cust;
	merge sasdata.mrg_bal_srt sasdata.mrg_cust_srt;
	by Account;
run;

proc print data = sasdata.mrg_bal_cust;
run;

data sasdata.mrg_bal_cust;
	merge sasdata.mrg_bal_srt (in = in_bal) sasdata.mrg_cust_srt (in = in_cust);
	by Account;
	if (in_bal = 1) | (in_cust = 1) then output; 
run;

proc print data = sasdata.mrg_bal_cust;
run;
