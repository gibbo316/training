/*st004s04.sas*/
ods graphics on;
ods select LSMeans Diff MeanPlot DiffPlot;
proc glm data=st092.all_ads;
   class ad;
   model sales=ad;
   lsmeans ad / pdiff=all adjust=tukey;
   title 'Testing for Equality of Means with PROC GLM';
run;
quit;
