/*st010d02*/
ods graphics on;
proc logistic data=st092.sales_inc plots(only)=(effect oddsratio);
   class Gender (param=ref ref='Male')
         Income (param=ref ref='Low');
   model Purchase(event='1')=Gender|Age|Income @2/ 
         selection=backward clodds=pl;
   units Age=10;
   title1 'LOGISTIC MODEL (3): main effects and 2-way interactions';
   title2 '/ sel=backward';
run;


/*st010d02*/
ods select OddsRatiosPL ORPlot;
proc logistic data=st092.sales_inc plots(only)=(oddsratio);
   class Gender (param=ref ref='Male')
         Income (param=ref ref='Low');
   model Purchase(event='1')=Gender|Income Age;
   units Age=10; 
   oddsratio Age / cl=pl;
   oddsratio Gender / diff=ref at (Income=all) cl=pl;
   oddsratio Income / diff=ref at (Gender=all) cl=pl;
   title1 'LOGISTIC MODEL (3): main effects and 2-way interactions';
   title2 '/ sel=backward';
run;
