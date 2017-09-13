proc sort data=pva1 out=pva1;
   by target_b;
run;

proc surveyselect noprint
                  data=pva1
                  samprate=.5 
                  out=pva1
                  seed=27513
                  outall;
   strata target_b;
run;

data pva_train pva_valid;
   set pva1;
   if selected then output pva_train;
   else output pva_valid;
run;

proc logistic data=pva_train;
   model target_b(event='1')=&ex_selected;
   score data=pva_valid priorevent=&ex_pi1 outroc=roc fitstat;
run;

data roc;
   set roc;
   cutoff=_PROB_;
   specif=1-_1MSPEC_;
   tp=&ex_pi1*_SENSIT_;
   fn=&ex_pi1*(1-_SENSIT_);
   tn=(1-&ex_pi1)*specif;
   fp=(1-&ex_pi1)*_1MSPEC_;
   depth=tp+fp;
   pospv=tp/depth;
   negpv=tn/(1-depth);
   acc=tp+tn;
   lift=pospv/&ex_pi1;
   keep cutoff tn fp fn tp 
        _SENSIT_ _1MSPEC_ specif depth
        pospv negpv acc lift;
run;

proc sgplot data=roc;
   where 0.005 <= depth <= 0.50;
   title "Lift Chart for Validation Data";
   series y=lift x=depth;
   refline 1.0 / axis=y;
   yaxis values=(0 to 4 by 1);
run; quit;
