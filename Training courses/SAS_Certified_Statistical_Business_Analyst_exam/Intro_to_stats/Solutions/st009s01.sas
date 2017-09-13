/*st009s01*/
ods graphics on;
proc logistic data=st092.safety plots(only)=(effect oddsratio);
   class Region (param=ref ref='Asia');
   model Unsafe(event='1')=Region / clodds=pl;
   title1 'LOGISTIC MODEL (1):Unsafe=Region';
run;
