data customers;
	infile 'C:\SAS TRAINING\Data & Code\Data\customer_list_multiline.csv' DLM = ',';
	input	Account OpenDate ddmmyy10.;
	input 	LastName $ FirstName $; 
	input 	County $;
	format	OpenDate ddmmyy10.;
run;


proc print data = customers;
run;

data customers;
	infile 'C:\SAS TRAINING\Data & Code\Data\customer_list_multiline.csv' DLM = ',';
	input	Account OpenDate ddmmyy10. /
		 	LastName $ FirstName $ / 
		 	County $;
	format	OpenDate ddmmyy10.;
run;


proc print data = customers;
run;

data customers;
	infile 'C:\SAS TRAINING\Data & Code\Data\customer_list_multiline.csv' DLM = ',';
	input	#1 Account OpenDate ddmmyy10. 
		 	#3 County $;
	format	OpenDate ddmmyy10.;
run;


proc print data = customers;
run;


data accounts(keep = AccountNumber) customers (keep = CustomerNumber LastName FirstName);
	infile 'C:\SAS TRAINING\Data & Code\Data\customer_list_multiline_hierarchy.csv' DLM = ',';
	input	Type $ @;
	if Type = 'C' then do;
		input CustomerNumber LastName $ FirstName $;
		output customers;
		end;
	else if Type = 'A' then do;
		input AccountNumber;
		output accounts;
	end;
run;


proc print data = customers;
run;

proc print data = accounts;
run;

data cust_accounts (drop = Type);
	infile 'C:\SAS TRAINING\Data & Code\Data\customer_list_multiline_hierarchy.csv' DLM = ',';
	input	Type $ @;
	if Type = 'C' then do;
		input CustomerNumber LastName $ FirstName $;
		retain CustomerNumber LastName FirstName;
		end;
	else if Type = 'A' then do;
		input AccountNumber;
		output;
	end;
run;


proc print data = cust_accounts;
run;


data accounts_names;
	infile 'C:\SAS TRAINING\Data & Code\Data\customer_list_multiline_multicustomer.csv' DLM = ',';
	input	AccountNumber LastName $ FirstName $ @@;
run;


proc print data = accounts_names;
run;
