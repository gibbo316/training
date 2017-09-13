/*st005d01*/
ods graphics / imagemap=on;
ods listing close;
ods html file='corr.html'
         style=statistical;


proc corr data=st092.fitness rank
          plots(only)=scatter(nvar=all ellipse=none);
   var RunTime Age Weight Run_Pulse
       Rest_Pulse Maximum_Pulse Performance;
   with Oxygen_Consumption;
   id name;
   title "Correlations and Scatter Plots with Oxygen_Consumption";
run;

ods html close;
ods listing;

/*st005d01*/

ods graphics;
ods listing close;
ods rtf file='corr.rtf'
         style=journal;
proc corr data=st092.fitness nosimple 
          plots=matrix(nvar=all histogram);
   var RunTime Age Weight Run_Pulse
       Rest_Pulse Maximum_Pulse Performance;
   title "Correlations and Scatter Plot Matrix of Fitness Predictors";
run;

ods rtf close;
ods listing;
