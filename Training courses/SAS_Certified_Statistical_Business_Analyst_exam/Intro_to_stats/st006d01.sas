/*st006d01*/
ods graphics;

proc reg data=st092.fitness;
   model Oxygen_Consumption = RunTime;
   title 'Predicting Oxygen_Consumption from RunTime';
run;
quit;
