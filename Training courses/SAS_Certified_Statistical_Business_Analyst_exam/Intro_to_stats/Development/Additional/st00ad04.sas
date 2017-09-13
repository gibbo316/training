/*st00ad04.sas*/
proc print data=st092.market (obs=20);
   title;
run;          

/*st00ad04.sas*/
proc ttest data= st092.market;
   paired post*pre;
   title 'Testing the Difference Before and After a Sales Campaign';
run;          
