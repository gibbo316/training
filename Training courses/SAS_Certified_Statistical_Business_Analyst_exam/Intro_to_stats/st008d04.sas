/*st008d04*/
ods graphics off;
proc freq data=st092.sales_inc;
   tables Inclevel*Purchase / chisq measures cl;
   format Inclevel incfmt. Purchase purfmt.;
   title1 'Ordinal Association between INCLEVEL and PURCHASE?';
run;
