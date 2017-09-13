/*----  Precision and Recall Statistics  ----*/
/*----  Two Standard Cutoffs: 0.5 and prior prob success  ----*/

%EM_REGISTER(KEY=ASSESS,TYPE=DATA);
%EM_REGISTER(KEY=ASSESS50,TYPE=DATA);
%EM_REGISTER(KEY=TEMP,TYPE=DATA);
%EM_REPORT(KEY=ASSESS,VIEWTYPE=DATA,AUTODISPLAY=Y);
%EM_REPORT(KEY=ASSESS50,VIEWTYPE=DATA,AUTODISPLAY=Y);
%EM_REPORT(KEY=TEMP,VIEWTYPE=DATA,AUTODISPLAY=Y);

%let PredVar=P_%sysfunc(strip(%EM_BINARY_TARGET))1;

data &EM_USER_TEMP;
   set &EM_IMPORT_DATA;
   keep %EM_BINARY_TARGET %EM_PREDICT &PredVar;
run;
proc freq data=&EM_USER_TEMP;
   tables %EM_BINARY_TARGET / out=&EM_USER_ASSESS(keep=%EM_BINARY_TARGET PERCENT);
run;
data _null_;
   set &EM_USER_ASSESS end=lastobs;
   if (lastobs) then do;
      file print;
      PERCENT=PERCENT/100;
      put "Cutoff: Prior Probability=" PERCENT=;
      put "EM_PREDICT vars: %EM_PREDICT";
      call symput("EM_USER_CUTOFF",PERCENT);
   end;
run;
data &EM_USER_TEMP;
   set &EM_USER_TEMP;
   Result=(&PredVar > &EM_USER_CUTOFF);
run;
proc freq data=&EM_USER_TEMP;
   tables %EM_BINARY_TARGET * Result / out=&EM_USER_ASSESS;
run;

data &EM_USER_ASSESS;
   set &EM_USER_ASSESS end=lastobs;
   retain Precision Recall TP TN FP FN 0;
   if (%EM_BINARY_TARGET eq 1) and (Result=1) then TP=COUNT;
   else if (%EM_BINARY_TARGET eq 1) and (Result=0) then FN=COUNT;
   else if (%EM_BINARY_TARGET eq 0) and (Result=1) then FP=COUNT;
   else if (%EM_BINARY_TARGET eq 0) and (Result=0) then TN=COUNT;
   if (lastobs) then do;
      Precision=100*TP/(TP+FP);
      Recall=100*TP/(TP+FN);
      Misclassification=100*(FP+FN)/(TP+FP+TN+FN);
      output;
   end;
   keep TP TN FP FN Precision Recall Misclassification;
run;

data &EM_USER_TEMP;
   set &EM_USER_TEMP;
   Result=(&PredVar > 0.5);
run;
proc freq data=&EM_USER_TEMP;
   tables %EM_BINARY_TARGET * Result / out=&EM_USER_ASSESS50;
run;

data &EM_USER_ASSESS50;
   set &EM_USER_ASSESS50 end=lastobs;
   retain Precision Recall TP TN FP FN 0;
   if (%EM_BINARY_TARGET eq 1) and (Result=1) then TP=COUNT;
   else if (%EM_BINARY_TARGET eq 1) and (Result=0) then FN=COUNT;
   else if (%EM_BINARY_TARGET eq 0) and (Result=1) then FP=COUNT;
   else if (%EM_BINARY_TARGET eq 0) and (Result=0) then TN=COUNT;
   if (lastobs) then do;
      Precision=100*TP/(TP+FP);
      Recall=100*TP/(TP+FN);
      Misclassification=100*(FP+FN)/(TP+FP+TN+FN);
      output;
   end;
   keep TP TN FP FN Precision Recall Misclassification;
run;

