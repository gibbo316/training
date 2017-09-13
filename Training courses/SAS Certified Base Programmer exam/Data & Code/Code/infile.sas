data _null_; 
input name $ age ; 
file 'C:\SAS\base\test2.txt';
put name age; 
datalines; 

Shane 12 
Paul 56
Casey 89
Joe 12
;

run;

data group 