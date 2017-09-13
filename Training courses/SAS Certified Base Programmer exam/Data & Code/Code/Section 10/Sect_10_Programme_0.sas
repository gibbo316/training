/*************************************************
*
* Data Processing With SAS
* The Analytics Store
*
* Examples: Section 10 Programme 0
*
* Demonstrating SAS dates and date-times
*
**************************************************/

/* Demonstrate how SAS dates are actually stored */
data test_date;
  Current_Date = date(); 
  Aoife_BD = '02nov1978'd;  
  Date_zero = '01jan1960'd;  
run;
proc print data = test_date;
run;

/* Demonstrate how SAS date-times are actually stored */ 
data test_date_time;
  Curr_Date_Time = datetime(); 
  Aoife_BD  = '02nov1978:06:40:03'dt;  
  Date_zero = '01jan1960:00:00:00'dt;  
run;
proc print data = test_date_time;
run;
