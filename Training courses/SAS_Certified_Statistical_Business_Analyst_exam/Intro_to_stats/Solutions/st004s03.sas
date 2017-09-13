/*st004s03.sas*/
proc glm data=st092.all_ads PLOTS(only)=diagnostics(unpack);
   class ad;
   model sales=ad;
   means ad / hovtest;
   title 'Testing for Equality of Means with PROC GLM';
run;
quit;
