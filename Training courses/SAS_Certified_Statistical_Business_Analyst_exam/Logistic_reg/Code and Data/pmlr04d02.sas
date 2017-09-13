ods select roccurve scorefitstat;
proc logistic data=train1;
   model ins(event='1')=&selected;
   score data=valid1 out=scoval 
         priorevent=&pi1 outroc=roc fitstat;
run;

proc print data=roc(obs=10);
   var _prob_ _sensit_ _1mspec_;
run;

data roc;
   set roc;
   cutoff=_PROB_;
   specif=1-_1MSPEC_;
   tp=&pi1*_SENSIT_;
   fn=&pi1*(1-_SENSIT_);
   tn=(1-&pi1)*specif;
   fp=(1-&pi1)*_1MSPEC_;
   depth=tp+fp;
   pospv=tp/depth;
   negpv=tn/(1-depth);
   acc=tp+tn;
   lift=pospv/&pi1;
   keep cutoff tn fp fn tp 
        _SENSIT_ _1MSPEC_ specif depth
        pospv negpv acc lift;
run;

/* Create a lift chart */
proc sgplot data=roc;
   where 0.005 <= depth <= 0.50;
   title "Lift Chart for Validation Data";
   series y=lift x=depth;
   refline 1.0 / axis=y;
   yaxis values=(0 to 8 by 1);
run; quit;
