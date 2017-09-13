/*st00bd01.sas*/
proc means data=st092.sales_inc noprint nway;
   class IncLevel Gender;
   var Purchase;
   output out=bins sum(Purchase)=Purchase n(Purchase)=BinSize;
run;
data bins;
   set bins;
   Logit=log((Purchase+1)/(BinSize-Purchase+1));
run;
ods graphics on;
proc sgscatter data=bins;
   plot Logit*IncLevel /group=Gender markerattrs=(size=15)
                        join;
   format IncLevel incfmt.;
   label IncLevel='Income Level';
   title;
run;
quit;
