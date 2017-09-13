proc logistic data=train1 noprint;
   class res;
   model ins(event='1')=dda ddabal dep depamt checks res;
   score data=valid1 out=sco_validate(rename=(p_1=p_ch2));         
run;

proc logistic data=train1 noprint;
   model ins(event='1')=&selected;
   score data=sco_validate out=sco_validate(rename=(p_1=p_sel));         
run;

ods select ROCOverlay ROCAssociation ROCContrastTest;
proc logistic data=sco_validate;
   model ins(event='1')=p_ch2 p_sel / nofit;
   roc "Chapter 2 Model" p_ch2;
   roc "Chapter 4 Model" p_sel;
   roccontrast "Comparing the Two Models";
   title "Validation Data Set Performance";
run;

