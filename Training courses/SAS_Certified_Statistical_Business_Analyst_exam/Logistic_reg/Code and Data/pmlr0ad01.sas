/* Automatically generate DATA step */
/* code that scores a new data set  */

/* Use ODS to output the parameter estimates */
ods output parameterEstimates = betas2;
proc logistic data=develop des;
   model ins=dda ddabal dep depamt cashbk checks;
run;

proc print data=betas2;
var variable estimate;
run;

/* Generate scoring code */
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

/* Use scoring code */
data scored;
set pmlr.new;
%include "c:\temp\logistic score code.sas" /source2;
run;

/* Use scoring code */
data scored;
set pmlr.new;
%include scorecd /source2;
run;

proc print data=scored(obs=20);
   var p_ins xbeta dda ddabal dep depamt cashbk checks;
run;
