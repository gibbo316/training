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
     var time;
    title 'Selected Descriptive Statistics for Time to Answer the Phone';
run;
