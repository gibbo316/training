/*st006d04*/
ods graphics on;
ods select diagnosticsPanel ResidualPlot;
proc reg data=st092.fitness;
  model Oxygen_Consumption 
                  = runtime;
   title 'Plots of Diagnostic Statistics for runtime';
run;
quit;

/*st006d04*/
proc reg data=st092.fitness          
		plots(only)=(QQ 
					RESIDUALBYPREDICTED
					RESIDUALHISTOGRAM
					RESIDUALPLOT
					RSTUDENTBYPREDICTED);
  model Oxygen_Consumption 
                  = runtime;
   title 'Plots of Diagnostic Statistics for runtime';
run;
quit;
