/* Score a new data set with one run of the  */
/* LOGISTIC procedure with the SCORE         */
/* statement                                 */
proc logistic data=develop;
   model ins(event='1')= dda ddabal dep depamt cashbk checks;
   score data = pmlr.new out=scored;
run;

proc print data=scored(obs=10);
   var p_1 dda ddabal dep depamt cashbk checks;
run;




