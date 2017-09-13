proc means data=imputed noprint nway;
   class branch;
   var ins;
   output out=level mean=prop;
run;

proc print data=level;
run;

/* Use ODS to output the ClusterHistory */
/* output object into a data set named  */
/* "cluster."                           */
ods output clusterhistory=cluster;

proc cluster data=level method=ward outtree=fortree
        plots=(dendrogram(vertical height=rsq));
   freq _freq_;
   var prop;
   id branch;
run;

/* Use the FREQ procedure to get the */
/* Pearson Chi^2 statistic of the    */
/* full BRANCH*INS table.            */
proc freq data=imputed noprint;
   tables branch*ins / chisq;
   output out=chi(keep=_pchi_) chisq;
run;

/* Use a one-to-many merge to put the  */
/* Chi^2 statistic onto the clustering */
/* results. Calculate a (log) p-value  */
/* for each level of clustering.       */
data cutoff;
   if _n_ = 1 then set chi;
   set cluster;
   chisquare=_pchi_*rsquared;
   degfree=numberofclusters-1;
   logpvalue=logsdf('CHISQ',chisquare,degfree);
run;

/* Plot the log p-values against number of */
/* clusters.                               */
proc sgplot data=cutoff;
   scatter y=logpvalue x=numberofclusters 
           / markerattrs=(color=blue symbol=circlefilled);
   xaxis label="Number of Clusters";
   yaxis label="Log of P-Value" min=-170 max=-130;
   title "Plot of the Log of the P-Value by Number of Clusters";
run;

/* Create a macro variable (&ncl) that */
/* contains the number of clusters     */
/* associated with the minimum log     */
/* p-value.*/
title;
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

proc print data=clus;
   by clusname;
   id clusname;
run;

/* Create indicators for all but one of the */
/* clusters; the cluster left out is the    */
/* reference level.                         */
data imputed;
   set imputed;
   brclus1=(branch in ('B6','B9','B19','B8','B1','B17','B3',
           'B5','B13','B12','B4','B10'));
   brclus2=(branch='B15');
   brclus3=(branch='B16');
   brclus4=(branch='B14');
run;
