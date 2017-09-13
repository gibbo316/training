/*st004d04*/
ods graphics on;
ods select LSMeans Diff MeanPlot DiffPlot;
proc glm data=st092.phone_all_groups ;
   class team;
   model time=team;
   lsmeans team / pdiff=all adjust=tukey;
   title 'Testing for Equality of Means with PROC GLM';
run;
quit;
ods graphics off;
