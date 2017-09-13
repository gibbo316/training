/*st00ad01.sas*/
ods graphics;
proc corr data=st092.fitness;
   var Runtime Age Weight Oxygen_Consumption Run_Pulse
       Rest_Pulse Maximum_Pulse Performance;
   title "Scatter Plot Matrix of Variables in Fitness Data Set";
run;
ods graphics off;
