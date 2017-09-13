/*************************************************
*
* Data Processing With SAS
* The Analytics Store
*
* Examples: Section 14 Programme 3
*
* Text Processing
*
**************************************************/

/* Read in a csv file */
proc import out=sasdata.customer_list datafile= 'C:\SAS TRAINING\Data & Code\Data\customer_list.csv' replace;
	getnames = yes;
run;

data sasdata.customer_list;
	set sasdata.customer_list;

	/* Remove leading or trailing blanks */
	Company_Name = STRIP(Company_Name);

	/* Remove leading or trailing blanks */
	Company_Name = COMPBL(Company_Name);

	/* Convert company names to propoer case */
	Company_Name = PROPCASE(Company_Name);

	/* Replace "Gmbh" with Ltd */
	Company_Name = TRANSTRN(Company_Name, "Gmbh", "Ltd");
	
	
	/* Split owner name into first and last names - this assumes one of each */
	First_Name = SCAN(Owner_Name, 1, " ");
	Last_Name = SCAN(Owner_Name, 2, " ");
	
run;

proc print data=sasdata.customer_list;
run;
