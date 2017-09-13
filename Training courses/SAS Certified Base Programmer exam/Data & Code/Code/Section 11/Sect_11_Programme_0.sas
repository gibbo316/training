/*************************************************
*
* Data Processing With SAS
* The Analytics Store
*
* Examples: Section 11 Programme 0
*
* Playing around with formats and informats
*
**************************************************/

/* Define a very simple numeric dataset */
data format_test;
	input number date;
	datalines;
1045.67 12345
5678 0
-5678.12 0
;
run;

/* Print the simple datset with lots of different formats */
proc print data = format_test;
	format number 9.0;
	format date ddmmyy10.;
	
	
	
	*format date ddmmyy10.;
	*format number comma9.2;
	
	*format date ddmmyy10.;
	*format number dollar8.2;

	*format date ddmmyy10.;
	*format number percent9.2;

	*format date date7.;
	*format number percent9.2;

	*format date date9.;
	*format number comma9.0;
run;


/* Play around with reading in values with the percent informat */



	