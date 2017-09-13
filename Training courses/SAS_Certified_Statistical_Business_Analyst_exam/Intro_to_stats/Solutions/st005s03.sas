/*st005s03.sas*/
proc corr data=st092.BodyFat2 nosimple 
          plots=matrix(nvar=all histogram);
   var Age Weight Height;
   title "Correlations and Scatter Plot Matrix of Basic "
         "Measures";
run;

proc corr data=st092.BodyFat2 nosimple 
          plots=matrix(nvar=all histogram);
   var Neck Chest Abdomen Hip Thigh
       Knee Ankle Biceps Forearm Wrist;
   title "Correlations and Scatter Plot Matrix of "
         "Circumferences";
run;
proc corr data=st092.BodyFat2 nosimple 
          plots=matrix(nvar=10 histogram);
   var Neck Chest Abdomen Hip Thigh
            Knee Ankle Biceps Forearm Wrist;
   with Age Weight Height;
   title "Correlations and Scatter Plot Matrix between";
   title2 "Basic Measures and Circumferences";
run;
