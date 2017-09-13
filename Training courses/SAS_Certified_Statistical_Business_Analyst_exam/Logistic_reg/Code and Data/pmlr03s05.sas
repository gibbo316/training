proc logistic data=pva1;
   model target_b(event='1')= &ex_screened                    
         / selection=score best=1;
   title "Models Selected by All Subsets Selection";
run;

ods html close;
ods output bestsubsets=score;
proc logistic data=pva1;
   model target_b(event='1')= &ex_screened 
         / selection=score best=1;
run;

proc sql noprint;
  select variablesinmodel into :exinputs1 - :exinputs999 
  from score;
  select NumberOfVariables into :exic1 - :exic999 
  from score;
quit;

%let lastindx = &SQLOBS;

%macro fitstat( );

%do model_indx=1 %to &lastindx;

%let ex_im=&&exinputs&model_indx;
%let ex_ic=&&exic&model_indx;

ods output scorefitstat=ex_stat&ex_ic;
proc logistic data=pva1;
  model target_b(event='1')=&ex_im;
  score data=pva1 out=scored fitstat
        priorevent=&ex_pi1;
run;

proc datasets
   library=work
   nodetails
   nolist;
   delete scored;
run;
quit;

%end;
%mend fitstat;

%fitstat( );

data exmodelfit;
   set ex_stat1 - ex_stat&lastindx;
   model = _n_;
run;

proc sort data = exmodelfit;
   by bic;
run;

ods html;
proc print data=exmodelfit;
   var model auc aic bic misclass adjrsquare brierscore;
   title "Fit Statistics from Models selected from Best-Subsets";
run;

proc sql;
   select VariablesInModel into :ex_selected
   from score
   where numberofvariables=11;
quit;

proc logistic data=pva1 namelen=32;
   model target_b(event='1') = &ex_selected;
run;
