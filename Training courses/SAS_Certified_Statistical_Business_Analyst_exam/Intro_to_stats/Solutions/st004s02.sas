/*st004s02.sas*/
proc glm data=st092.ads PLOTS(only)=diagnostics(unpack);
   class ad;
   model sales=ad;
   means ad / hovtest;
   title 'Testing for Equality of Means with PROC GLM';
run;
quit;
