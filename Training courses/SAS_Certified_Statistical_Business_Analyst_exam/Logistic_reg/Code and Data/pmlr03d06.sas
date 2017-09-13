/* The spike at 0 on the DDABal axis merits consideration */
title;
proc means data=imputed mean min max;
   class dda;
   var ddabal ins;
run;

/* A possible remedy for that non-linearity is to replace */
/* the logical imputation of 0 for non-DDA customers with */
/* the mean or the median.                                */
proc sql;
   select mean(ddabal) into :mean 
   from imputed where dda;
quit;

data imputed;
   set imputed;
   if not dda then ddabal = &mean;
run;

/* Create new logit plots */
%let var=DDABal;

proc rank data=imputed groups=100 out=out;
   var &var;
   ranks bin;
run;

proc means data=out noprint nway;
   class bin;
   var ins &var;
   output out=bins sum(ins)=ins mean(&var)=&var;
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

/* Using the binned values of DDABal may make     */
/* for a more linear relationship between the     */
/* input and the target. The following code       */
/* creates DATA step code to bin DDABal, yielding */
/* a new predictor, B_DDABal.                     */

/* Rank the observations. */
proc rank data=imputed groups=100 out=out;
   var ddabal;
   ranks bin;
run;

/* Save the endpoints of each bin */
title;
proc means data = out noprint nway;
   class bin;
   var ddabal;
   output out=endpts max=max;
run;

proc print data = endpts(obs=10);
run;

/* Create a filename to write code to. */
filename rank "S:\workshop\rank.sas";

/* Write the code to assign individuals to */
/* bins according to the DDABal.           */
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

/* Use the code. */
data imputed;
   set imputed;
   %include rank / source;
run;

proc means data = imputed min max;
   class B_DDABal;
   var DDABal;
run;

/* Switch the binned DDABal (B_DDABal) for the */
/* originally scaled DDABal input in the list  */
/* of potential inputs.                        */
%let screened =  
brclus2 checks ccbal 
mmbal income ilsbal posamt 
nsfamt cd irabal age 
sav dda invbal
crscore brclus3 cc brclus1 
cashbk miacctag micrscor moved 
acctage dirdep savbal B_DDABAL 
sdb ccpurc inarea atmamt 
phone mmcred inv 
depamt brclus4 atm lores;
