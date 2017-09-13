ods html close;
ods output spearmancorr=spearman
           hoeffdingcorr=hoeffding;

proc corr data=imputed spearman hoeffding rank;
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
   title "Rank of Spearman Correlations and Hoeffding Correlations";
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

title;
%let screened =  
brclus2 checks ccbal 
mmbal income ilsbal posamt 
nsfamt cd irabal age 
sav dda invbal
crscore brclus3 cc brclus1 
cashbk miacctag micrscor moved 
acctage dirdep savbal ddabal 
sdb ccpurc inarea atmamt 
phone mmcred inv 
depamt brclus4 atm lores;
