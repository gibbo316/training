/*************************************************
*
* Data Processing With SAS
* The Analytics Store
*
* Examples: Section 17 Programme 3
*
* Experimeting with DO loop processing
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

/* Calculate a five year sales forecast using a DO - TO loop */
data sasdata.shop_sales_dec_forecast;
	set sasdata.shop_sales;
	keep ShopID County Dec Dec_Forecast;
	format Dec_Forecast dollar12.2;
	Dec_Forecast = Dec;
	do index = 1 to 5 by 1;
		Dec_Forecast = Dec_Forecast + Dec_Forecast * 0.05;
	end; 
run;

proc print data = sasdata.shop_sales_dec_forecast;
run;

