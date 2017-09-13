/*st006s02.sas*/
ods graphics;
proc reg data=st092.BodyFat2;
   model PctBodyFat2=Weight / clm cli;
   title "Regression of % Body Fat on Weight";
run;
quit;
