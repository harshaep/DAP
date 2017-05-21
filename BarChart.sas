/* sort dataset for top violent crime cities based on year*/
/*Highest crime in 2014 and 2015*/
proc sort data = uscrpt.formatdata out = work.violent_crime_desc;
	by descending tot_crime_rate;
run;

proc print data = work.violent_crime_desc (obs = 6);
	var state city year vio_crime_rate pro_crime_rate arson_crime_rate tot_crime_rate;
		where year = 2014;
run;



/* Program to generate Bar Charts*/

proc print data = uscrpt.tot_crime_state;
run;


data uscrpt.tot_crime_state_rate;
set uscrpt.tot_crime_state;
	tot_crime_state_rate = (total_crime_city_sum/Population_sum)*100000;
	format tot_crime_state_rate comma10.;
run;


data uscrpt.tot_crime_state_rate;
set uscrpt.tot_crime_state;
	violent_crime_rate = (violent_crime_sum/Population_sum)*100000;
	Property_crime_rate = (Property_crime_sum/Population_sum)*100000;
	Arson_Crime_rate = (Arson_sum/Population_sum)*100000;
	drop _TYPE_ _PAGE_ _TABLE_ population_sum total_crime_city_sum tot_crime_state_rate
		 violent_crime_sum property_crime_sum arson_sum violent_crime_per property_crime_per arson_crime_per;
	format violent_crime_rate comma10. property_crime_rate comma10. arson_crime_rate comma10.;
	where State in ('MISSISSIPPI','WASHINGTON','NEW MEXICO');
run;

Proc sort data = uscrpt.tot_crime_state_rate out = uscrpt.tot_crime_state_rate;
by State descending state;
run;



title 'Top three States with Highest Crime Rate for year 2014 and 2015';
proc print data = uscrpt.tot_crime_state_rate label noobs;
label violent_crime_rate = 'Violent Crime Rate'
	  property_crime_rate = 'Property Crime Rate'
	  arson_crime_rate = 'Arson Crime Rate';
run;

data uscrpt.tot_crime_state_rate;
set uscrpt.tot_crime_state_rate;
	label violent_crime_rate = 'Violent Crime Rate' 
		  property_crime_rate = 'Property Crime Rate'
	  	  arson_crime_rate = 'Arson Crime Rate';
run;
	  	  
proc contents data = uscrpt.tot_crime_state_rate;
run;

proc tabulate data = uscrpt.tot_crime_state_rate out = uscrpt.tot_crime_state_rate_tab format = comma10.;
title 'Crime rate details for States New Mexico, Mississippi, Washington for years 2014 and 2015';
class State Year;
	var violent_crime_rate property_crime_rate arson_crime_rate;
	table state all, year*((Violent_crime_rate*(SUM = '')) (property_crime_rate*(SUM = '')) (arson_crime_rate*(SUM = '')));
run;



PROC SGPLOT DATA = uscrpt.tot_crime_state_rate;
	VBAR STATE / RESPONSE = Violent_crime_rate GROUP = YEAR GROUPDISPLAY=CLUSTER DATASKIN= sheen ;
	YAXIS LABEL = 'Crime Rate per 100,000';
 	TITLE 'Violent Crime rate by state for the year 2014 and 2015';
RUN;
QUIT;

PROC SGPLOT DATA = uscrpt.tot_crime_state_rate;
	VBAR STATE / RESPONSE = Property_crime_rate GROUP = YEAR GROUPDISPLAY=CLUSTER DATASKIN= sheen ;
	YAXIS LABEL = 'Crime Rate per 100,000';
 	TITLE 'Property Crime rate by state for the year 2014 and 2015';
RUN;
QUIT;


PROC SGPLOT DATA = uscrpt.tot_crime_state_rate;
	VBAR STATE / RESPONSE = Arson_crime_rate GROUP = YEAR GROUPDISPLAY=CLUSTER DATASKIN= sheen ;
	YAXIS LABEL = 'Crime Rate per 100,000';
 	TITLE 'Arson Crime rate by state for the year 2014 and 2015';
RUN;
QUIT;

proc print data = uscrpt.cleandata;
run;


proc sql;
create table crimedata2014 as
select distinct(state),year,SUM(Population) as Population,SUM(Murder) as Murder,SUM(Robbery)as Robbery,
		SUM(Aggravated_Assault)as AggravatedAssault,SUM(Rape)as Rape from uscrpt.cleandata where 
		state in ('NEW MEXICO','MISSISSIPPI','WASHINGTON') and year = 2014 group by State;
run;

proc sql;
create table crimedata2015 as
select distinct(state),year,SUM(Population) as Population,SUM(Murder) as Murder,SUM(Robbery)as Robbery,
		SUM(Aggravated_Assault)as AggravatedAssault,SUM(Rape)as Rape from uscrpt.cleandata where 
		state in ('NEW MEXICO','MISSISSIPPI','WASHINGTON') and year = 2015 group by State;
run;


