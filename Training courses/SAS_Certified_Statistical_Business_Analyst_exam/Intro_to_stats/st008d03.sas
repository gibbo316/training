/*st008d03*/
ods graphics off;
proc freq data=st092.sales_inc;
   tables Gender*Purchase
          / chisq expected cellchi2 nocol nopercent 
          relrisk;
   format Purchase purfmt.;
   title1  'Association between Gender and Purchase';
run;
