/*************************************************
*
* Data Processing With SAS
* The Analytics Store
*
* Examples: Section 17 Programme 2
*
* Group processing use first. and last.
*
**************************************************/

/* Read in a csv file */
data sasdata.mth_end_bal_ext;
	infile 'C:\SAS TRAINING\Data & Code\Data\mth_end_bal_ext_dups_rem.csv' DLM=',' FIRSTOBS=2;
	input  Account Month ddmmyy10. Type $ Balance;
	format Month ddmmyy10. Balance dollar10.2;
run;


/* Calculate group sub-totals using first. and last. */
proc sort data = sasdata.mth_end_bal_ext out = sasdata.mth_end_bal_ext_srt;
	by Month;
run;

data sasdata.mth_end_bal_smry;
	set sasdata.mth_end_bal_ext_srt (drop=Type);
	format Month_Summary dollar15.2;
	keep Month Month_Smry;
	by Month;
	if First.Month then Month_Smry = 0;
	Month_Smry + Balance;
	if Last.Month then output;
run;

proc print data = sasdata.mth_end_bal_smry;
run;


/* Using group processing this time count the number of times each account has been overdrawn */
proc sort data = sasdata.mth_end_bal_ext out = sasdata.mth_end_bal_ext_srt;
	by Account Month;
run;

data sasdata.overdrawn_smry;
	set sasdata.mth_end_bal_ext_srt;
	keep Account Overdrawn_Count;
	by Account;
	if First.Account then Overdrawn_Count = 0;
	if Balance < 0 then Overdrawn_Count + 1;
	if Last.Account then output;
run;

proc print data = sasdata.overdrawn_smry;
run;
