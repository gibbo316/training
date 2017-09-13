/*st007d02*/
proc reg data=st092.fitness;
	model oxygen_consumption = performance 
							   runtime
							   rest_pulse 
							   run_pulse 
							   maximum_pulse
						       age
							   weight;
	title "Regression of Oxygen Consumption";
run;
quit;
