/*st006d02*/
ods graphics off;
proc reg data=st092.fitness;
   model Oxygen_Consumption = RunTime / clm cli;
   title 'Predicting Oxygen_Consumption from RunTime';
run;
quit;
