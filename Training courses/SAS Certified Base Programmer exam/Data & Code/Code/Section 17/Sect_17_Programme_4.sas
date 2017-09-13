/*************************************************
*
* Data Processing With SAS
* The Analytics Store
*
* Examples: Section 17 Programme 4
*
* Experimenting with SAS arrays
*
**************************************************/


/* Read in a CSV file */
data sasdata.shop_sales;
	infile ' C:\SAS TRAINING\Data & Code\Data\shop_sales.csv' DLM=',' firstobs = 2;
	input  ShopID County $ Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec ;
	format Jan dollar12.2 Feb dollar12.2 Mar dollar12.2 Apr dollar12.2 May dollar12.2 Jun dollar12.2 Jul dollar12.2 Aug dollar12.2 Sep dollar12.2 Oct dollar12.2 Nov dollar12.2 Dec dollar12.2;
	length County $ 20; 
run;

proc print data = sasdata.shop_sales;
run;


/* Use an array to clculate a 1 year sales forecast for each month */ 
data sasdata.shop_sales_2012_forecast;
	set sasdata.shop_sales;

	array months{12} Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec ;

	do i = 1 to 12 by 1;
		months{i} = months{i} + months{i} * 0.05;
	end; 
run;

proc print data = sasdata.shop_sales_2012_forecast;
run;


/* Use an array to calculate a 5 year sales forecast for each month */
data sasdata.shop_sales_2016_forecast;
	set sasdata.shop_sales;

	array months{12} Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec ;

	do i = 1 to 12 by 1;
		do index = 1 to 5 by 1;
			months{i} = months{i} + months{i} * 0.05;
		end; 
		
	end; 
run;

proc print data = sasdata.shop_sales_2016_forecast;
run;


/* Use an array to create new varaibles and calculate a sales forecast for each month */
data sasdata.shop_sales_2012_forecast;
	set sasdata.shop_sales;

	array months_old{*}  Jan -- Dec;
	array months_new{12}  mnth1 - mnth12;

	do i = 1 to 12 by 1;
		months_new{i} = months_old{i} + months_old{i} * 0.05;
	end; 
run;

proc print data = sasdata.shop_sales_2012_forecast;
run;
