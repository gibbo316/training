/*st007s01*/
proc reg data=st092.BodyFat2;
   model PctBodyFat2 = Age Weight Height
         Neck Chest Abdomen Hip Thigh
         Knee Ankle Biceps Forearm Wrist;
   title 'Regression of PctBodyFat2 on All Predictors';
run;
quit;

proc reg data=st092.BodyFat2;
   model PctBodyFat2 = Age Weight Height
         Neck Chest Abdomen Hip Thigh
         Ankle Biceps Forearm Wrist;
   title 'Remove Knee';
run;
quit;

proc reg data=st092.BodyFat2;
   model PctBodyFat2 = Age Weight Height
         Neck Abdomen Hip Thigh
         Ankle Biceps Forearm Wrist;
   title 'Remove Knee and Chest';
run;
quit;
