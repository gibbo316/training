/*st00ad03.sas*/
ods graphics on;
proc corr data=st092.fitness;
   var Runtime Age Weight Oxygen_Consumption Run_Pulse
       Rest_Pulse Maximum_Pulse Performance;
   title "ODS Graphics in Fitness Data Set for Editing";
run;


