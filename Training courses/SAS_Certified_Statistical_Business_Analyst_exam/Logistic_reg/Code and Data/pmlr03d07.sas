/* Run backward elimination with a   */
/* significance level to stay in the */
/* model of 0.01.                   */
proc logistic data=imputed plots(only)=oddsratio (type=horizontalstat);
   class res (param=ref ref='S');
   model ins(event='1')=&screened res / clodds=pl 
       selection=backward fast slstay=.01;
run;

/* To use best subsets / all subsets */
/* selection, all inputs must be     */
/* continuous. Create indicators for */
/* the residency input.              */
data imputed;
  set imputed;
  resr=(res='R');
  resu=(res='U');
run;

/* Run best subsets */
proc logistic data=imputed;
   model ins(event='1')=&screened resr resu 
   / selection=score best=1;
run;

/* Create an output data set containing the results
   from the all subsets selection. */

ods html close;
ods output bestsubsets=score;

proc logistic data=imputed;
   model ins(event='1')=&screened resr resu 
   / selection=score best=1;
run;

/* The names and number of variables are transferred to macro
   variables using PROC SQL. */

proc sql noprint;
  select variablesinmodel into :inputs1 - :inputs999 
  from score;
  select NumberOfVariables into :ic1 - :ic999 
  from score;
quit;

%let lastindx = &SQLOBS;

/* The fitstat macro generates model fit statistics for the
   models selected in the all subsets selection. The macro
   variable IM is set equal to the variable names in the
   model_indx model while the macro variable IC is set 
   equal to the number of variables in the model_indx model. */

%macro fitstat( );

%do model_indx=1 %to &lastindx;

%let im=&&inputs&model_indx;
%let ic=&&ic&model_indx;

ods output scorefitstat=stat&ic;
proc logistic data=imputed;
  model ins(event='1')=&im;
  score data=imputed out=scored fitstat
        priorevent=&pi1;
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

/* The data sets with the model fit statistics are 
   concatenated and sorted by BIC. */ 

data modelfit;
   set stat1 - stat&lastindx;
   model = _n_;
run;

proc sort data = modelfit;
   by bic;
run;

ods html;
proc print data=modelfit;
   var model auc aic bic misclass adjrsquare brierscore;
   title "Fit Statistics from Models selected from Best-Subsets";
run;

proc sql;
   select VariablesInModel into :selected
   from score
   where numberofvariables=23;
quit;
