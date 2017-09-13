/*st00ad07.sas*/
ods graphics on / imagemap;
ods html file = 'partial.html';
proc reg data=st092.fitness plots(only) = partial(unpack);
   PREDICT: model Oxygen_Consumption 
                 = RunTime Age Run_Pulse Maximum_pulse/partial;
   id Name;
   title 'Producing Partial Leverage Plots';
run;
quit;
ods html close;
