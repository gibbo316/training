/*st009d01*/
ods graphics on;
proc logistic data=st092.sales_inc plots(only)=(effect oddsratio);
   class Gender (param=ref ref='Male');
   model Purchase(event='1')=Gender / clodds=pl;
   title1 'LOGISTIC MODEL (1):Purchase=Gender';
run;
