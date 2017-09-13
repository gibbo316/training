/*st004d03*/
ods graphics off;
proc univariate data=st092.phone_all_groups ;
	class team;
	var time;
	histogram time / normal(mu=est sigma=est);
    inset skewness kurtosis / position=ne;
    probplot time / normal(mu=est sigma=est);
    inset skewness kurtosis;
    title 'Descriptive Statistics Using PROC UNIVARIATE';
run;

/*st004d03*/
proc sgplot data=st092.phone_all_groups;
    refline 60 /  axis=y lineattrs=(color=blue);
    vbox time/category=team ;
      title "Box and Whisker Plot of Time by group";
run;

/*st004d03*/
ods graphics on;
proc glm data=st092.phone_all_groups PLOTS(only)=diagnostics(unpack);
   class team;
   model time=team;
   means team / hovtest;
   title 'Testing for Equality of Means with PROC GLM';
run;
quit;
ods graphics off;
