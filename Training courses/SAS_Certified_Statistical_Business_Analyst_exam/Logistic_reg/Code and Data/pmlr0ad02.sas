%let pi1=.02;

proc SQL noprint;
  select mean(INS) into :rho1 from develop;
quit;

ods output parameterEstimates=betas2;
proc logistic data=develop des;
   model ins=dda ddabal dep depamt cashbk checks;
run;

%let target=INS;
filename scorecd 'c:\temp\logistic score code.sas';

data _null_;
   attrib PREDNAME length=$32
          TARGNAME length=$32
          LastParm length=$32
          ;
   file scorecd;
   set betas2 end=last;
   retain TARGNAME PREDNAME LastParm ' ';
   if (Variable="Intercept") then do;
      TARGNAME=compress("&target");
      PREDNAME="P_"||compress(TARGNAME);
      put "**********************************************;";
      put "*** begin scoring code for Logistic Regression;";
      put "**********************************************;";

      put "length " PREDNAME "8;";
      put "label " PREDNAME "= 'Predicted: " TARGNAME +(-1) "';";

      put "*** accumulate XBETA;";
      Estimate + (-log(((1-&pi1)*&rho1)/(&pi1*(1-&rho1))));
      put "XBETA = " Estimate best20. ";";
   end;
   else if (ClassVal0=' ') then do;
      put "XBETA = XBETA + (" Estimate best20. ") * " Variable ";";
   end;
   else if (compress(Variable)=compress(LastParm)) then do;
      put "else if (" Variable "='" ClassVal0 +(-1) "') then do;";
      put "   XBETA = XBETA + (" Estimate best20. ");";
      put "end;";
   end;
   else do;
      put "if (" Variable "='" ClassVal0 +(-1) "') then do;";
      put "   XBETA = XBETA + (" Estimate best20. ");";
      put "end;";
   end;
   LastParm=Variable;
   if last then do;
      put PREDNAME "= 1/(1+exp(-XBETA));";
   end;
run;

**********************************************;
*** begin scoring code for Logistic Regression;
**********************************************;
length P_INS 8;
label P_INS = 'Predicted: INS';
*** accumulate XBETA;
XBETA =    -3.13082398583352;
XBETA = XBETA + (   -0.97052008343956) * DDA ;
XBETA = XBETA + (    0.00007181904404) * DDABal ;
XBETA = XBETA + (   -0.07153101800749) * Dep ;
XBETA = XBETA + (     0.0000178287498) * DepAmt ;
XBETA = XBETA + (   -0.56175142056463) * CashBk ;
XBETA = XBETA + (   -0.00399923596541) * Checks ;
P_INS = 1/(1+exp(-XBETA));

data scored;
   set pmlr.new;
   %include scorecd /source2;
run;

proc print data=scored(obs=20);
   var p_ins dda ddabal dep depamt cashbk checks;
run;
