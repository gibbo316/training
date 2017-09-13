/*************************************************
*
* Data Processing With SAS
* The Analytics Store
*
* Examples: Section 15 Programme 1
*
* Experimenting with proc tabulate
*
**************************************************/

/* Read in a CSV file containing athlete training data */
data sasdata.fast_mile_test;
	infile 'C:\SAS TRAINING\Data & Code\Data\fast_mile_test.csv' DLM=',' FIRSTOBS=2;
	input  Gender $ Sport $ Age  Weight Height Time ;
run;


/* Genreate a simple table showing Gender counts broken down by Sport */
proc tabulate data = sasdata.fast_mile_test;
	class Sport Gender;
	table Sport, Gender;
run;


/* Genreate a table showing Time, Weight and Height sums broken down by sport */
proc tabulate data = sasdata.fast_mile_test;
	class Sport;
	var Time Weight Height;
	table Sport, Time Weight Height;
run;


/* Genreate a  table showing Time, Weight and Height means broken down by sport */
proc tabulate data = sasdata.fast_mile_test;
	class Sport;
	var Time Weight Height;
	table Sport, Time*mean Height*mean Weight*mean;
run;


/* Genreate a  table showing Weight and Height min and max broken down by Sport and Gender */
proc tabulate data = sasdata.fast_mile_test;
	class Sport Gender;
	var Weight Height;
	table Sport*Gender, Height*(min max) Weight*(min max);
run;


/* Genreate more adnvanced version of the previous table */
proc tabulate data = sasdata.fast_mile_test;
	class Sport Gender;
	var Time Weight Height;
	table  Sport='Olympic Discipline'*(Gender all) all, n='Athlete Counts'*f=3.0 Height='Athlete Height'*(min max) Weight='Athlete Weight'*(min max) /box = 'Athletic performance by gender & discipline';
run;
