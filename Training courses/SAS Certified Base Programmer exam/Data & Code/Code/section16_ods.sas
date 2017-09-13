libname lib 'C:\Users\shane.mc.carthy\Documents\MyTraining\SAS\SAS Certified Base Programmer exam\Data & Code\Data';


/*basic html example*/
ods html; 
proc freq data=lib.fast_mile_test;
table sport; 
run;

proc tabulate data=lib.fast_mile_test; 
class sport;
var time weight height; 
table sport, time weight height; 
run; 
ods html close;

/*Using ods to output html file*/

ods html file='C:\Users\shane.mc.carthy\Dropbox\Dropbox\SAS_results\_temp.html'; 
proc freq data=lib.fast_mile_test;
table sport; 
run;

proc tabulate data=lib.fast_mile_test; 
class sport;
var time weight height; 
table sport, time weight height; 
run; 
ods html close;


/*ODS extensions example*/

ods listing close; 
ods html 
		body='C:\Users\shane.mc.carthy\Dropbox\Dropbox\SAS_results\body.html'
		contents= 'C:\Users\shane.mc.carthy\Dropbox\Dropbox\SAS_results\contents.html'
		frame='C:\Users\shane.mc.carthy\Dropbox\Dropbox\SAS_results\frame.html'
		style= brick;

		proc freq data=lib.fast_mile_test;
		table sport; 
		run;

		proc tabulate data=lib.fast_mile_test; 
		class sport;
		var time weight height; 
		table sport, time weight height; 
		run;
ods html close; 
ods listing; 

/*ODS PDF example */

ods pdf file='C:\Users\shane.mc.carthy\Dropbox\Dropbox\SAS_results\temp.pdf'; 

		proc freq data=lib.fast_mile_test;
		table sport; 
		run;

		proc tabulate data=lib.fast_mile_test; 
		class sport;
		var time weight height; 
		table sport, time weight height; 
		run;
ods pdf close;

proc print data=lib.fast_mile_test; 
run;

/*Proc format example*/
proc format; 
value $sex 'Male' = 'Lad'
			  'Female'='Lass'; 
run;

data temp; 
set lib.fast_mile_test; 
format gender sex.; 
run;




