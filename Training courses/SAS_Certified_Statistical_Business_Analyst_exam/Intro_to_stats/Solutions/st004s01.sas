/*st004s01.sas*/
ods graphics on;
proc ttest data=st092.ads plots(shownull)=interval;
   class ad;
   var sales;
   title "Two-Sample t-test Comparing Media Types on Sales";
run;
