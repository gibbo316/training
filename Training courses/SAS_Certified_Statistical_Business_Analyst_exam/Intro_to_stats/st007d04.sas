/*st007d04*/
proc reg data=st092.fitness
		plots(only)=(QQ 
					RESIDUALBYPREDICTED
					RESIDUALHISTOGRAM 
                    RESIDUALPLOT
					RSTUDENTBYPREDICTED);

model oxygen_consumption =  RunTime Age 
                      Run_Pulse  Maximum_Pulse;
title 'Plots of Diagnostic Statistics';
run;
quit;
