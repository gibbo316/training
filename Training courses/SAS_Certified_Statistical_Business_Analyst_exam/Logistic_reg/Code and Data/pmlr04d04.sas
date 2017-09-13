proc npar1way edf data=scoval;
   class ins;
   var p_1;
   title "K-S Statistic for the Validation Data Set";
run;

