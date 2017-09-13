/*st006s03*/
ods graphics off;
proc reg data=st092.BodyFat2 outest=Betas;
   model PctBodyFat2=Weight;
   title "Regression of % Body Fat on Weight";
run;

data ToScore;
   input Weight @@;
   datalines;
125 150 175 200 225
;
run;

data _null_;
	set betas;
	call symput('beta0', intercept);
	call symput('beta1',weight);
run;

data predictions;
		set ToScore ;
	Predicted=&beta0+&Beta1*Weight;
run;
proc print data=predictions;
run;
