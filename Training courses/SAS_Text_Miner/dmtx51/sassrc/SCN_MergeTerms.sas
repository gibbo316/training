/*----   SCN_MergeTerms.sas  ----*/

/*----  Replace Term ID values with terms  ----*/
/*----  for association analysis           ----*/
%let TermTopics=%sysfunc(strip(&EM_LIB)).%sysfunc(strip(&EM_METASOURCE_NODEID))_TERMTOPICS;
%let LastTMnode= ;
%let LastTFnode= ;
proc sql noprint;
  select data into :LastTMnode 
  from &EM_IMPORT_DATA_EMINFO 
  where key="LastTMNode";
  select data into :LastTFnode 
  from &EM_IMPORT_DATA_EMINFO 
  where key="LastTextFilter";
quit;
%put NOTE: Last SAS Text Miner Node: &LastTMnode;
%put NOTE: Last Text Filter Node: &LastTFnode;
%let TermData=%sysfunc(strip(&EM_LIB)).%sysfunc(strip(&LastTFnode))_TERMS;
%let TMoutData=%sysfunc(strip(&EM_LIB)).%sysfunc(strip(&LastTFnode))_TMOUT;
%EM_REGISTER(KEY=TEMP,TYPE=DATA);
%EM_REGISTER(KEY=TEMP2,TYPE=DATA);
%EM_REGISTER(KEY=TEMP3,TYPE=DATA);
%EM_REPORT(KEY=TEMP3,VIEWTYPE=DATA,AUTODISPLAY=Y);
data &EM_USER_TEMP;
   set &EM_IMPORT_TRANSACTION;
run;
data &EM_USER_TEMP2;
   set &TermData;
   keep KEY Term;
   rename KEY=_TERMNUM_;
run;
proc sql;
   create table &EM_USER_TEMP3 as
      select a.*, b.TERM
      from &EM_USER_TEMP a, &EM_USER_TEMP2 b
      where a._TERMNUM_=b._TERMNUM_;
quit;
data &EM_EXPORT_TRANSACTION;
   set &EM_USER_TEMP3;
run;
proc contents data=&EM_EXPORT_TRANSACTION;
run;

/*----  Change Transaction Metadata  ----*/
filename metdelta "&EM_FILE_CDELTA_TRANSACTION";
data _null_;  
   file metdelta;
   put "if (upcase(NAME)='_TERMNUM_') then do;";
   put "   ROLE='REJECTED';";
   put "end;";
   put "else if (upcase(NAME)='TERM') then do;";
   put "   ROLE='TARGET';";
   put "   LEVEL='NOMINAL';";
   put "end;";
run;
