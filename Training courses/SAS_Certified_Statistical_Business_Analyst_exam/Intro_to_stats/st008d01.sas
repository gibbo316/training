/*st008d01*/
title;
proc format;
   value purfmt 1 = ">=$250"
               0 = "<$250"
                 ;
run;
ods graphics on;
ods listing close;
ods rtf  style=journal
         file='freq.rtf';
proc freq data=st092.sales;
   tables Purchase Gender Income
          Gender*Purchase Income*Purchase /
              Plots(only)=(freqplot);
   format Purchase purfmt.;
run;

ods select histogram probplot;
proc univariate data=st092.sales;
   var Age;
   histogram Age / normal (mu=est sigma=est);
   probplot Age / normal (mu=est sigma=est);
run;
   
ods rtf close;
ods listing;
