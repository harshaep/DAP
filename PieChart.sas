/* Objective to generate Pie charts, Get Top3 dataset from Program Obj1*/
/*Pie chart for Crime type with percentage with Total Crime and Individual crime */
/* SQL proc for generating desired output for pie chart*/

data uscrpt.tot_crime_state_per;
set uscrpt.tot_crime_state_rate;
	violent_crime_per = (violent_crime_sum/total_crime_city_sum)*100;
	Property_crime_per = (Property_crime_sum/total_crime_city_sum)*100;
	Arson_Crime_per = (Arson_sum/total_crime_city_sum)*100;
	drop _TYPE_ _PAGE_ _TABLE_ population_sum total_crime_city_sum tot_crime_state_rate
		 violent_crime_sum property_crime_sum arson_sum;
	format violent_crime_per comma10.2 property_crime_per comma10.2 arson_crime_per comma10.2;
	
	where State in ('MISSISSIPPI','WASHINGTON','NEW MEXICO');
run;


Proc sort data = uscrpt.tot_crime_state_per out = uscrpt.tot_crime_state_per;
by State descending state;
run;

title 'Top three States with Highest Crime Rate for year 2014';
proc print data = uscrpt.tot_crime_state_per label noobs;
label violent_crime_per = 'Violent Crime Percent'
	  property_crime_per = 'Property Crime Percent'
	  arson_crime_per = 'Arson Crime Percent';
run;



Proc sort data = uscrpt.tot_crime_state_per out = work.chart1;
by State;
run;

options validvarname=any;
Data chart1;
set chart1;
rename violent_crime_per = 'Violent Crime Percentage'n
	   Property_Crime_Per = 'Property Crime Percentage'n
	   Arson_Crime_Per = 'Arson Crime Percentage'n;
run;

proc transpose data = work.chart1 out = wide3 NAME = Crimes;
id state year;
run;

/* Selecting only New Mexico for pie chart*/
options validvarname=any;
data wide3;
set wide3;
rename 'NEW MEXICO2014'n = NEWMEXICO2014;
format NEWMEXICO2014 comma10.2;
label violent_crime_per = 'Violent Crime Percentage'
	  Property_Crime_Per = 'Property Crime Percentage'
	  Arson_Crime_Per = 'Arson Crime Percentage';
run;


goptions reset = all border;
title '2014 NEW MEXICO Crime Chart';
footnote j=r "GCHPISUM(b) ";

proc gchart data = wide3;
	pie Crimes / type = sum sumvar = NEWMEXICO2014 noheading;
run;
quit;


/* Selecting only for MISSISSIPPI for pie chart*/

goptions reset = all border;
title '2014 MISSISSIPPI Crime Chart';
footnote j=r "GCHPISUM(b) ";

proc gchart data = wide3;
	pie Crimes / type = sum sumvar = MISSISSIPPI2014 noheading;
run;
quit;


/* Pie Chart for Washington of year 2014*/

goptions reset = all border;
title '2014 WASHINGTON Crime Chart';
footnote j=r "GCHPISUM(b) ";

proc gchart data = wide3;
	pie Crimes / type = sum sumvar = WASHINGTON2014 noheading;
run;
quit;


/*2015 Pie Chart for New Mexico*/

data uscrpt.tot_crime_state_2015;
	set uscrpt.tot_crime_state;
	where year = 2015;
run;

data uscrpt.tot_crime_state_per_2015;
set uscrpt.tot_crime_state_2015;
	violent_crime_per = (violent_crime_sum/total_crime_city_sum)*100;
	Property_crime_per = (Property_crime_sum/total_crime_city_sum)*100;
	Arson_Crime_per = (Arson_sum/total_crime_city_sum)*100;
	drop _TYPE_ _PAGE_ _TABLE_ population_sum total_crime_city_sum tot_crime_state_rate
		 violent_crime_sum property_crime_sum arson_sum;
	format violent_crime_per comma10.2 property_crime_per comma10.2 arson_crime_per comma10.2;
	
	where State in ('MISSISSIPPI','WASHINGTON','NEW MEXICO');
run;


Proc sort data = uscrpt.tot_crime_state_per_2015 out = uscrpt.tot_crime_state_per_2015;
by State descending state;
run;

title 'Top three States with highest Crime Rate for year 2015';
proc print data = uscrpt.tot_crime_state_per_2015 label noobs;
label violent_crime_per = 'Violent Crime Percent'
	  property_crime_per = 'Property Crime Percent'
	  arson_crime_per = 'Arson Crime Percent';
run;


Proc sort data = uscrpt.tot_crime_state_per_2015 out = work.chart2;
by State descending state;
run;



options validvarname=any;
Data chart2;
set chart2;
rename violent_crime_per = 'Violent Crime Percentage'n
	   Property_Crime_Per = 'Property Crime Percentage'n
	   Arson_Crime_Per = 'Arson Crime Percentage'n;
run;

proc transpose data = work.chart2 out = wide2 NAME = Crimes;
id state year;
run;

options validvarname=any;
data wide2;
set wide2;
rename 'NEW MEXICO2015'n = NEWMEXICO2015;
format NEWMEXICO2015 comma10.2;
label violent_crime_per = 'Violent Crime Percentage'
	  Property_Crime_Per = 'Property Crime Percentage'
	  Arson_Crime_Per = 'Arson Crime Percentage';
run;

/* Pie Chart of year 2015 for New Mexico*/
goptions reset = all border;
title '2015 NEW MEXICO Crime Chart';
footnote j=r "GCHPISUM(b) ";

proc gchart data = wide2;
	pie Crimes / type = sum sumvar = NEWMEXICO2015 noheading;
run;
quit;

/* Pie Chart of year 2015 for Mississippi*/
goptions reset = all border;
title '2015 MISSISSIPPI Crime Chart';
footnote j=r "GCHPISUM(b) ";

proc gchart data = wide2;
	pie Crimes / type = sum sumvar = MISSISSIPPI2015 noheading;
run;
quit;

/* Pie Chart of year 2015 for Washington*/
goptions reset = all border;
title '2015 WASHINGTON Crime Chart';
footnote j=r "GCHPISUM(b) ";

proc gchart data = wide2;
	pie Crimes / type = sum sumvar = WASHINGTON2015 noheading;
run;
quit;





