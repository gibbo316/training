/*st008d02*/
data st092.sales_inc;
   set st092.sales;
   if Income='Low' then IncLevel=1;
   else If Income='Medium' then IncLevel=2;
   else If Income='High' then IncLevel=3;
run;

proc format;
   value incfmt 1='Low Income'
                2='Medium Income'
                3='High Income';
run;
ods graphics on;
ods rtf style=statistical
        file='freq2.rtf';
proc freq data=st092.sales_inc;
   tables IncLevel*Purchase;
   format IncLevel incfmt. Purchase purfmt.;
   title1 'Create variable IncLevel to correct Income';
run;
ods rtf close;
