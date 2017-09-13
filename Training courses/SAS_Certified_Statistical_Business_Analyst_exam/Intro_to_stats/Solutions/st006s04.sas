/*st006s04*/
ods graphics on;
proc reg data=st092.bodyfat2         
		plots(only)=(QQ 
					RESIDUALBYPREDICTED
					RESIDUALHISTOGRAM
					RESIDUALPLOT);
  model PctBodyFat2
                  = weight;
   title 'Plots of Diagnostic Statistics for runtime';
run;
quit;
