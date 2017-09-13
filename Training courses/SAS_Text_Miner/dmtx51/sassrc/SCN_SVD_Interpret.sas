/*----  The U matrix from the singular value decompisition  ----*/
/*----  can be used to help interpret SVD weights.          ----*/
/*----  NOT REFERENCED IN COURSE NOTES                      ----*/

%global LastParsing LastFilter LastCluster TermData
        FTermData SMatrix UMatrix;
%let LastParsing= ;
%let LastFilter= ;
%let LastTopic= ;
%let LastCluster= ;

proc print data=&EM_IMPORT_DATA_EMINFO;
run;

proc sql noprint;
  select data into :LastParsing 
  from &EM_IMPORT_DATA_EMINFO 
  where key="LastTextParsing";
  select data into :LastFilter 
  from &EM_IMPORT_DATA_EMINFO 
  where key="LastTextFilter";
  select data into :LastCluster 
  from &EM_IMPORT_DATA_EMINFO 
  where key="LastTextCluster";
quit;

%put NOTE: Last SAS Text Parsing Node: &LastParsing;
%put NOTE: Last Text Filter Node: &LastFilter;
%put NOTE: Last Text Cluster Node: &LastCluster;

%let TermData=%sysfunc(strip(&EM_LIB)).%sysfunc(strip(&LastParsing))_terms;
%let FTermData=%sysfunc(strip(&EM_LIB)).%sysfunc(strip(&LastFilter))_terms_data;
/*----  Matrix of singular values  ----*/
%let SMatrix=%sysfunc(strip(&EM_LIB)).%sysfunc(strip(&LastCluster))_svd_s;
/*----  Singular value decomposition: D=U*S*V, following is U matrix  ----*/ 
%let UMatrix=%sysfunc(strip(&EM_LIB)).%sysfunc(strip(&LastCluster))_svd_u;



%macro BubbleSort3(Aname,Bname,Cname,MaxDim,TempVal,TempStop,TempI);
   &TempStop=0;
   do while (&TempStop=0);
      &TempStop=1;
     do &TempI=2 to &MaxDim;
        if (&Aname[&TempI]>&Aname[&TempI-1]) then do;
          &TempStop=0;
            &TempVal=&Aname[&TempI];
         &Aname[&TempI]=&Aname[&TempI-1];
         &Aname[&TempI-1]=&TempVal;
         &TempVal=&Bname[&TempI];
         &Bname[&TempI]=&Bname[&TempI-1];
         &Bname[&TempI-1]=&TempVal;
         &TempVal=&Cname[&TempI];
         &Cname[&TempI]=&Cname[&TempI-1];
         &Cname[&TempI-1]=&TempVal;
       end;
     end;
   end;   
%mend BubbleSort3;

%macro SVDinterp(CutOff=10,SVDlimit=10);
   %if (%sysfunc(exist(&UMatrix)) eq 0) %then %do;
      %put ERROR: U matrix data set (&UMatrix) does not exist in macro SVDinterp.;
   %end;
   %else %if (%sysfunc(exist(&TermData)) eq 0) %then %do;
      %put ERROR: Term data set (&TermData) does not exist in macro SVDinterp.;
   %end;
   %else %if (X%eval(&CutOff+0) ne X&CutOff) %then %do;
      %put ERROR: Argument CutOff in macro SVDinterp is not numeric.;
   %end;
   %else %if (X%eval(&SVDlimit+0) ne X&SVDlimit) %then %do;
      %put ERROR: Argument SVDlimit in macro SVDinterp is not numeric.;
   %end;
   %else %do;
      %EM_REGISTER(KEY=TERMS,TYPE=DATA);
      %EM_REPORT(KEY=TERMS,VIEWTYPE=DATA);
      %EM_REGISTER(KEY=FTERMS,TYPE=DATA);
      %EM_REGISTER(KEY=SVDS,TYPE=DATA);
      %EM_REGISTER(KEY=SVDU,TYPE=DATA);
      %EM_REPORT(KEY=SVDU,VIEWTYPE=DATA);
      %EM_REGISTER(KEY=SVDPLOT,TYPE=DATA);
      %EM_REGISTER(KEY=WORK,TYPE=DATA);
      data &EM_USER_TERMS;
         set &TermData;
      run;
      data &EM_USER_SVDU;
         set &UMatrix;
      run;
      %do ThisSVD=1 %to &SVDlimit;
         %EM_REPORT(KEY=SVDPLOT,VIEWTYPE=BAR,
                    DESCRIPTION=Top &CutOff SVD_&ThisSVD Weights,
                    X=Term,
                    FREQ=Value,
                    AUTODISPLAY=Y,
                    TIPTEXT=Csign,
                    WHERE=%BQUOTE(VarName="COL&ThisSVD"),
                    BLOCK=SVD Graphs);
         %EM_REPORT(KEY=SVDPLOT,VIEWTYPE=SCATTER,
                    DESCRIPTION=Top &CutOff SVD_&ThisSVD Weights,
                    X=Rank,
                    Y=Value,
                    AUTODISPLAY=Y,
                    COLOR=Sign,
                    TIPTEXT=Term,
                    WHERE=%BQUOTE(VarName="COL&ThisSVD"),
                    BLOCK=SVD Graphs);
         %EM_REPORT(KEY=SVDPLOT,VIEWTYPE=SCATTER,
                    DESCRIPTION=Top &CutOff SVD_&ThisSVD Weights By Term Weights,
                    X=Value,
                    Y=WEIGHT,
                    AUTODISPLAY=Y,
                    COLOR=Sign,
                    TIPTEXT=Term,
                    WHERE=%BQUOTE(VarName="COL&ThisSVD"),
                    BLOCK=SVD Graphs);
      %end;

      %let TempVar1=v%sysfunc(round(10000000*%sysfunc(ranuni(0))));
      %let TempVar2=&TempVar1.b;
      %let TempVar3=&TempVar1.c;

      ods listing close;
      ods output ExtremeObs=&EM_USER_WORK;
      proc univariate data=&EM_USER_SVDU nextrobs=&CutOff;
         id INDEX;
         var 
      %do ThisSVD=1 %to &SVDlimit;
            Col&ThisSVD
      %end;
            ;
      run;
      ods output close;
      ods listing;
      data &EM_USER_WORK;
         set &EM_USER_WORK;
         VarName=upcase(VarName);
      run;
      proc sort data=&EM_USER_WORK;
         by VarName;
      run;
/*DEBUG*/
proc print data=&EM_USER_WORK;
run;
/*DEBUG*/
      data &EM_USER_WORK;
         set &EM_USER_WORK;
         by VarName;
         array VV{%eval(&CutOff+&CutOff)} _temporary_;
         array II{%eval(&CutOff+&CutOff)} _temporary_;
         array SS{%eval(&CutOff+&CutOff)} _temporary_;
         retain Rank 0;
         if (first.VarName) then do;
            Rank=0;
         end;
         Rank+1;
         VV[Rank]=abs(Low);
         II[Rank]=INDEX_Low;
         SS[Rank]=(Low>=0);
         Rank+1;
         VV[Rank]=abs(High);
         II[Rank]=INDEX_High;
         SS[Rank]=(High>=0);
         if (last.VarName) then do;
            %BubbleSort3(VV,II,SS,2*&CutOff,&TempVar1,&TempVar2,&TempVar3);
            do Rank=1 to &CutOff;
               Value=VV[Rank];
               _TERMNUM_=II[Rank];
               Sign=SS[Rank]; 
               output;
            end;
         end;
         keep VarName Rank Value _TERMNUM_ Sign;
      run;
      data &EM_USER_SVDPLOT;
         set &TermData(where=(PARENT=.));
         if (ROLE=' ') then TERM=strip(TERM);
         else TERM=strip(TERM)||"("||strip(ROLE)||")";
         keep TERM _TERMNUM_ WEIGHT;
      run;
      proc sort data=&EM_USER_SVDPLOT;
         by _TERMNUM_;
      run;
      proc sort data=&EM_USER_WORK;
         by _TERMNUM_;
      run;
      data &EM_USER_SVDPLOT;
         attrib Csign length=$8;
         merge &EM_USER_SVDPLOT(in=in1) &EM_USER_WORK(in=in2);
         by _TERMNUM_;
         if (Sign=0) then Csign='minus(-)';
         else Csign='plus(+)';
         if (in2=0) then delete;
         label Value   = "Abs(SVD Weight)"
               Rank    = "Rank"
               Csign   = "Sign"
               Sign    = "Positive Weight Indicator"
               VarName = "Variable Name"
               WEIGHT  = "Term Weight";
      run;
      proc sort data=&EM_USER_SVDPLOT;
         by VarName Rank;
      run; 
   %end;
%mend SVDinterp;

%SVDinterp(CutOff=11,SVDlimit=3);

/*--------------------------*/
/*----  End of Program  ----*/
/*--------------------------*/
