/*st004d02*/
ods graphics on;
proc glm data=st092.phone_new_and_a           										 PLOTS(only)=diagnostics(unpack);
   class team;
   model time=team;
   means team / hovtest;
   title 'Testing for Equality of Means with PROC GLM';
run;
quit;
ods graphics off;
