/*st006s01.sas*/
ods graphics off;
proc reg data=st092.BodyFat2;
   model PctBodyFat2=Weight;
   title "Regression of % Body Fat on Weight";
run;
quit;
