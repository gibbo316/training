/*st00ad02.sas*/
ods graphics;
ods html path=="C:\user"
         file='corr.html'
         style=statistical;

proc corr data= st092.fitness;
   var Runtime Age Weight Oxygen_Consumption Run_Pulse
       Rest_Pulse Maximum_Pulse Performance;
   title "HTML CORR output in Fitness Data Set";
run;

ods html close;
ods graphics off;

