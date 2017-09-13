%let pi1=0.02;

%let inputs=ACCTAGE DDA DDABAL DEP DEPAMT CASHBK 
            CHECKS DIRDEP NSF NSFAMT PHONE TELLER 
            SAV SAVBAL ATM ATMAMT POS POSAMT CD 
            CDBAL IRA IRABAL LOC LOCBAL INV 
            INVBAL ILS ILSBAL MM MMBAL MMCRED MTG 
            MTGBAL CC CCBAL CCPURC SDB INCOME 
            HMOWN LORES HMVAL AGE CRSCORE MOVED 
            INAREA;

/* Create missing indicators */
data develop(drop=i);
   set pmlr.develop;
   /* name the missing indicator variables */
   array mi{*} MIAcctAg MIPhone MIPOS MIPOSAmt 
               MIInv MIInvBal MICC MICCBal 
               MICCPurc MIIncome MIHMOwn MILORes
               MIHMVal MIAge MICRScor;
   /* select variables with missing values */
   array x{*} acctage phone pos posamt 
              inv invbal cc ccbal
              ccpurc income hmown lores 
              hmval age crscore;
   do i=1 to dim(mi);
      mi{i}=(x{i}=.);
   end;
run;

/* Sort the data by the target   */
/* in preparation for stratified */
/* sampling.                     */
proc sort data=develop out=develop; 
   by ins; 
run;

/* The SURVEYSELECT procedure will  */
/* perform stratified sampling on   */
/* any variable in the STRATA       */
/* statement.  The OUTALL option    */
/* specifies that you want a flag   */
/* appended to the file to indicate */
/* selected records, not simply a   */
/* file comprised of the selected   */
/* records.                         */
proc surveyselect noprint
                  data = develop 
                  samprate=.6667 
                  out=develop
                  seed=44444
                  outall;
   strata ins;
run;

/* Verify stratification */
proc freq data = develop;
   tables ins*selected;
run;

/* Create training and validation data sets */
data train valid;
   set develop;
   if selected then output train;
   else output valid;
run;

/* Impute missing values with the median */
proc stdize data=train 
            reponly 
            method=median 
            out=train1;
   var &inputs;
run;

/* Cluster levels of BRANCH */
proc means data=train1 noprint nway;
   class branch;
   var ins;
   output out=level mean=prop;
run;

ods output clusterhistory=cluster;

proc cluster data=level method=ward outtree=fortree
        plots=(dendrogram(vertical height=rsq));
   freq _freq_;
   var prop;
   id branch;
run;

proc freq data=train1 noprint;
   tables branch*ins / chisq;
   output out=chi(keep=_pchi_) chisq;
run;

data cutoff;
   if _n_ = 1 then set chi;
   set cluster;
   chisquare=_pchi_*rsquared;
   degfree=numberofclusters-1;
   logpvalue=logsdf('CHISQ',chisquare,degfree);
run;

/* The SGPLOT Procedure is new in SAS9.2 */
proc sgplot data=cutoff;
   scatter y=logpvalue x=numberofclusters 
           / markerattrs=(color=blue symbol=circlefilled);
   xaxis label="Number of Clusters";
   yaxis label="Log of P-Value" min=-120 max=-90;
   title "Plot of the Log of the P-Value by Number of Clusters";
run;

proc sql;
   select NumberOfClusters into :ncl
   from cutoff
   having logpvalue=min(logpvalue);
quit;

ods html close;
proc tree data=fortree nclusters=&ncl out=clus;
   id branch;
run;
ods html;

proc sort data=clus;
   by clusname;
run;

title;
proc print data=clus;
   by clusname;
   id clusname;
run;

data train1;
   set train1;
   brclus1=(branch='B14');
   brclus2=(branch in ('B12','B5','B8',
                       'B3','B18','B19','B17',
                       'B4','B6','B10','B9',
                       'B1','B13'));
   brclus3=(branch in ('B15','B16'));
run;

/* Use the VARCLUS procedure to cluster inputs */
ods html close;
ods output clusterquality=summary
           rsquare=clusters;

proc varclus data=train1
             maxeigen=.7 
             short 
             hi;
   var &inputs brclus1-brclus3 miacctag 
       miphone mipos miposamt miinv 
       miinvbal micc miccbal miccpurc
       miincome mihmown milores mihmval 
       miage micrscor;
run;
ods html;

data _null_;
   set summary;
   call symput('nvar',compress(NumberOfClusters));
run;

proc print data=clusters noobs label;
   where NumberOfClusters=&nvar;
   var Cluster Variable RSquareRatio VariableLabel;
run;

/* Choose a representative */
/* from each cluster       */
%let reduced=
MIPhone MIIncome Teller MM 
Income ILS LOC POSAmt
NSFAmt CD LORes CCPurc
ATMAmt brclus2 Inv Dep
CashBk Moved IRA CRScore
MIAcctAg IRABal MICRScor MTGBal 
AcctAge SavBal DDABal SDB
InArea Sav Phone CCBal 
InvBal MTG HMOwn DepAmt
DirDep ATM brclus1 Age;

/* Use correlation coefficients to detect */
/* inputs of least "significance."        */
ods html close;
ods output spearmancorr=spearman
           hoeffdingcorr=hoeffding;

proc corr data=train1 spearman hoeffding rank;
   var &reduced;
   with ins;
run;

ods html;

data spearman1(keep=variable scorr spvalue ranksp);
   length variable $ 8;
   set spearman;
   array best(*) best1--best&nvar;
   array r(*) r1--r&nvar;
   array p(*) p1--p&nvar;
   do i=1 to dim(best);
      variable=best(i);
      scorr=r(i);
      spvalue=p(i);
      ranksp=i;
      output;
   end;
run;

data hoeffding1(keep=variable hcorr hpvalue rankho);
   length variable $ 8;
   set hoeffding;
   array best(*) best1--best&nvar;
   array r(*) r1--r&nvar;
   array p(*) p1--p&nvar;
   do i=1 to dim(best);
      variable=best(i);
      hcorr=r(i);
      hpvalue=p(i);
      rankho=i;
      output;
   end;
run;

proc sort data=spearman1;
   by variable;
run;

proc sort data=hoeffding1;
   by variable;
run;

data correlations;
   merge spearman1 hoeffding1;
   by variable;
run;

proc sort data=correlations;
   by ranksp;
run;

proc print data=correlations label split='*';
   var variable ranksp rankho scorr spvalue hcorr hpvalue;
   label ranksp = 'Spearman rank*of variables'
         scorr = 'Spearman Correlation'
         spvalue = 'Spearman p-value'
         rankho = 'Hoeffding rank*of variables'
         hcorr = 'Hoeffding Correlation'
         hpvalue = 'Hoeffding p-value';
run;

/* Find values for reference lines */
proc sql noprint;
   select min(ranksp) into :vref 
   from (select ranksp 
         from correlations 
         having spvalue > .5);
   select min(rankho) into :href 
   from (select rankho
         from correlations
         having hpvalue > .5);
quit;

/* Plot variable names, Hoeffding */
/* ranks, and Spearman ranks      */
proc sgplot data=correlations;
   refline &vref / axis=y;
   refline &href / axis=x;
   scatter y=ranksp x=rankho / datalabel=variable;
   yaxis label="Rank of Spearman";
   xaxis label="Rank of Hoeffding";
   title "Scatter Plot of the Ranks of Spearman vs. Hoeffding";
run;

/* Drop HMOwn, MIIncome, Moved, & LORes */
%let screened = 
MIPhone Teller MM 
Income ILS LOC POSAmt
NSFAmt CD CCPurc
ATMAmt brclus2 INV DEP
CashBk IRA CRScore
MIAcctAg IRABal MICRScor MTGBal 
AcctAge SavBal DDABal SDB
InArea Sav Phone CCBal 
INVBal MTG DEPAmt
DirDep ATM brclus1 Age;

/* Assess non-linearity for Checking and */
/* Savings balances                      */
%let var=ddabal;
**************
%let var = savbal;
proc rank data=train1 groups=100 out=out;
   var &var;
   ranks bin;
run;

proc means data=out noprint nway;
   class bin;
   var ins &var;
   output out=bins sum(ins)=ins mean(&var)=&var;
run;

data bins;
   set bins;
   elogit=log((ins+(sqrt(_FREQ_ )/2))/
          (_FREQ_ -ins+(sqrt(_FREQ_ )/2)));
run;


proc sgplot data = bins;
   reg y=elogit x=&var /
       curvelabel="Linear Relationship?"
	   curvelabelloc=outside
	   lineattrs=(color=ligr);
   series y=elogit x=&var;
   title "Empirical Logit against &var";
run;

proc sgplot data = bins;
   reg y=elogit x=bin /
       curvelabel="Linear Relationship?"
	   curvelabelloc=outside
	   lineattrs=(color=ligr);
   series y=elogit x=bin;
   title "Empirical Logit against Binned &var";
run;


/* Accommodate non-linearities in balances */
proc sql;
   select mean(ddabal) into :mean 
   from train1 where dda;
quit;

data train1;
   set train1;
   if not dda then ddabal = &mean;
run;

proc rank data=train1 groups=100 out=out;
   var ddabal;
   ranks bin;
run;

proc means data = out noprint nway;
   class bin;
   var ddabal;
   output out=endpts max=max;
run;

filename rank "S:\workshop\rank.sas";

data _null_;
   file rank;
   set endpts end=last;
   if _n_ = 1 then put "select;";
   if not last then do;
     put "  when (ddabal <= " max ") B_DDABal =" bin ";";
   end;
   else if last then do;
     put "  otherwise B_DDABal =" bin ";";
     put "end;";
  end;
run;

/* Bin DDABal, truncate SavBal */
data train1;
   set train1;
   %include rank /source;
   if savbal > 16000 then savbal=16000;
run;

/* Assess non-linearity for Checking and */
/* Savings balances                      */

%let var=b_ddabal;

proc means data=train1 noprint nway;
   class &var;
   var ins &var;
   output out=bins sum(ins)=ins;
run;

data bins;
   set bins;
   elogit=log((ins+(sqrt(_FREQ_ )/2))/
          (_FREQ_ -ins+(sqrt(_FREQ_ )/2)));
run;

proc sgplot data = bins;
   reg y=elogit x=&var /
       curvelabel="Linear Relationship?"
	   curvelabelloc=outside
	   lineattrs=(color=ligr);
   series y=elogit x=&var;
   title "Empirical Logit against &var";
run;

%let var = savbal;
proc rank data=train1 groups=100 out=out;
   var &var;
   ranks bin;
run;

proc means data=out noprint nway;
   class bin;
   var ins &var;
   output out=bins sum(ins)=ins mean(&var)=&var;
run;

data bins;
   set bins;
   elogit=log((ins+(sqrt(_FREQ_ )/2))/
          (_FREQ_ -ins+(sqrt(_FREQ_ )/2)));
run;

proc sgplot data = bins;
   reg y=elogit x=&var /
       curvelabel="Linear Relationship?"
	   curvelabelloc=outside
	   lineattrs=(color=ligr);
   series y=elogit x=&var;
   title "Empirical Logit against &var";
run;

/* Replace DDABal with B_DDABal */
%let screened = 
MIPhone Teller MM 
Income ILS LOC POSAmt
NSFAmt CD CCPurc
ATMAmt brclus2 INV DEP
CashBk IRA CRScore
MIAcctAg IRABal MICRScor MTGBal 
AcctAge SavBal B_DDABal SDB
InArea Sav Phone CCBal 
INVBal MTG DEPAmt
DirDep ATM brclus1 Age;

/* Perform some variable selection using best subsets selcection */
title;

data train1;
  set train1;
  resr=(res='R');
  resu=(res='U');
run;

ods html close;
ods output bestsubsets=score;

proc logistic data=train1;
   model ins(event='1')=&screened resr resu 
   / selection=score best=1;
run;

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
proc logistic data=train1;
  model ins(event='1')=&im;
  score data=train1 out=scored fitstat
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
   where numberofvariables=24;
quit;

/* Fit a logistic regression model with the selected inputs.
   Use the OFFSET= option in PROC LOGISTIC to correct for 
   oversampling. */

proc SQL noprint;
  select mean(INS) into :rho1 from pmlr.develop;
quit;

data train1;
   set train1;
   off=log(((1-&pi1)*&rho1)/(&pi1*(1-&rho1)));
run;

/* PROC LOGISTIC fits a model with the offset variable using the
   OFFSET=option. The only difference between the parameter estimates
   with and without the offset variable is the intercept term */

proc logistic data=train1 plots(only)=(oddsratio (type=horizontalstat));
   model ins(event='1') = &selected / clodds=pl offset=off;
   title "Model with Lowest BIC";
run;

title;

/* Prepare the validation data for scoring */
proc means data = valid nmiss;
   var Teller MM ILS LOC NSFAmt CD ATMAmt Inv Dep IRA 
       MTGBal AcctAge SavBal Sav Phone CCBal MTG DirDep ATM;
run;

proc univariate data=train1 noprint;
   var acctage inv phone ccbal;
   output out=medians
          pctlpts=50
          pctlpre=acctage inv phone ccbal;
run;

data valid1(drop=acctage50 inv50 phone50 ccbal50 i);
   if _N_ = 1 then set medians;
   set valid;
   array x(*) acctage inv phone ccbal;
   array med(*) acctage50 inv50 phone50 ccbal50;
      do i = 1 to dim(x);
         if x(i)=. then x(i)=med(i);
      end;
   if not dda then ddabal = &mean;
   brclus1=(branch='B14');
   brclus2=(branch in ('B12','B5','B8',
                       'B3','B18','B19','B17',
                       'B4','B6','B10','B9',
                       'B1','B13'));
   brclus3=(branch in ('B15','B16'));
   %include rank;
   if savbal > 16000 then savbal=16000;
run;

/* An easier to type (but slightly more CPU   */
/* intensive method) for imputing the medians */
/* from the training data in the validation   */
/* data is to use the STDIZE procedure with   */
/* the OUTSTAT= option.  An example follows.  */
proc stdize data = train out=train2
            method=median reponly
            OUTSTAT=med;
var &inputs;
run;

proc stdize data=valid out=valid2
            reponly method=in(med);
var &inputs;
run;

proc compare base= valid1 compare=valid2;
   var acctage inv phone ccbal;
run;
