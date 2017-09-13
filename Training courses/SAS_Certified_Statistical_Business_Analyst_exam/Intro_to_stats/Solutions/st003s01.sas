/*st003s01.sas*/
ods graphics on;
proc ttest data=st092.normtemp h0=98.6;
	var bodytemp;
	title "Testing the true mean of body-temp is 98.6";
run;
