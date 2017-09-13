%let pi1 = 0.02;

proc sql noprint;
   select mean(ins) into :rho1 from pmlr.develop;
quit;

data develop;
   set develop;
   sampwt=((1-&pi1)/(1-&rho1))*(ins=0)+(&pi1/&rho1)*(ins=1);
run;

proc logistic data=develop des;
   weight sampwt;
   model ins = dda ddabal dep depamt cashbk checks / stb;
   score data=pmlr.new out=scored;
run;

proc print data=scored(obs=20);
   var p_1 dda ddabal dep depamt cashbk checks;
run;
