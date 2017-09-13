/*************************************************
*
* Data Processing With SAS
* The Analytics Store
*
* Examples: Section 15 Programme 0
*
* Experimenting with proc means
*
**************************************************/

libname sasdata "C:\SASDATA";

/* Read in a CSV file containing athlete training data */
data sasdata.fast_mile_test;
	infile ' C:\SAS TRAINING\Data & Code\Data\fast_mile_test.csv' DLM=',' FIRSTOBS=2;
	input  Gender $ Sport $ Age  Weight Height Time ;
run;


/* Try out different versions of proc means reporting on different statistics  */
proc means data = sasdata.fast_mile_test;
run;

proc means data = sasdata.fast_mile_test maxdec = 3 mean stddev clm skew;
run;

proc means data = sasdata.fast_mile_test maxdec = 3 min max range p1 q1 median q3 p99;
run;


/* Try out different versions of proc means that use grouping (using class statements) and analysis options */
proc means data = sasdata.fast_mile_test maxdec = 3 mean stddev clm;
	var Age Height Time;
	class Gender;
run;

proc means data = sasdata.fast_mile_test maxdec = 3 mean stddev clm;
	var Time;
	class Sport;
run;


/* Try out different versions of proc means that use grouping (using by statements) and analysis options */
proc sort data = sasdata.fast_mile_test out=sasdata.fast_mile_test_srt;
	by Sport;
run;

proc means data = sasdata.fast_mile_test_srt maxdec = 3 mean stddev;
	var  Weight Time;
	by Sport;
run;

proc means data = sasdata.fast_mile_test_srt maxdec = 3 mean stddev missing;
	var Weight Time;
	class Sport;
run;


/* Use proc means to generate a dataset rather than reporting */
proc means data = sasdata.fast_mile_test_srt noprint;
	var Weight Time;
	class Gender;
	output out = sasdata.fast_mile_test_means 
					mean = MnWeight MnTime
					median = MdWeight MdTime;
run;

proc print data = sasdata.fast_mile_test_means;
run;


/* Use proc means to generate a dataset and use autonaming */
proc means data = sasdata.fast_mile_test_srt maxdec = 3 NOPRINT;
	var Weight Time;
	class Gender;
	output out = sasdata.fast_mile_test_means mean =  median = /autoname;
run;

proc print data = sasdata.fast_mile_test_means;
run;


/* Use proc summary instead of proc means */	
proc summary data = sasdata.fast_mile_test_srt maxdec = 3 print;
	var Weight Time;
	class Gender;
	output out = sasdata.fast_mile_test_means mean =  median = /autoname;
run;

proc summary data = sasdata.fast_mile_test_srt maxdec = 3 mean median print;
	var Weight Time;
	output out = sasdata.fast_mile_test_means mean =  median = /autoname;
run;

