/*st002s03.sas*/
proc means data=st092.NormTemp maxdec=2
           n mean stderr clm;
   var BodyTemp;
   title '95% Confidence Interval for Body Temp';
run;
