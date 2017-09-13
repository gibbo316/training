%macro fitandscore(data_train=,data_validate=,target=);

proc datasets 
    library=work 
    nodetails 
    nolist;
    delete results;
run;

%do model_indx=1 %to &lastindx;

%let im=&&inputs&model_indx;
%let ic=&&ic&model_indx;

proc logistic data=&data_train;
  model &target(event='1')=&im;
  score data=&data_train 
        out=scoredtrain(keep=ins p_1 p_0)
        priorevent=&pi1;
  score data=&data_validate 
        out=scoredvalid(keep=ins p_1 p_0)
        priorevent=&pi1;
run;

%assess(data=TRAIN,inputcount=&ic,inputsinmodel=&im,index=&model_indx,
        pi1=0.02,rho1=0.346,target=ins,profit11=99,profit01=-1,
        profit10=0,profit00=0);
%assess(data=VALID,inputcount=&ic,inputsinmodel=&im,index=&model_indx,
        pi1=0.02,rho1=0.346,target=ins,profit11=99,profit01=-1,
        profit10=0,profit00=0);

%end;
%mend fitandscore;
