/*----  Precision and Recall using EM_IMPORT_RANK  ----*/

%global TRAIN_EVENTS VALID_EVENTS;
%EM_REGISTER(KEY=ASSESST,TYPE=DATA);
%EM_REGISTER(KEY=ASSESSV,TYPE=DATA);
%EM_REGISTER(KEY=ASSESS,TYPE=DATA);
%EM_REPORT(KEY=ASSESS,VIEWTYPE=DATA,AUTODISPLAY=Y);
%EM_REPORT(KEY=ASSESST,VIEWTYPE=DATA,AUTODISPLAY=Y);
%EM_REPORT(KEY=ASSESST,VIEWTYPE=LINEPLOT,
           X=Precision,
           Y1=Recall,
           Y2=Misclass,
           TIPTEXT=DECILE,
           AUTODISPLAY=Y,
           DESCRIPTION=%str(Train Precision/Recall Plot),
           Block=%str(Assessment Plots));
%EM_REPORT(KEY=ASSESST,VIEWTYPE=LINEPLOT,
           X=Recall,
           Y=Precision,
           TIPTEXT=DECILE,
           AUTODISPLAY=Y,
           DESCRIPTION=%str(Train Recall vs. Precision Plot),
           Block=%str(Assessment Plots));
%EM_REPORT(KEY=ASSESST,VIEWTYPE=LINEPLOT,
           X=DECILE,
           Y=Precision,
           AUTODISPLAY=Y,
           DESCRIPTION=%str(Train Precision Plot),
           Block=%str(Assessment Plots));
%EM_REPORT(KEY=ASSESST,VIEWTYPE=LINEPLOT,
           X=DECILE,
           Y=Recall,
           AUTODISPLAY=Y,
           DESCRIPTION=%str(Train Recall Plot),
           Block=%str(Assessment Plots));
%EM_REPORT(KEY=ASSESSV,VIEWTYPE=DATA,AUTODISPLAY=Y);
%EM_REPORT(KEY=ASSESSV,VIEWTYPE=LINEPLOT,
           X=Precision,
           Y1=Recall,
           Y2=Misclass,
           TIPTEXT=DECILE,
           AUTODISPLAY=Y,
           DESCRIPTION=%str(Validation Precision/Recall Plot),
           Block=%str(Assessment Plots));
%EM_REPORT(KEY=ASSESSV,VIEWTYPE=LINEPLOT,
           X=DECILE,
           Y=Precision,
           AUTODISPLAY=Y,
           DESCRIPTION=%str(Validation Precision Plot),
           Block=%str(Assessment Plots));
%EM_REPORT(KEY=ASSESSV,VIEWTYPE=LINEPLOT,
           X=DECILE,
           Y=Recall,
           AUTODISPLAY=Y,
           DESCRIPTION=%str(Validation Recall Plot),
           Block=%str(Assessment Plots));

proc summary data=&EM_IMPORT_DATA n sum;
   var %EM_BINARY_TARGET;
   output out=&EM_USER_ASSESST
          n=n
          sum=sum;
run;

data _null_;
   set &EM_USER_ASSESST;
   call symput("TRAIN_EVENTS",sum);
   call symput("TRAIN_OBS",n);
run;

proc summary data=&EM_IMPORT_VALIDATE n sum;
   var %EM_BINARY_TARGET;
   output out=&EM_USER_ASSESST
          n=n
          sum=sum;
run;

data _null_;
   set &EM_USER_ASSESST;
   call symput("VALID_EVENTS",sum);
   call symput("VALID_OBS",n);
run;

data &EM_USER_ASSESST;
   set &EM_IMPORT_RANK(where=(dataRole="TRAIN"));
   retain TP -1 FP 0 TN 0 FN 0
          TotalEvents &TRAIN_EVENTS TotalObs &TRAIN_OBS; 
   if (TP<0) then do;
      TP=NUMBEROFEVENTS;
      FP=NUMNEVENT;
      TN=TotalObs-TotalEvents-FP;
      FN=TotalObs-TP-FP-TN;
   end;
   else do;
      TP=sum(TP,NUMBEROFEVENTS);
      FP=sum(FP,NUMNEVENT);
      TN=TotalObs-TotalEvents-FP;
      FN=TotalObs-TP-FP-TN;
   end;
   Precision=100*TP/(TP+FP);
   Recall=100*TP/(TP+FN);
   Misclass=100*(FP+FN)/(TP+FP+TN+FN);
   keep DECILE Precision Recall Misclass TP FP TN FN;
run;

data &EM_USER_ASSESS;
   set &EM_USER_ASSESST end=lastobs;
   attrib Breakeven     length=8 label="Break Even Precision/Recall"
          BE_Percentile length=8 label="Break Even Percentile"
          BE_Misclass   length=8 label="Break Even Misclassification";
   retain BreakEven 0 BEven 100 LastBE . LastPrecision . LastMisclass .
          BE_Percentile 0 BE_Misclass 0 Fraction .
          FirstPrecision 0 FirstRecall 0 FirstMisclass 0;
   BEven=Precision-Recall;
   if (LastBE>.Z) then do;
      /*----  Cross=Different signs  ----*/
      if (BEven*LastBE<0) then do;
         Fraction=BEven/(BEven-LastBE);
         BE_Percentile=DECILE-(5*Fraction);
         BreakEven=Precision-(Fraction*(Precision-LastPrecision));
         BE_Misclass=Misclass-(Fraction*(Misclass-LastMisclass));
         output;
         stop;
      end;
   end;
   else do;
      FirstPrecision=Precision;
      FirstRecall=Recall;
      FirstMisclass=Misclass;
   end;
   /*----  Never crossed, so endpoint  ----*/
   if (lastobs) then do;
      if (abs(FirstPrecision-FirstRecall)<abs(Precision-Recall)) then do;
         BE_Percentile=0;
         BreakEven=(FirstPrecision+FirstRecall)/2;
         BE_Misclass=FirstMisclass;
      end;
      else do;
         BE_Percentile=100;
         BreakEven=(Precision+Recall)/2;
         BE_Misclass=Misclass;
      end;
      output;
   end;
   LastBE=BEven;
   LastPrecision=Precision;
   LastMisclass=Misclass;
   keep BreakEven BE_Percentile BE_Misclass;
run;

data &EM_USER_ASSESSV;
   set &EM_IMPORT_RANK(where=(dataRole="VALIDATE"));
   retain TP -1 FP 0 TN 0 FN 0
          TotalEvents &VALID_EVENTS TotalObs &VALID_OBS;
   if (TP<0) then do;
      TP=NUMBEROFEVENTS;
      FP=NUMNEVENT;
      TN=TotalObs-TotalEvents-FP;
      FN=TotalObs-TP-FP-TN;
   end;
   else do;
      TP=sum(TP,NUMBEROFEVENTS);
      FP=sum(FP,NUMNEVENT);
      TN=TotalObs-TotalEvents-FP;
      FN=TotalObs-TP-FP-TN;
   end;
   Precision=100*TP/(TP+FP);
   Recall=100*TP/(TP+FN);
   Misclass=100*(FP+FN)/(TP+FP+TN+FN);
   keep DECILE Precision Recall Misclass TP FP TN FN;
run;


/*----  Contents of EM_RANK  ----*\

12    BASECAP               Num       8    Baseline % Captured Response
13    BASECAPC              Num       8    Baseline Cumulative % Captured Response
32    BASEGAIN              Num       8    Baseline Gain
35    BASELIFT              Num       8    Baseline Lift
36    BASELIFTC             Num       8    Baseline Cumulative Lift
23    BASENUMBEROFEVENTS    Num       8    Baseline Number of Events
10    BASERESP              Num       8    Baseline % Response
11    BASERESPC             Num       8    Baseline Cumulative % Response
24    BESTCAP               Num       8    Best % Captured Response
22    BESTCAPC              Num       8    Best Cumulative % Captured Response
30    BESTGAIN              Num       8    Best Gain
25    BESTLIFT              Num       8    Best Lift
26    BESTLIFTC             Num       8    Best Cumulative Lift
21    BESTNUMBEROFEVENTS    Num       8    Best Number of Events
27    BESTRESP              Num       8    Best % Response
29    BESTRESPC             Num       8    Best Cumulative % Response
37    BIN                   Num       8    Bin
 8    CAP                   Num       8    % Captured Response
 9    CAPC                  Num       8    Cumulative % Captured Response
14    DECILE                Num       8    Percentile
 6    EVENT                 Char     32    Event
31    GAIN                  Num       8    Gain
33    LIFT                  Num       8    Lift
34    LIFTC                 Num       8    Cumulative Lift
 2    MODEL                 Char     16    Model Node
 3    MODELDESCRIPTION      Char     81    Model Description
17    N                     Num       8    Number of Observations
19    NUMBEROFEVENTS        Num       8    Number of Events
20    NUMNEVENT             Num       8    Number of Nonevents
 1    PARENT                Char     16    Predecessor Node
28    RESP                  Num       8    % Response
 7    RESPC                 Num       8    Cumulative % Response
16    _MAXP_                Num       8    Max Posterior Probability
18    _MEANP_               Num       8    Mean Posterior Probability
15    _MINP_                Num       8    Min Posterior Probability
 5    dataRole              Char     20    Data Role
 4    target                Char     32    Target Variable

*/
