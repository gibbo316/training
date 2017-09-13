/*st005s01.sas*/
ods graphics;
ods listing close;
ods rtf file='bodyfat.rtf' style=statistical;
ods select histogram probplot;
proc univariate data=st092.BodyFat;
   var PctBodyFat2 Age Weight Height
         Neck Chest Abdomen Hip Thigh
         Knee Ankle Biceps Forearm Wrist;
   histogram / normal (mu=est sigma=est);
   probplot / normal (mu=est sigma=est);
   inset skewness kurtosis;
   title "Predictors of % Body Fat";
run;
ods rtf close;
ods listing;


data st092.BodyFat2;
   set st092.BodyFat;
   if Height=29.5 then Height=69.5;
run;
