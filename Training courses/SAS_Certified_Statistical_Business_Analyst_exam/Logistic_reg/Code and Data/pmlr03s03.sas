proc varclus data=pva1 short hi maxeigen=0.70 plots=dendrogram;
   var &ex_inputs mi_DONOR_AGE mi_INCOME_GROUP 
       mi_WEALTH_RATING ClusCdGrp1 ClusCdGrp2 
       ClusCdGrp3 ClusCdGrp4;
   title "Variable Clustering of PVA data set";
run;
          
