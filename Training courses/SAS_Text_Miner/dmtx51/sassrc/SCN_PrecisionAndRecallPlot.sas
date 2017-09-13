/*----  Finer Recall vs. Precision Plot  ----*/

%EM_REGISTER(KEY=RANKS,TYPE=DATA);
%EM_REGISTER(KEY=ASSESS,TYPE=DATA);
%EM_REGISTER(KEY=ASSESST,TYPE=DATA);

%EM_REGISTER(KEY=ASSESSV,TYPE=DATA);

%EM_REPORT(KEY=ASSESS,VIEWTYPE=DATA,AUTODISPLAY=Y);
%EM_REPORT(KEY=ASSESST,VIEWTYPE=DATA,AUTODISPLAY=Y);

%EM_REPORT(KEY=ASSESST,VIEWTYPE=LINEPLOT,
           X=Recall,
           Y=Precision,
           TIPTEXT=BIN,
           AUTODISPLAY=Y,
           DESCRIPTION=%str(Train Recall vs. Precision Plot),
           Block=%str(Assessment Plots));
%EM_REPORT(KEY=ASSESST,VIEWTYPE=LINEPLOT,
           X=BIN,
           Y=Precision,
           AUTODISPLAY=Y,
           DESCRIPTION=%str(Train Precision Plot),
           Block=%str(Assessment Plots));
%EM_REPORT(KEY=ASSESST,VIEWTYPE=LINEPLOT,
           X=BIN,
           Y=Recall,
           AUTODISPLAY=Y,
           DESCRIPTION=%str(Train Recall Plot),
           Block=%str(Assessment Plots));
%EM_REPORT(KEY=ASSESSV,VIEWTYPE=DATA,AUTODISPLAY=Y);

%EM_REPORT(KEY=ASSESSV,VIEWTYPE=LINEPLOT,
           X=BIN,
           Y=Precision,
           AUTODISPLAY=Y,
           DESCRIPTION=%str(Validation Precision Plot),
           Block=%str(Assessment Plots));
%EM_REPORT(KEY=ASSESSV,VIEWTYPE=LINEPLOT,
           X=BIN,
           Y=Recall,
           AUTODISPLAY=Y,
           DESCRIPTION=%str(Validation Recall Plot),
           Block=%str(Assessment Plots));

%global TOTAL_EVENTS VALID_EVENTS PredVar 
        NumberBins BinWidth 
        BreakEvenTrain BreakEvenBin
        BreakEvenVal BreakEvenBinVal;

%let NumberBins=100;
%let BinWidth=1;

%let PredVar=P_%sysfunc(strip(%EM_BINARY_TARGET))1;

%macro PrecisionRecall();
   %if ("&EM_IMPORT_DATA" ne "") and
       (%sysfunc(exist(&EM_IMPORT_DATA)) or
        %sysfunc(exist(&EM_IMPORT_DATA, VIEW))) %then %do;
      data &EM_USER_RANKS;
         set &EM_IMPORT_DATA;
         keep %EM_BINARY_TARGET &PredVar;
      run;

      proc rank data=&EM_USER_RANKS out=&EM_USER_RANKS 
                groups=&NumberBins descending;
         var &PredVar;
         ranks BIN;
      run;

      proc freq data=&EM_USER_RANKS;
         tables BIN;
      run;

      proc summary data=&EM_USER_RANKS N SUM MIN MAX NWAY;
         class BIN;
         var %EM_BINARY_TARGET &PredVar;
         output out=&EM_USER_RANKS
                  N=NBT NPV
                SUM=SumBT SumPV
                MIN=MinBT MinPV
                MAX=MaxBT MaxPV;
      run;

      proc summary data=&EM_IMPORT_DATA n sum;
         var %EM_BINARY_TARGET;
         output out=&EM_USER_ASSESS
                n=n
                sum=sum;
      run;

      data _null_;
         set &EM_USER_ASSESS;
         call symput("TOTAL_EVENTS",sum);
         call symput("TOTAL_OBS",n);
      run;

      data &EM_USER_ASSESST;
         set &EM_USER_RANKS;
         retain TP -1 FP 0 TN 0 FN 0
                TotalEvents &TOTAL_EVENTS TotalObs &TOTAL_OBS;
         label BIN="Percentile"
               Misclass="Misclassification Rate"
               TP="True Positive"
               FP="False Positive"
               TN="True Negative"
               FN="False Negative"
               MinPV="Min Predicted Value"
               MaxPV="Max Predicted Value";
         BIN=BIN+1; 
         if (TP<0) then do;
            TP=SumBT;
            FP=NBT-SumBT;
            TN=TotalObs-TotalEvents-FP;
            FN=TotalObs-TP-FP-TN;
         end;
         else do;
            TP=sum(TP,SumBT);
            FP=sum(FP,NBT-SumBT);
            TN=TotalObs-TotalEvents-FP;
            FN=TotalObs-TP-FP-TN;
         end;
         Precision=100*TP/(TP+FP);
         Recall=100*TP/(TP+FN);
         Misclass=100*(FP+FN)/(TP+FP+TN+FN);
         keep BIN Precision Recall Misclass TP FP TN FN MinPV MaxPV;
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
               BE_Percentile=BIN-((&BinWidth)*Fraction);
               BreakEven=Precision-(Fraction*(Precision-LastPrecision));
               BE_Misclass=Misclass-(Fraction*(Misclass-LastMisclass));
               Cutoff=MaxPV-(Fraction*(MaxPV-MinPV));
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
               Cutoff=0;
            end;
            else do;
               BE_Percentile=100;
               BreakEven=(Precision+Recall)/2;
               BE_Misclass=Misclass;
               Cutoff=1;
            end;
            output;
         end;
         LastBE=BEven;
         LastPrecision=Precision;
         LastMisclass=Misclass;
         keep BreakEven BE_Percentile BE_Misclass Cutoff;
      run;
      data _null_;
         set &EM_USER_ASSESS;
         call symput("BreakEvenTrain",put(BreakEven,6.2));
         call symput("BreakEvenBin",put(BE_Percentile,6.2));
      run;
   %end;
   %else %do;
      %put WARNING: No training data set.;
   %end;
   %if ("&EM_IMPORT_VALIDATE" ne "") and
       (%sysfunc(exist(&EM_IMPORT_VALIDATE)) or
        %sysfunc(exist(&EM_IMPORT_VALIDATE, VIEW))) %then %do;
      data &EM_USER_RANKS;
         set &EM_IMPORT_VALIDATE;
         keep %EM_BINARY_TARGET &PredVar;
      run;

      proc rank data=&EM_USER_RANKS out=&EM_USER_RANKS 
                groups=&NumberBins descending;
         var &PredVar;
         ranks BIN;
      run;

      proc freq data=&EM_USER_RANKS;
         tables BIN;
      run;

      proc summary data=&EM_USER_RANKS N SUM MIN MAX NWAY;
         class BIN;
         var %EM_BINARY_TARGET &PredVar;
         output out=&EM_USER_RANKS
                  N=NBT NPV
                SUM=SumBT SumPV
                MIN=MinBT MinPV
                MAX=MaxBT MaxPV;
      run;

      proc summary data=&EM_IMPORT_VALIDATE n sum;
         var %EM_BINARY_TARGET;
         output out=&EM_USER_ASSESSV
                n=n
                sum=sum;
      run;

      data _null_;
         set &EM_USER_ASSESSV;
         call symput("TOTAL_EVENTS",sum);
         call symput("TOTAL_OBS",n);
      run;

      data &EM_USER_ASSESSV;
         set &EM_USER_RANKS;
         retain TP -1 FP 0 TN 0 FN 0
                TotalEvents &TOTAL_EVENTS TotalObs &TOTAL_OBS;
         label BIN="Percentile"
               Misclass="Misclassification Rate"
               TP="True Positive"
               FP="False Positive"
               TN="True Negative"
               FN="False Negative"
               MinPV="Min Predicted Value"
               MaxPV="Max Predicted Value";
         BIN=BIN+1; 
         if (TP<0) then do;
            TP=SumBT;
            FP=NBT-SumBT;
            TN=TotalObs-TotalEvents-FP;
            FN=TotalObs-TP-FP-TN;
         end;
         else do;
            TP=sum(TP,SumBT);
            FP=sum(FP,NBT-SumBT);
            TN=TotalObs-TotalEvents-FP;
            FN=TotalObs-TP-FP-TN;
         end;
         Precision=100*TP/(TP+FP);
         Recall=100*TP/(TP+FN);
         Misclass=100*(FP+FN)/(TP+FP+TN+FN);
         keep BIN Precision Recall Misclass TP FP TN FN MinPV MaxPV;
      run;

      data &EM_USER_RANKS;
         set &EM_USER_ASSESSV end=lastobs;
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
               BE_Percentile=BIN-((&BinWidth)*Fraction);
               BreakEven=Precision-(Fraction*(Precision-LastPrecision));
               BE_Misclass=Misclass-(Fraction*(Misclass-LastMisclass));
               Cutoff=MaxPV-(Fraction*(MaxPV-MinPV));
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
               Cutoff=0;
            end;
            else do;
               BE_Percentile=100;
               BreakEven=(Precision+Recall)/2;
               BE_Misclass=Misclass;
               Cutoff=1;
            end;
            output;
         end;
         LastBE=BEven;
         LastPrecision=Precision;
         LastMisclass=Misclass;
         keep BreakEven BE_Percentile BE_Misclass Cutoff;
      run;
      data _null_;
         set &EM_USER_RANKS;
         call symput("BreakEvenVal",put(BreakEven,6.2));
         call symput("BreakEvenBinVal",put(BE_Percentile,6.2));
      run;
      data &EM_USER_ASSESS;
         set &EM_USER_ASSESS(in=in1)
             &EM_USER_RANKS(in=in2);
         attrib DataRole length=$8 label="Data Role";
         if (in1=1) then DataRole="Train";
         else DataRole="Validate"; 
      run;
   %end;
   %else %do;
      %put WARNING: No validation data set.;
   %end;
%mend PrecisionRecall;

%PrecisionRecall();

/*----  Must appear here AFTER XREF macro variable is defined  ----*/
%EM_REPORT(KEY=ASSESST,VIEWTYPE=LINEPLOT,
           X=Precision,
           XREF=&BreakEvenTrain,
           Y1=Recall,
           Y2=Misclass,
           YREF=&BreakEvenTrain,
           TIPTEXT=BIN,
           AUTODISPLAY=Y,
           DESCRIPTION=%str(Train Precision/Recall Plot),
           Block=%str(Assessment Plots));
%EM_REPORT(KEY=ASSESSV,VIEWTYPE=LINEPLOT,
           X=Precision,
           XREF=&BreakEvenVal,
           Y1=Recall,
           Y2=Misclass,
           YREF=&BreakEvenVal,
           TIPTEXT=BIN,
           AUTODISPLAY=Y,
           DESCRIPTION=%str(Validation Precision/Recall Plot),
           Block=%str(Assessment Plots));
