/*st006d03*/
data Need_Predictions;
   input RunTime @@;
   datalines;
9 10 11 12 13
;
run;

data PredOxy;
   set Need_Predictions 
       st092.fitness;
run;

ods graphics off;

proc reg data=PredOxy;
   model Oxygen_Consumption=RunTime / p;
   id RunTime;
   title 'Oxygen_Consumption=RunTime with Predicted Values';
run;
quit;

/*st006d03*/
proc reg data=st092.fitness noprint outest=Betas;
	model Oxygen_Consumption=RunTime;
run;
quit;

proc print data=betas;
run;

data _null_;
	set betas;
	call symput('beta0', intercept);
	call symput('beta1',runtime);
run;

data predictions;
		set need_predictions ;
	Predicted=&beta0+&Beta1*runtime;
run;
proc print data=predictions;
run;
