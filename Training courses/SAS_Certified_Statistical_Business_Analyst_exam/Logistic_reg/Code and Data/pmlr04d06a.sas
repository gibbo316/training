%macro assess(data=,inputcount=,inputsinmodel=,index=,pi1=,rho1=,target=,
              profit11=,profit01=,profit10=,profit00=);

%let rho0 = %sysevalf(1-&rho1);
%let pi0 = %sysevalf(1-&pi1);

proc sort data=scored&data;
  by descending p_1;
run;

/* create assessment data set */
data assess;
  attrib DATAROLE length=$5;
  retain sse 0 csum 0 DATAROLE "&data";

  /* 2 x 2 count array, or count matrix */
  array n[0:1,0:1] _temporary_ (0 0 0 0);
  /* sample weights array */
  array w[0:1] _temporary_ 
    (%sysevalf(&pi0/&rho0) %sysevalf(&pi1/&rho1));
  keep DATAROLE INPUT_COUNT INDEX 
       TOTAL_PROFIT OVERALL_AVG_PROFIT ASE C;

  set scored&data end=last;
/* profit associated with each decision */
  d1=&Profit11*p_1+&Profit01*p_0;
  d0=&Profit10*p_1+&Profit00*p_0;  

/* T is a flag for response */
  t=(strip(&target)="1");
/* D is the decision, based on profit. */
  d=(d1>d0);
  
/* update the count matrix, sse, and c */
  n[t,d] + w[t];
  sse + (&target-p_1)**2;
  csum + ((n[1,1]+n[1,0])*(1-t)*w[0]);

  if last then do;
    INPUT_COUNT=&inputcount;
    TOTAL_PROFIT = sum(&Profit11*n[1,1],&Profit10*n[1,0],
                       &Profit01*n[0,1],&Profit00*n[0,0]);
    OVERALL_AVG_PROFIT = TOTAL_PROFIT/sum(n[0,0],n[1,0],n[0,1],n[1,1]);
    ASE = sse/sum(n[0,0],n[1,0],n[0,1],n[1,1]);
    C = csum/(sum(n[0,0],n[0,1])*sum(n[1,0],n[1,1]));
    index=&index;
    output;
  end;
run;

proc append base=results data=assess force;
run;

%mend assess;
