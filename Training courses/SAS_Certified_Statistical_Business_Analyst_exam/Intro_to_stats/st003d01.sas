/*st003d01*/
ods graphics on;
proc ttest data=st092.phone_new h0=60 plots(shownull)=interval;
	var time;
title 'One-Sample t-test – testing the mean time is 60 seconds';
run;
ods graphics off;
