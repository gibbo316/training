libname pmlr '.';

/* Use a temporary data set for development */
data develop;
   set pmlr.develop;
run;

/* Establish a macro variable for the list of */
/* numeric inputs.                            */
%let inputs=ACCTAGE DDA DDABAL DEP DEPAMT CASHBK 
			CHECKS DIRDEP NSF NSFAMT PHONE TELLER 
			SAV SAVBAL ATM ATMAMT POS POSAMT CD 
			CDBAL IRA IRABAL LOC LOCBAL INV 
			INVBAL ILS ILSBAL MM MMBAL MMCRED MTG 
			MTGBAL CC CCBAL CCPURC SDB INCOME 
			HMOWN LORES HMVAL AGE CRSCORE MOVED 
			INAREA;

/* Investigate the distribution of the */
/* numeric inputs                      */
proc means data=develop n nmiss mean min max;
   var &inputs;
run;

/* Investigate the distribution of the */
/* categorical inputs and the target   */
proc freq data=develop;
   tables ins branch res;
run;
