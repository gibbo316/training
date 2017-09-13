/*st00ad05.sas*/
ods graphics off;
proc freq data=st092.exact;
   tables A*B;
   exact pchi;
   title "Exact P-Values";
run;          
