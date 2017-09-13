data train2;
   set train2;
   resr=(res="R");
   resu=(res="U");
   if not dda then ddabal = &mean;
   brclus1=(branch='B14');
   brclus2=(branch in ('B12','B5','B8',
                       'B3','B18','B19','B17',
                       'B4','B6','B10','B9',
                       'B1','B13'));
   brclus3=(branch in ('B15','B16'));
   %include rank;
   if savbal > 16000 then savbal=16000;
run;

data valid2;
   set valid2;
   resr=(res="R");
   resu=(res="U");
   if not dda then ddabal = &mean;
   brclus1=(branch='B14');
   brclus2=(branch in ('B12','B5','B8',
                       'B3','B18','B19','B17',
                       'B4','B6','B10','B9',
                       'B1','B13'));
   brclus3=(branch in ('B15','B16'));
   %include rank;
   if savbal > 16000 then savbal=16000;
run;

ods html close;
ods output bestsubsets=score;

proc logistic data=train2;
   model ins(event='1')=&screened 
   / selection=SCORE best=2;
run;

ods html;

proc sql noprint;
  select variablesinmodel into :inputs1 - :inputs99999 
  from score;
  select NumberOfVariables into :ic1 - :ic99999 
  from score;
quit;

%let lastindx = &SQLOBS;

%include "s:\workshop\pmlr04d06a.sas";

%include "s:\workshop\pmlr04d06b.sas";

%fitandscore(data_train=train2,data_validate=valid2,target=ins);

proc print data = results(obs=10);
   title "Model Performance Measures for Training and Validation Data Sets";
run;

proc sgplot data=results;
   where index > 12;
   series y=c x=index / group=datarole markerattrs=(symbol=circle) markers;
   yaxis label="C Statistic" Values=(0.770 to 0.790 by 0.001);
   xaxis label="Model Number" Values=(15 to 70 by 5);
   title "C Statistics by Model";
run;

proc sgplot data=results;
   where index > 12;
   series y=overall_avg_profit x=index / 
           group=datarole markerattrs=(symbol=plus) markers;
   yaxis label="Overall Average Profit" Values=(1.210 to 1.260 by 0.010);
   xaxis label="Model Number" Values=(15 to 70 by 5);
   title "Overall Average Profit by Model";
run;

proc logistic data=train2;
   model ins(event='1')=&inputs48;
   score data=valid2 out=scoval2 fitstat;
   title "Logistic Model with Highest Profit";
run;


