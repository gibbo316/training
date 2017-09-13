/*st002s02.sas*/
ods graphics;
proc univariate data=st092.NormTemp noprint;
   var BodyTemp HeartRate;
   histogram BodyTemp HeartRate / normal(mu=est sigma=est 
                                         noprint);
   inset min max skewness kurtosis / position=ne;
   probplot BodyTemp HeartRate / normal(mu=est sigma=est);
   inset min max skewness kurtosis;
   title 'Descriptive Statistics Using PROC UNIVARIATE';
run;

ods graphics on;
proc sgplot data=st092.NormTemp;
   refline 98.6 / axis=y lineattrs=(color=blue);
   vbox BodyTemp / datalabel=ID;
   format ID 3.;
   title "Box and Whisker Plot of Body Temps";
run;
proc sgplot data=st092.NormTemp;
   vbox HeartRate / datalabel=ID;
   format ID 3.;
   title "Box and Whisker Plot of Heart Rate";
run;
