/*----  RefineMovieData.sas  ----*/


/*----  Remove extraneous numeric genre codes  ----*/
/*----  Make hyphenated-slash names uniform    ----*/
data work.FixMovies;
   set DMTXT51.MovieData;
   if (strip(Title)="Meet Joe Black") then do;
      Genre="Drama, Romance, Sci-Fi/Fantasy";
   end;
   if (substr(Genre,1,4)='007,') then do;
      Genre=substr(Genre,6);
   end;
   if (index(Genre,', 007')>0) then do;
      Genre=substr(Genre,1,index(Genre,', 007')-1);
   end;
   Genre=tranwrd(Genre,'Gay-Lesbian','Gay/Lesbian');
   Genre=tranwrd(Genre,'Martial-Arts','Martial');
   Genre=tranwrd(Genre,'Martial','Martial-Arts');
   Genre=tranwrd(Genre,'Sci-Fi-Fantasy','Sci-Fi/Fantasy');
run;

proc freq data=work.FixMovies;
   tables genre;
run;

/*----  Create separate character Genre fields, one genre per field.  ----*/
/*----  Count number of unique genres.                                ----*/
data work.FixMovies;
   set work.FixMovies;
   attrib Genre1-Genre6 length=$16;
   array GG{*} Genre1-Genre6;
   GG[1]=scan(Genre,1,', ');
   Index=2;
   do while(Index>0);
      GG[Index]=scan(Genre,Index,', ');
      if (GG[Index]=' ') then do;
         NumGenres=Index-1;
         Index=0;
      end;
      else Index+1;
   end;
run;

proc freq data=work.FixMovies;
   tables NumGenres Genre5 Genre6 / missing;
run;

/*----  Derive frequency table of unique genre names  ----*/
data work.check;
   set work.FixMovies;
   attrib GenreUnique length=$16;
   array GG{*} Genre1-Genre5;
   do Index=1 to NumGenres;
      GenreUnique=GG[Index];
      output;
   end;
   keep GenreUnique;
run;

proc freq data=work.check;
   tables GenreUnique;
run;

/*----  Create binary target genre variables  ----*/
data work.FixMovies;
   set work.FixMovies;
   attrib Action Comedy Documentary Drama Horror KidsFamily Mystery Romance SciFi 
          Suspense length=3
          Language length=$8;
   drop Index Genre6; /*----  Genre6 is 100% missing (blank)  ----*/
   Action=(index(Genre,'Action')>0);
   Comedy=(index(Genre,'Comedy')>0);
   Documentary=(index(Genre,'Documentary')>0);
   Drama=(index(Genre,'Drama')>0);
   Horror=(index(Genre,'Horror')>0);
   if (index(Genre,'Kids')>0) or (index(Genre,'Family')>0) then KidsFamily=1;
   else KidsFamily=0;
   Romance=(index(Genre,'Romance')>0);
   Mystery=(index(Genre,'Mystery')>0);
   SciFi=(index(Genre,'Sci-Fi')>0);
   Suspense=(index(Genre,'Suspense')>0);
   Language='English';
   if (index(Genre,'Finish')>0) then Language='Finish';
   else if (index(Genre,'Spanish')>0) then Language='Spanish';
   else if (index(Genre,'German')>0) then Language='German';
   else if (index(Genre,'Italian')>0) then Language='Italian';
   else if (index(Genre,'French')>0) then Language='French';
   else if (index(Genre,'Foreign')>0) then Language='Foreign';
   if (sum(Action,Comedy,Documentary,Drama,Horror,KidsFamily,Mystery,Romance,SciFi,Suspense)=0) then
      put Title= Genre=;
run;

proc freq data=work.FixMovies;
   tables Language
          Action Comedy Documentary Drama 
          Horror KidsFamily Mystery Romance 
          SciFi Suspense / missing;
run;

/*----  Language is too many sparse categories, so drop it  ----*/
data DMTXT51.MoviesGenre(compress=Y label="Movies Data with Genre Codes");
   set work.FixMovies;
   drop Language;
run;

/*----  Finalize by:                        ----*/
/*---   Compressing multiple blanks.        ----*/
/*----  Compressing the complete data set.  ----*/
/*----  Labeling the data set.              ----*/
data DMTXT51.MoviesGenre(compress=Y label="Movies Data with Genre Codes");
   set DMTXT51.MoviesGenre;
   Synopsis=compbl(Synopsis);
run;

/*----  Obtain publication version of list of genres,  ----*/
/*----  both HTML and ASCII text versions.             ----*/
data one;
   set DMTXT51.MoviesGenre;
   GenreNew=Genre1;
   output;
   GenreNew=Genre2;
   output;
   GenreNew=Genre3;
   output;
   GenreNew=Genre4;
   output;
   GenreNew=Genre5;
   output;
   keep GenreNew;
   rename GenreNew=Genre;
run;

ods listing;
proc freq data=work.one;
   tables Genre/out=work.temp;
run;

/*----  List only the genres appearing for 50 or more movies  ----*/
proc print data=work.temp(where=(GENRE^=' ' and COUNT>=50));
run;
