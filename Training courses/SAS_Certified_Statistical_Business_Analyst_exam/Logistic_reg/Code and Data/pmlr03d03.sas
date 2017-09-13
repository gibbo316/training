proc varclus data=imputed maxeigen=.7 hi short plots=dendrogram;
   var &inputs brclus1-brclus4 miacctag 
       miphone mipos miposamt miinv 
       miinvbal micc miccbal miccpurc
       miincome mihmown milores mihmval 
       miage micrscor;
   title "Variable Clustering of Imputed Data Set";
run;


/* Use the OUTPUT statement to generate  */
/* data sets based on the variable       */
/* clustering results and the clustering */
/* summary.                              */
ods html close;
ods output clusterquality=summary
           rsquare=clusters;

proc varclus data=imputed 
             maxeigen=.7 
             short 
             hi;
   var &inputs brclus1-brclus4 miacctag 
       miphone mipos miposamt miinv 
       miinvbal micc miccbal miccpurc
       miincome mihmown milores mihmval 
       miage micrscor;
run;
ods html;

/* Use the CALL SYMPUT function to create */
/* a macro variable:                      */
/* &NVAR = the number of of clusters       */
/* This is also the number of variables   */
/* in the analysis, going forward.        */
data _null_;
   set summary;
   call symput('nvar',compress(NumberOfClusters));
run;

title;
proc print data=clusters noobs;
   where NumberOfClusters=&nvar;
   var Cluster Variable RSquareRatio VariableLabel;
run;

/* Choose a representative */
/* from each cluster       */
%let reduced=
brclus2 miincome checks ccbal
mmbal income ilsbal posamt
nsfamt cd irabal age
loc sav dda invbal
crscore brclus3 cc brclus1
cashbk miacctag micrscor moved
acctage dirdep savbal ddabal
sdb ccpurc inarea atmamt
phone mmcred hmown inv
depamt brclus4 atm lores
mtg;
