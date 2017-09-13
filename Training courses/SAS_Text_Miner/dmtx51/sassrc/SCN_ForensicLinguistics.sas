/*----  SCN_ForensicLinguistics.sas  ----*/
/*----  Training Results  ----*/
%let TargetVar=%scan(%EM_NOMINAL_TARGET,1,%str( ));
%let IntoVar=I_&TargetVar;
%let Suspect=TK;

%EM_REGISTER(Key=TRN,TYPE=DATA);
%EM_REPORT(Key=TRN,
           VIEWTYPE=BAR,
           X=&TargetVar,GROUP=&IntoVar,
           AUTODISPLAY=Y,
           DESCRIPTION=Traing Data Classification Results,
           BLOCK=Classification Bar Charts);
data &EM_USER_TRN;
   set &EM_IMPORT_DATA;
   keep &TargetVar &IntoVar;
run;
title1 "Training Data Results";
proc freq data=&EM_USER_TRN;
   table &TargetVar*&IntoVar / list missing;
run;
/*----  Validation Results  ----*/
%EM_REGISTER(Key=VAL,TYPE=DATA);
%EM_REPORT(Key=VAL,
           VIEWTYPE=BAR,
           X=&TargetVar,GROUP=&IntoVar,
           AUTODISPLAY=Y,
           DESCRIPTION=Validation Data Classification Results,
           BLOCK=Classification Bar Charts);
data &EM_USER_VAL;
   set &EM_IMPORT_VALIDATE;
   keep &TargetVar &IntoVar;
run;
title1 "Validation Results";
proc freq data=&EM_USER_VAL;
   table &TargetVar*&IntoVar / list missing;
run;
proc freq data=&EM_USER_VAL;
   table &TargetVar*&IntoVar / missing;
run;

%EM_REGISTER(Key=SCR,TYPE=DATA);
%EM_REPORT(Key=SCR,
           VIEWTYPE=BAR,
           X=&IntoVar,
           AUTODISPLAY=Y,
           DESCRIPTION=Score Data Classification Results,
           BLOCK=Classification Bar Charts);
data &EM_USER_SCR;
   set &EM_IMPORT_SCORE;
   keep &IntoVar;
run;
title1 "Score Results";
proc freq data=&EM_USER_SCR;
   table &IntoVar / list missing;
run;

%macro GetNumObs(DSNAME);
   %local DSID RC;
   %if %sysfunc(exist(&DSNAME)) %then %do;
      %let DSID=%sysfunc(open(&DSNAME));
      %if (&DSID eq 0) %then %do;
         0
      %end;
      %else %do;
         %sysfunc(attrn(&DSID,NOBS))
         /*----  Must use LET because close has a return code  ----*/
         %let RC=%sysfunc(close(&DSID));
      %end;
   %end;
   %else %do;
      0
   %end;
%mend GetNumObs;
%macro TargetFromTo(DSName=,FromVar=,ToVar=);
   %local VarNum CatName;
   %EM_REGISTER(KEY=TEMP,TYPE=DATA);
   %EM_REPORT(KEY=TEMP,VIEWTYPE=DATA);
   proc freq data=&DSname noprint;
      tables &FromVar / out=&EM_USER_TEMP;
   run;

   %let NumObs=%GetNumObs(&EM_USER_TEMP);

   %do VarNum=1 %to &NumObs;
      data _null_;
         set &EM_USER_TEMP(firstobs=&VarNum obs=&VarNum);
         call symput("CatName",&FromVar);
      run;
      title1 "&FromVar Value %sysfunc(strip(&CatName))";
      proc freq data=&DSName(where=(&FromVar="%sysfunc(strip(&CatName))"));
         tables &ToVar;
      run;

   %end;
   title1 ;

%mend TargetFromTo;

%TargetFromTo(DSName=&EM_IMPORT_VALIDATE,FromVar=&TargetVar,ToVar=&IntoVar);
