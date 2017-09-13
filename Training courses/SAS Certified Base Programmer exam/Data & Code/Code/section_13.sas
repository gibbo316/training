libname lib 'C:\Users\shane.mc.carthy\Documents\MyTraining\SAS\SAS Certified Base Programmer exam\Data & Code\Data';

data test; 
infile 'C:\Users\shane.mc.carthy\Documents\MyTraining\SAS\SAS Certified Base Programmer exam\Data & Code\Data\mth_end_bal_ext.csv'
		DLM=','; 
informat OpenDate ddmmyy8.; 
Length Type $16.; 
input Account OpenDate Type $ Balance; 
format OpenDate date9. Balance dollar10.2 ;
run; 

proc sort data=test out=test1; 
by type; 
run; 

proc print data=test1;
by type; 
ID type;
sum balance;
run;

proc freq data=test1; 
table type; 
run;

proc freq data=test1; 
by type; 
run;


/*Chi squared proc freq example */

data test1; 
set lib.mth_end_bal_ext;
if balance <0 then overdrawn_fl=1;
else overdrawn_fl=0; 
run;

proc freq data=test1; 
table Month*Overdrawn_fl / chisq nopercent norow nocol;
run;


/*Proc report example*/
proc report data=lib.mth_end_bal; 
run;

/*Proc report example*/
proc report data=lib.mth_end_bal; 
column type balance;
run;

/*Proc report example*/
proc report data=lib.mth_end_bal; 
column type balance;
define balance /'account*balance' format=dollar10.0 centre; 
define type/order;
run;

/*Proc report example*/
proc report data=lib.mth_end_bal; 
column type balance;
define balance /'account*balance' format=dollar10.0 centre; 
define type/group;
run;




