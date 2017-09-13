/*----  SCN_CreateStartList_AW_Modify.sas  -------------------------*/
/*----  Modify Start List created by SCN_CreateStartList_AW.sas ----*/
/*----  This program is intended to be used independently as    ----*/
/*----  a way to customize the start list. For example, you     ----*/
/*----  add terms to the list. The simple modification below    ----*/
/*----  removes terms like "55mph".                             ----*/


/*----  Investigate dropping low weighted terms  ----*/

proc univariate data=DMTXT.AutoStartNew;
   var Weight;
run;

/*----  Drop terms starting with numbers           ----*/
/*----  Except, keep "1st gear," "2nd gear," etc.  ----*/

data DMTXT.WarrantyStart;
   set DMTXT.AutoStartNew;
   if ('0'<=substr(Term,1,1)<='9') and
      (index(lowcase(Term),'gear')=0) then delete;
   keep Term Role;
run;
