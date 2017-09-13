/*----  Term (Parsing) and U Matrix (Cluster)  ----*/

%global LastParsing LastCluster TermData
        SMatrix UMatrix;
%let LastParsing= ;
%let LastCluster= ;

proc print data=&EM_IMPORT_DATA_EMINFO;
run;

proc sql noprint;
  select data into :LastCluster 
  from &EM_IMPORT_DATA_EMINFO 
  where key="LastTextCluster";
  select data into :LastParsing 
  from &EM_IMPORT_DATA_EMINFO 
  where key="LastTextParsing";
quit;

%put NOTE: Last SAS Text Parsing Node: &LastParsing;
%put NOTE: Last Text Cluster Node: &LastCluster;
%let TermData=%sysfunc(strip(&EM_LIB)).%sysfunc(strip(&LastParsing))_TERMS;
%let SMatrix=%sysfunc(strip(&EM_LIB)).%sysfunc(strip(&LastCluster))_svd_s;
%let UMatrix=%sysfunc(strip(&EM_LIB)).%sysfunc(strip(&LastCluster))_svd_u;
%EM_REGISTER(KEY=TERMS,TYPE=DATA);
%EM_REGISTER(KEY=SVDS,TYPE=DATA);
%EM_REGISTER(KEY=SVDU,TYPE=DATA);

%macro GetUMatrix();
   %if %sysfunc(exist(&TermData)) %then %do;
      %EM_REPORT(KEY=TERMS,VIEWTYPE=DATA,AUTODISPLAY=Y);
      data &EM_USER_TERMS;
         set &TermData;
         rename KEY=_TERMNUM_;
      run;
      proc contents data=&EM_USER_TERMS;
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
%mend GetUMatrix;

%GetUMatrix();




