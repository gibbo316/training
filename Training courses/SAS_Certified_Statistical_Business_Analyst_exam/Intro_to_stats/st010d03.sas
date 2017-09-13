/*st010d03*/
proc means data=st092.sales_inc noprint nway;
   class IncLevel;
   var Purchase;
   output out=bins sum(Purchase)=Purchase n(Purchase)=BinSize;
run;

data bins;
   set bins;
   Logit=log((Purchase+1)/(BinSize-Purchase+1));
run;

proc sgscatter data=bins;
   plot Logit*IncLevel / 
        markerattrs=(symbol=asterisk color=blue size=15);
   format IncLevel incfmt.;
   label IncLevel='Income Level';
   title 'Estimated Logit Plot of Income Level';
run;
quit;
/*st010d03*/
proc rank data=st092.sales_inc groups=17 out=Ranks17;
   var Age;
   ranks Bin17;
run;

proc means data=Ranks17 noprint nway;
   class Bin17;
   var Purchase Age;
   output out=Bins17 sum(Purchase)=Purchase n(Purchase)=BinSize
          mean(Age)=Age;
run;

data Bins17;
   set Bins17;
   Logit=log((Purchase+1)/(_freq_-Purchase+1));
run;

proc sgscatter data=Bins17;
   plot Logit*Age /
        reg markerattrs=(symbol=asterisk color=blue size=15);
   title "Estimated Logit Plot of Customer's Age";
run;
quit;
