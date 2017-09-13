%let var=DDABal;

/* Group the data by the variable of interest */
/* in order to create empirical logit plots   */
proc rank data=imputed groups=100 out=out;
   var &var;
   ranks bin;
run;

proc print data=out(obs=10);
   var &var bin;
run;

/* The data set BINS will contain:          */
/* INS = the count of successes in each bin */
/* _FREQ_ = the count of trials in each bin */
/* DDABAL = the avg DDABAL in each bin      */
proc means data=out noprint nway;
   class bin;
   var ins &var;
   output out=bins sum(ins)=ins mean(&var)=&var;
run;

proc print data=bins(obs=10);
run;

/* Calculate the empirical logit */ 
data bins;
   set bins;
   elogit=log((ins+(sqrt(_FREQ_ )/2))/
          ( _FREQ_ -ins+(sqrt(_FREQ_ )/2)));
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
