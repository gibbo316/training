/*st007s02*/
ods graphics / imagemap=on;
ods listing close;
ods html file='reg_cp2.html'
         style=statistical;

proc reg data=st092.BodyFat2 plots(only)=(cp);
   model PctBodyFat2 = Age Weight Height
        Neck Chest Abdomen Hip Thigh
        Knee Ankle Biceps Forearm Wrist
        / selection=cp best=60;
   title "Using Mallows Cp for Model Selection";
run;
quit;

ods html close;
ods listing;


ods graphics;
proc reg data=st092.BodyFat2 plots(only)=adjrsq;
   FORWARD:  model PctBodyFat2 = Age Weight Height
             Neck Chest Abdomen Hip Thigh
             Knee Ankle Biceps Forearm Wrist
             / selection=forward;
   BACKWARD: model PctBodyFat2 = Age Weight Height
             Neck Chest Abdomen Hip Thigh
             Knee Ankle Biceps Forearm Wrist
             / selection=backward;
   STEPWISE: model PctBodyFat2 = Age Weight Height
             Neck Chest Abdomen Hip Thigh
             Knee Ankle Biceps Forearm Wrist
             / selection=stepwise;
   title "Using Stepwise Methods for Model Selection";
run;
quit;

ods graphics;
proc reg data=st092.BodyFat2 plots(only)=adjrsq;
   FORWARD05:model PctBodyFat2 = Age Weight Height
             Neck Chest Abdomen Hip Thigh
             Knee Ankle Biceps Forearm Wrist
             / selection=forward slentry=0.05;
   title "Using Forward Stepwise with SLENTRY=0.05";
run;
quit;

ods graphics;
proc reg data=st092.BodyFat2 plots(only)=(QQ 
					RESIDUALBYPREDICTED
					RESIDUALHISTOGRAM 
                    RESIDUALPLOT
					RSTUDENTBYPREDICTED);;
   FORWARD05:model PctBodyFat2 = Age Weight Height
             Neck Chest Abdomen Hip Thigh
             Knee Ankle Biceps Forearm Wrist
             / selection=forward slentry=0.05;
   title "Using Forward Stepwise with SLENTRY=0.05";
run;
quit;
