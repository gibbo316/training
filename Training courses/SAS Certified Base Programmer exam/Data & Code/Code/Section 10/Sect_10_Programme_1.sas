/*************************************************
*
* Data Processing With SAS
* The Analytics Store
*
* Examples: Section 10 Programme 1
*
* Experimenting with proc contents
*
**************************************************/

/* Print the contents of a SAS dataset */
proc contents data=sashelp.class;
run;

/* Print the contents of a SAS library, supressing output */
proc contents data=sashelp._ALL_ nods;
run;
