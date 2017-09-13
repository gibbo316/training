/* Specify the prior probability  */
/* to correct for oversampling    */
%let pi1=.02;       

/* Correct predicted probabilities */
proc logistic data=develop;
   model ins(event='1')=dda ddabal dep depamt cashbk checks;
   score data = pmlr.new out=scored priorevent=&pi1;
run;

proc print data=scored(obs=10);
   var p_1 dda ddabal dep depamt cashbk checks;
run;


