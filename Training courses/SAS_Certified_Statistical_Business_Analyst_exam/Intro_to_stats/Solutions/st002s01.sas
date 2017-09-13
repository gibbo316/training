/*st002s01.sas*/
proc means data=st092.normtemp printalltypes 
			maxdec=2 fw=10
			n mean std q1 q3 qrange;
	var BodyTemp;
	class Gender;
	title 'Selected Descriptive Statistics for Body Temp';
run;
