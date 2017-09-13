/*st00ad06.sas*/
proc print data= st092.hosp (obs=10);
   var visit code diffbys3;
run;
 

/*st00ad06.sas*/
options ps=50 ls=76;

proc sort data= st092.hosp out=sorted_hosp;
   by code;
run;
ods graphics;
ods listing gpath="&outpath";
proc univariate data=sorted_hosp;
   by code;
   var diffbys3;
   histogram diffbys3 / normal;
   probplot  diffbys3 / normal (mu=est sigma=est);
   title 'Descriptive Statistics for Hospice Data';
run;

proc sgplot data=sorted_hosp;
   vbox diffbys3 / category = code;
run;          

/*st00ad06.sas*/
proc npar1way data=sorted_hosp wilcoxon median;
   class code;
   var diffbys3;
run;          

/*st00ad06.sas*/
proc print data= st092.ven;
   title 'Wood Veneer Wear Data';
run;          

/*st00ad06.sas*/
ods graphics;
proc npar1way data= st092.ven wilcoxon;
   class brand;
   var wear;
   exact;
run;          
