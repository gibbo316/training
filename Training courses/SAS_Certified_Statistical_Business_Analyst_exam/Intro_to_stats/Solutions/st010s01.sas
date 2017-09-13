/*st010s01*/
ods graphics on;
proc format; 
   value sizefmt 1='Small'
                  2='Medium'
                  3='Large';
run;
proc logistic data=st092.safety plots(only)=(effect oddsratio);
   class Region (param=ref ref='Asia')
         Size (param=ref ref='Large');
   model Unsafe(event='1')=Weight Region Size / clodds=pl;
   units weight=-1;
   format Size sizefmt.;
   title1 'LOGISTIC MODEL (2):Unsafe=Weight Region Size';
run;
