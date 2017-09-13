/*st002d03*/
proc means data=st092.phone_new maxdec=4
           n mean stderr clm;
    var Time;
    title '95% Confidence Interval for Time';
run;
