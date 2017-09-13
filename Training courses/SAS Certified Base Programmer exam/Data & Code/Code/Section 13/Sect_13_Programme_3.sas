/*************************************************
*
* Data Processing With SAS
* The Analytics Store
*
* Examples: Section 13 Programme 3
*
* Experimenting with proc report
*
**************************************************/
/** simple proc report**/
Proc report data = sasdata.MTH_END_BAL;
run;

/** using the columns statment to select colums**/
Proc report data = sasdata.MTH_END_BAL;
	column Type Balance;
run;

/** using the define statment to enhance output **/
Proc report data = sasdata.MTH_END_BAL;
	column Type Balance;
	define Balance / format=dollar10.0 center;
	define Type / order;
run;

/** Creating summary reports **/
Proc report data = sasdata.MTH_END_BAL;
	column Type Balance;
	define Balance / format=dollar10.0 center;
	define Type / group;
run;