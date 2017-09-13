/*----  SCN_CreateStartStopList.sas  --------------------*/
/*----  Create Start List using frequency filtering  ----*/

%global LastParsing LastFilter TermData FTermData 
        StartList MaxDocs MinDocs;

/*!!!!  Edit the following 5 lines  !!!!*/
%let StartList=work.start;
%let StopList=work.stop;
%let MaxDocs=600;
%let MinDocs=10;
%let AllowNumbers=Y;

%let LastParsing= ;
%let LastFilter= ;

proc print data=&EM_IMPORT_DATA_EMINFO;
run;

proc sql noprint;
  select data into :LastFilter 
  from &EM_IMPORT_DATA_EMINFO 
  where key="LastTextFilter";
  select data into :LastParsing 
  from &EM_IMPORT_DATA_EMINFO 
  where key="LastTextParsing";
quit;

%put NOTE: Last SAS Text Parsing Node: &LastParsing;
%put NOTE: Last Text Filter Node: &LastFilter;

%let TermData=%sysfunc(strip(&EM_LIB)).%sysfunc(strip(&LastParsing))_terms;
%let FTermData=%sysfunc(strip(&EM_LIB)).%sysfunc(strip(&LastFilter))_terms_data;

%EM_REGISTER(KEY=TERMS,TYPE=DATA);
%EM_REPORT(KEY=TERMS,VIEWTYPE=DATA);
%EM_REGISTER(KEY=TERMTRANS,TYPE=DATA);
%EM_REPORT(KEY=TERMS,VIEWTYPE=DATA);

%macro GetData();
   %if %sysfunc(exist(&TermData)) & %sysfunc(exist(&FTermData)) %then %do;
      %EM_REPORT(KEY=TERMS,VIEWTYPE=DATA,AUTODISPLAY=Y);
      data &EM_USER_TERMS;
         set &TermData;
      run;
      proc contents data=&EM_USER_TERMS;
      run;

      %EM_REPORT(KEY=TERMTRANS,VIEWTYPE=DATA,AUTODISPLAY=Y);
      data &EM_USER_TERMTRANS;
         set &FTermData(where=(Keep='Y' and &MinDocs<=NumDocs<=&MaxDocs));
      run;
      proc contents data=&EM_USER_TERMTRANS;
      run;
      proc univariate data=&EM_USER_TERMTRANS;
         var NumDocs Weight;
      run;
 
      proc sql;
         create table &StartList as
            select a.KEY, a.Role, a.TERM, b.Weight
            from &EM_USER_TERMS a, &EM_USER_TERMTRANS b
            where a.KEY=b.KEY and
                  b.Weight>0;
      quit;
      %if (&AllowNumbers ne Y) %then %do;
         data &StartList;
            set &StartList;
            if ('0'<=substr(TERM,1,1)<='9') then delete;
         run;
      %end;
      proc sql;
         create table &StopList as
            select a.Term, a.Role
            from &TermData a, &EM_USER_TERMTRANS b
            where a.KEY=b.KEY and
                  a.KEY not in
			           (select c.KEY from &StartList c);
      quit;
      data &StartList;
         set &StartList;
         drop KEY;
      run;
      proc sort data=&StartList nodupkey;
         by Term Role;
      run;
      proc contents data=&StartList;
      run;
      proc sort data=&StopList nodupkey;
         by Term Role;
      run;
      proc contents data=&StopList;
      run;
   %end;
%mend GetData;

%GetData();





