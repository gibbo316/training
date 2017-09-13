/*st008s01*/
ods graphics off;
proc freq data=st092.safety;
   tables Unsafe Type Region;
   title "Safety Data Frequencies";
run;

/*st008s01*/
proc format; 
   value safefmt 0='Average or Above'
                 1='Below Average';
run;

proc freq data=st092.safety;
   tables Region*Unsafe / chisq ;
   format Unsafe safefmt.;
   title "Association between Unsafe and Region";
run;

/*st008s01*/
proc freq data=st092.safety;
   tables Size*Unsafe / chisq measures cl;
   format Unsafe safefmt.;
   title "Association between Unsafe and Size";
run;
