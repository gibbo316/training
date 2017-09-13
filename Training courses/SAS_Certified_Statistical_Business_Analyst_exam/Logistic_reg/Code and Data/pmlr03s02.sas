proc means data=pva1 noprint nway;
   class CLUSTER_CODE;
   var target_b;
   output out=level mean=prop;
run;

ods output clusterhistory=cluster;

proc cluster data=level method=ward outtree=fortree
      plots=(dendrogram(horizontal height=rsq));
   freq _freq_;
   var prop;
   id CLUSTER_CODE;
run;

proc freq data=pva1 noprint;
   tables CLUSTER_CODE*TARGET_B / chisq;
   output out=chi(keep=_pchi_) chisq;
run;

data cutoff;
   if _n_ = 1 then set chi;
   set cluster;
   chisquare=_pchi_*rsquared;
   degfree=numberofclusters-1;
   logpvalue=logsdf('CHISQ',chisquare,degfree);
run;

proc sgplot data=cutoff;
   scatter y=logpvalue x=numberofclusters 
           / markerattrs=(color=blue symbol=circlefilled);
   xaxis label="Number of Clusters";
   yaxis label="Log of P-Value" min=-50 max=-10;
   title "Plot of the Log of the P-Value by Number of Clusters";
run;
title; 

proc sql;
   select NumberOfClusters into :ncl
   from cutoff
   having logpvalue=min(logpvalue);
quit;

ods html close;
proc tree data=fortree nclusters=&ncl out=clus;
   id cluster_code;
run;
ods html;

proc sort data=clus;
   by clusname;
run;

proc print data=clus;
   by clusname;
   id clusname;
   title "Cluster Assignments";
run;

data pva1; 
   set pva1;
   ClusCdGrp1 = CLUSTER_CODE in("13", "20", "53", ".", "28");
   ClusCdGrp2 = CLUSTER_CODE in("16", "38", "03", "40", "18",
                                "24", "01", "14", "46", "35");
   ClusCdGrp3 = CLUSTER_CODE in("06", "10", "32", "41", "44", "47");
   ClusCdGrp4 = CLUSTER_CODE in("09", "43", "49", "51",
                                "21", "30", "45", "52",
                                "08", "37", "50");
run;
