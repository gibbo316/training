/*st004d01*/
proc ttest data=st092.phone_new_and_a plots(shownull)=interval;
   class team;
   var time;
   title "Two-Sample t-test Comparing New and A Team";
run;
