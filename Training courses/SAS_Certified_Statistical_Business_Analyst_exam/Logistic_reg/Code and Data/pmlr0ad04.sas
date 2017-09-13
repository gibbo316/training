proc fastclus data=train impute outiter outseed=seed out=train1 maxclusters=5;
   var &inputs;
run;

proc fastclus data=valid impute seed=seed(where=(_iter_=1)) replace=none 
              maxclusters=5 out=validate1 maxiter=0;
   var &inputs;
run;

