/*st002d02*/
ods graphics;
ods select Moments Quantiles ExtremeObs Histogram ProbPlot;
proc univariate data=st092.phone_new;
    var time;
    histogram time / normal(mu=est sigma=est);
    inset skewness kurtosis / position=ne;
    probplot time / normal(mu=est sigma=est);
    inset skewness kurtosis;
    title 'Descriptive Statistics Using PROC UNIVARIATE';
run;

/*st002d02.sas*/ 
ods graphics on;
proc sgplot data=st092.phone_new;
    refline 60 / axis=y lineattrs=(color=blue);
    vbox time ;
      title "Box and Whisker Plot of Time";
run;
ods graphics off;
