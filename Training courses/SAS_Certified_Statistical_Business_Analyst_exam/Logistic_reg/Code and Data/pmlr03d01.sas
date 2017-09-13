proc print data=develop(obs=15);
   var ccbal ccpurc income hmown;
run;

/* Create missing indicators */
data develop1;
   set develop;
   /* name the missing indicator variables */
   array mi{*} MIAcctAg MIPhone MIPOS MIPOSAmt 
               MIInv MIInvBal MICC MICCBal 
               MICCPurc MIIncome MIHMOwn MILORes
               MIHMVal MIAge MICRScor;
   /* select variables with missing values */
   array x{*} acctage phone pos posamt 
              inv invbal cc ccbal
              ccpurc income hmown lores 
              hmval age crscore;
   do i=1 to dim(mi);
      mi{i}=(x{i}=.);
   end;
run;

/* Impute missing values with the median */
proc stdize data=develop1 
            reponly 
            method=median 
            out=imputed;
   var &inputs;
run;

proc print data=imputed(obs=12);
   var ccbal miccbal ccpurc miccpurc 
       income miincome hmown mihmown;
run;
