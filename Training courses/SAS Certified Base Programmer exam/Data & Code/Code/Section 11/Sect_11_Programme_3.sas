/*************************************************
*
* Data Processing With SAS
* The Analytics Store
*
* Examples: Section 11 Programme 3
*
* Using proc import
*
**************************************************/

libname sasdata "C:\SASDATA";

/* import a CSV file using proc import */
proc import out=sasdata.mth_end_bal_3 datafile= 'C:\SAS TRAINING\Data & Code\Data\mth_end_bal_3.csv' replace;
	getnames = yes;
run;

proc contents data = sasdata.mth_end_bal_3;
run;

proc print data = sasdata.mth_end_bal_3;
run;


/* import an Excel file using proc import */
proc import out=sasdata.customers datafile = 'enter_tile_path/customer_list.xls' 
             dbms=excel replace;
     sheet="PublishedVersion";
     getnames=yes; 
run;

proc contents data = sasdata.customers;
run;

proc print data = sasdata.customers;
run;



