/*st010d01*/
ods graphics on;
proc logistic data=st092.sales_inc plots(only)=(effect oddsratio);
   class Gender (param=ref ref='Male')
         Income (param=ref ref='Low');
   units Age=10;
   model Purchase(event='1')=Gender Age Income / 
         selection=backward clodds=pl;
   title1 'LOGISTIC MODEL (2):  Purchase=Gender Age Income';
run;
