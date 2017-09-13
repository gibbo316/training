/*---  SCN_AutoSpellDict.sas  ----*/

data DMTXT.AutoSpellDict;
   set EMWS16.TextFilter3_spellDS;
   keep term termrole parent parentrole;
run;

proc contents data=DMTXT.AutoSpellDict;
run;
