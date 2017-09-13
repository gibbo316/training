/*----  All Text Mining Data Sets that are not exported  ----*/

%global LastParsing LastFilter LastTopic LastCluster TermData
        TMoutData TermTopics SMatrix UMatrix;
%let LastParsing= ;
%let LastFilter= ;
%let LastTopic= ;
%let LastCluster= ;

proc print data=&EM_IMPORT_DATA_EMINFO;
run;

proc sql noprint;
  /*  TM No longer available  *\
  select data into :LastTMnode 
  from &EM_IMPORT_DATA_EMINFO 
  where key="LastTMNode";
\*----------------------------*/
  select data into :LastFilter 
  from &EM_IMPORT_DATA_EMINFO 
  where key="LastTextFilter";
  select data into :LastCluster 
  from &EM_IMPORT_DATA_EMINFO 
  where key="LastTextCluster";
  select data into :LastParsing 
  from &EM_IMPORT_DATA_EMINFO 
  where key="LastTextParsing";
  select data into :LastTopic 
  from &EM_IMPORT_DATA_EMINFO 
  where key="LastTopic";
quit;

%put NOTE: Last SAS Text Parsing Node: &LastParsing;
%put NOTE: Last Text Filter Node: &LastFilter;
%put NOTE: Last Text Cluster Node: &LastCluster;
%put NOTE: Last Text Cluster Node: &LastTopic;
%let TermData=%sysfunc(strip(&EM_LIB)).%sysfunc(strip(&LastParsing))_TERMS;
%let TMoutData=%sysfunc(strip(&EM_LIB)).%sysfunc(strip(&LastFilter))_TMOUT;
%let TermTopics=%sysfunc(strip(&EM_LIB)).%sysfunc(strip(&LastTopic))_TERMTOPICS;
/*----  Matrix of singular values  ----*/
%let SMatrix=%sysfunc(strip(&EM_LIB)).%sysfunc(strip(&LastCluster))_svd_s;
/*----  Singular value decomposition: D=U*S*V, following is U matrix  ----*/ 
%let UMatrix=%sysfunc(strip(&EM_LIB)).%sysfunc(strip(&LastCluster))_svd_u;
%EM_REGISTER(KEY=TERMS,TYPE=DATA);
%EM_REGISTER(KEY=TRANS,TYPE=DATA);
%EM_REGISTER(KEY=TERMTRANS,TYPE=DATA);
%EM_REGISTER(KEY=TOPICS,TYPE=DATA);
%EM_REGISTER(KEY=SVDS,TYPE=DATA);
%EM_REGISTER(KEY=SVDU,TYPE=DATA);

%macro GetData();
   %if %sysfunc(exist(&TermData)) %then %do;
      %EM_REPORT(KEY=TERMS,VIEWTYPE=DATA,AUTODISPLAY=Y);
      data &EM_USER_TERMS;
         set &TermData;
         rename KEY=_TERMNUM_;
      run;
      proc contents data=&EM_USER_TERMS;
      run;
   %end;
   %if %sysfunc(exist(&TermTopics)) %then %do;
      %EM_REPORT(KEY=TOPICS,VIEWTYPE=DATA,AUTODISPLAY=Y);
      data &EM_USER_TOPICS;
         set &TermTopics;
      run;
      proc contents data=&EM_USER_TOPICS;
      run;
   %end;
   %if %sysfunc(exist(&SMatrix)) %then %do;
      %EM_REPORT(KEY=SVDS,VIEWTYPE=DATA,AUTODISPLAY=Y);
      data &EM_USER_SVDS;
         set &SMatrix;
      run;
      proc contents data=&EM_USER_SVDS;
      run;
   %end;
   %if %sysfunc(exist(&UMatrix)) %then %do;
      %EM_REPORT(KEY=SVDU,VIEWTYPE=DATA,AUTODISPLAY=Y);
      data &EM_USER_SVDU;
         set &UMatrix;
         rename INDEX=_TERMNUM_;
      run;
      proc contents data=&EM_USER_SVDU;
      run;
      %if %sysfunc(exist(&EM_USER_TERMS)) %then %do;
         proc sql;
            create table &EM_USER_SVDU as
               select a.*, b.TERM
               from &EM_USER_SVDU a, &EM_USER_TERMS b
               where a._TERMNUM_=b._TERMNUM_;
         quit;
      %end;
   %end;
   %if %sysfunc(exist(&TMoutData)) %then %do;
      %EM_REPORT(KEY=TRANS,VIEWTYPE=DATA,AUTODISPLAY=Y);
      data &EM_USER_TRANS;
         set &TMoutData;
      run;
   %end;
   %if (%sysfunc(exist(&EM_USER_TERMS))) & (%sysfunc(exist(&EM_USER_TRANS))) %then %do;
      data &EM_USER_TERMTRANS;
         set &EM_USER_TERMS;
         keep _TERMNUM_ Term;
      run;
      proc sql;
         create table &EM_USER_TERMTRANS as
            select a.*, b.TERM
            from &EM_USER_TRANS a, &EM_USER_TERMTRANS b
            where a._TERMNUM_=b._TERMNUM_;
      quit;
      data &EM_EXPORT_TRANSACTION;
         set &EM_USER_TERMTRANS;
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
   %end;
   /*----  To Do: Match Topic data IDs with term IDs  ----*/
   /*----  Topic: texttopic_out_u dataset             ----*/
%mend GetData;

%GetData();




