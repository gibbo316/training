proc logistic data=develop plots(only)=(effect(clband x=(ddabal depamt checks res))
                           oddsratio (type=horizontalstat));
   class res (param=ref ref='S');
   model ins(event='1') = dda ddabal dep depamt 
               cashbk checks res / stb clodds=pl;
   units ddabal=1000 depamt=1000 / default=1;
   oddsratio 'Comparisons of Residential Classification' res / diff=all cl=pl;
run;
