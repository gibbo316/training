/*st007d01*/
ods graphics on;
proc reg data=st092.fitness;
  model Oxygen_Consumption = runtime rest_pulse;
   id name;
   title 'Plots of Diagnostic Statistics for runtime';
run;
quit;
