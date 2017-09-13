/*st002d01.sas*/
options nodate nonumber ls=95 ps=80;
proc print data=st092.phone_new (obs=10);
    title 'Listing of the Phone_new Data Set';
run;


/*st002d01.sas*/
proc means data=st092.phone_new maxdec=2 fw=10;
    var time;
    title 'Descriptive Statistics Using PROC MEANS';
run;


/*st002d01.sas*/
proc means data=st092.phone_new
           maxdec=2 fw=10
           n mean median std var q1 q3;

/*where Var = Variance, q1 = lower quartile and q3 = upper quartile */
     var time;
    title 'Selected Descriptive Statistics for Time to Answer the Phone';
run;




/*st002d02*/
ods graphics;
ods select Moments Quantiles ExtremeObs Histogram ProbPlot;
proc univariate data=st092.phone_new;
    var time;
    histogram time / normal(mu=est sigma=est);
    inset skewness kurtosis / position=ne;

    probplot time / normal(mu=est sigma=est);
    inset skewness kurtosis;

/*	insert just puts a box with skewness kurtosis into the main plot*/

    title 'Descriptive Statistics Using PROC UNIVARIATE';
run;


/*st002d02.sas*/ 
ods graphics on;
proc sgplot data=st092.phone_new;

/*the refline function just draws a line at 6 from the y axis */

    refline 60 / axis=y lineattrs=(color=red);
    vbox time ;
      title "Box and Whisker Plot of Time";
run;
ods graphics off;


/*st002d03*/
proc means data=st092.phone_new maxdec=4
           n mean stderr clm;

/*where stderr is the standard error of the mean and clm is the confidence limit for the mean*/
    var Time;
    title '95% Confidence Interval for Time';
run;













