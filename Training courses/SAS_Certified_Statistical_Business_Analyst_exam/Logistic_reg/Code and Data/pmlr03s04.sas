ods html close;
ods output spearmancorr=spearman
           hoeffdingcorr=hoeffding;

proc corr data=pva1 spearman hoeffding rank;
   var &ex_reduced;
   with target_b;
run;

ods html;

data spearman1(keep=variable scorr spvalue ranksp);
   length variable $ 32;
   set spearman;
   array best(*) best1--best&ex_nvar;
   array r(*) r1--r&ex_nvar;
   array p(*) p1--p&ex_nvar;
   do i=1 to dim(best);
      variable=best(i);
      scorr=r(i);
      spvalue=p(i);
      ranksp=i;
      output;
   end;
run;

data hoeffding1(keep=variable hcorr hpvalue rankho);
   length variable $ 32;
   set hoeffding;
   array best(*) best1--best&ex_nvar;
   array r(*) r1--r&ex_nvar;
   array p(*) p1--p&ex_nvar;
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
   var variable ranksp rankho;
   label ranksp = 'Spearman rank*of variables'
         rankho = 'Hoeffding rank*of variables';
   title "Ranks of Variables Based on Spearman and Hoeffding";
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
run; quit;

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

%let var = LIFETIME_GIFT_RANGE;
proc rank data=pva1 groups=10 out=out;
   var &var;
   ranks bin;
run;

proc means data=out noprint nway;
   class bin;
   var target_b &var;
   output out=bins sum(target_b)=target_b 
          mean(&var)=&var;
run;

data bins;
   set bins;
   elogit=log((target_b+(sqrt(_FREQ_ )/2))/
          ( _FREQ_ -target_b+(sqrt(_FREQ_ )/2)));
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
