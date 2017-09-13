/*************************************************
*
* Data Processing With SAS
* The Analytics Store
*
* Examples: Section 11 Programme 2
*
* Import Fixed width files
*
**************************************************/

data mth_end_bal;
	infile 'C:\SAS TRAINING\Data & Code\Data\mth_end_bal_fixed.txt';
	input 	Account 	1-6			
			OpenDate $  7-14 
			Type 	 $ 	15-22
			Balance		23-29;
run;

proc print data = mth_end_bal;
run;

data mth_end_bal;
	infile 'C:\SAS TRAINING\Data & Code\Data\mth_end_bal_fixed.txt';
	input 	@1	Account 	6.			
			+6	OpenYear 	2. 
				Type 		$8.
			@23	Balance	7.2;
run;


proc print data = mth_end_bal;
run;

data mth_end_bal;
	infile 'C:\SAS TRAINING\Data & Code\Data\mth_end_bal_fixed_missing.txt';
	input 	@1	Account 	6.			
			+6	OpenYear 	2. 
				Type 		$8.
			@23	Balance	7.2;
run;


proc print data = mth_end_bal;
run;

data mth_end_bal;
	infile 'C:\SAS TRAINING\Data & Code\Data\mth_end_bal_fixed_missing.txt' missover;
	input 	@1	Account 	6.			
			+6	OpenYear 	2. 
				Type 		$8.
			@23	Balance	7.2;
run;


proc print data = mth_end_bal;
run;
