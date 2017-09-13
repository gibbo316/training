/*st005s02.sas*/
ods graphics;
proc corr data=st092.BodyFat2 rank
          plots(only)=scatter(nvar=all ellipse=none);
   var Age Weight Height;
   with PctBodyFat2;
   title "Correlations and Scatter Plots with Body Fat %";
run;

proc corr data=st092.BodyFat2 rank
          plots(only)=scatter(nvar=all ellipse=none);
   var Neck Chest Abdomen Hip Thigh
       Knee Ankle Biceps Forearm Wrist;
   with PctBodyFat2;
   title "Correlations and Scatter Plots with Body Fat %";
run;
