/*************************************************
*
* Data Processing With SAS
* The Analytics Store
*
* Examples: Section 18 Programme 4
*
* Performing dataset match merging
*
**************************************************/

/* Read in Branch and customer details */
data sasdata.mrg_branch;
	length Address $ 20 Town $ 20 County $ 20;
	infile 'C:\SAS TRAINING\Data & Code\Data\mrg_branch.csv' DLM=',' firstobs = 2;
	input  Branch Address $ Town $ County $;
run;

proc sort data = sasdata.mrg_branch out = sasdata.mrg_branch_srt;
	by Branch;
run;

proc print data = sasdata.mrg_branch_srt;
run;

data sasdata.mrg_cust_br;
	infile 'C:\SAS TRAINING\Data & Code\Data\mrg_cust_br.csv' DLM=',' firstobs = 2;
	length LastName $ 32;
	input  Account LastName $ FirstName $ County $ Branch;
run;

proc sort data = sasdata.mrg_cust_br  out = sasdata.mrg_cust_br_srt;
	by Branch;
run;

proc print data = sasdata.mrg_cust_br_srt;
run;


/* Perform a match merge using a rename statement */
data sasdata.mrg_bal_cust;
	merge sasdata.mrg_cust_br_srt sasdata.mrg_branch_srt (rename = (County = BranchCounty));
	by Branch; 
run;

proc print data = sasdata.mrg_bal_cust;
run;
