libname USCRPT "/home/harshaep0/DAPAssignment";
run;

FILENAME TEMPFILE '/home/harshaep0/DAPAssignment/cleanuscr1.csv';
*FILENAME TEMPFILE '/home/harshaep0/DAPAssignment/FORMATDATA.csv';

proc import datafile = TEMPFILE 
			out = USCRPT.cleanuscr1
			DBMS=CSV replace;
			guessingrows= 520;
			options;
			getnames = yes;
run;

proc print data = uscrpt.cleanuscr1;
run;

data USCRPT.formatdata; 
	set USCRPT.cleanuscr1;
	total_crime_city = sum(Violent_Crime,Property_crime,arson);
	vio_crime_per = (violent_crime/total_crime_city) * 100;
	prop_crime_per = (property_crime/total_crime_city) * 100;
	arson_per = (arson/total_crime_city) * 100;
	Vio_Crime_Rate = (Violent_Crime/Population)*100000;
	Pro_Crime_Rate = (Property_Crime/Population)*100000;
	Arson_Crime_Rate = (Arson/Population)*100000;
	Tot_Crime_Rate = (Total_Crime_City/Population)*100000;
	drop murder robbery aggravated_assault burglary larceny_theft motor_vehicle_theft rape;
	label Violent_Crime = 'Violent Crime'
		  Property_Crime = 'Property Crime'
		  Total_Crime_City = 'Total Crime'
		  Vio_Crime_Rate = 'Violent Crime Rate'
		  Pro_Crime_Rate = 'Property Crime Rate'
		  Arson_Crime_Rate = 'Arson Crime Rate'
		  Tot_Crime_Rate = 'Total Crime Rate';
	format population comma9. vio_crime_per 5.2 prop_crime_per 5.2 arson_per 5.2 vio_crime_rate 6.
		   Pro_Crime_Rate 6. Arson_Crime_Rate 6. Tot_Crime_Rate 6.;
run;


proc contents data = uscrpt.formatdata;
run;

proc print data = uscrpt.formatdata;
run;

proc sort data = uscrpt.formatdata;
by descending population;
run;

/* Proc to find total Crime data per State and City Objective 1*/



proc tabulate data = USCRPT.formatdata out = uscrpt.tot_crime_state order=data format = comma10.;
title 'Total crime count for each state per year';
	 class State Year;
	 var population violent_Crime property_crime arson total_crime_city;
	table state all,year*((population*(SUM='')) (violent_Crime*(SUM='')) (property_crime*(SUM='')) 
		  (arson*(SUM='')) (total_crime_city*(SUM=''))); 
	RUN;
	
proc tabulate data = USCRPT.formatdata out = uscrpt.tot_crime_city order=data format = comma10.;
title 'Total crime count for each City per year';
	 class City Year;
	 var population violent_Crime property_crime arson total_crime_city;
	table City all,year*((population*(SUM='')) (violent_Crime*(SUM='')) (property_crime*(SUM='')) 
		  (arson*(SUM='')) (total_crime_city*(SUM=''))); 
	RUN;



/* to get rank based on violent crime rate per city*/
proc sort data = uscrpt.formatdata out = asc_report;
		  by State;
run;

/*Population per state*/
proc print data = work.asc_report noobs;
run;
proc sort data = work.asc_report;
	by year;
run;


/* to get rank based on violent crime rate per city*/
proc rank data = work.asc_report out = top3 ties = dense descending;
	by year;
	var tot_crime_rate;
	ranks totcrime_rank;
run;

proc sort data = work.top3;
by totcrime_rank;
run;

title 'City Rank based on Total Crime Rate for year 2014';
proc print data = work.top3 label noobs;
	var state city year population Total_Crime_city tot_crime_rate totcrime_rank;
	where year = 2014;
	label totcrime_rank = 'Total Crime Rank';
	format  total_crime_city comma9. tot_crime_rate comma9.;
run;
	
title 'City Rank based on Total Crime Rate for the year 2015';
proc print data = work.top3 label noobs;
	var state city year population Total_Crime_city tot_crime_rate totcrime_rank;
	where year = 2015;
	label totcrime_rank = 'Total Crime Rank';
	format  total_crime_city comma9. tot_crime_rate comma9.;
run;

/*proc tabulate data = work.top3 out = uscrpt.top3 order=data format = comma10.;
title 'Total crime count for each City per year';
	 class City Year;
	 var population violent_Crime property_crime arson total_crime_city vio_crime_rate viocrime_rank;
	table City all,year*((population*(SUM='')) (violent_Crime*(SUM='')) (property_crime*(SUM='')) 
		  (arson*(SUM='')) (total_crime_city*(SUM='')) (vio_crime_rate*(SUM = '')) (viocrime_rank*(SUM=''))); 
	RUN; */


proc print data = uscrpt.tot_crime_state;
run;

/*Highest Crime Rate per State*/
data uscrpt.tot_crime_state_2014;
	set uscrpt.tot_crime_state;
	where year = 2014;
run;

proc print data = uscrpt.tot_crime_State (obs=43) noobs;
where year = 2014;
run;

data uscrpt.tot_crime_state_rate;
set uscrpt.tot_crime_state;
	tot_crime_state_rate = (total_crime_city_sum/Population_sum)*100000;
	format tot_crime_state_rate comma10.;
run;

proc print data = uscrpt.tot_crime_state_rate noobs;
	where year = 2014;
run;
proc sort data = uscrpt.tot_crime_state_rate;
by descending Tot_crime_state_rate;
where year = 2014;
run;

title 'Highest Total Crime Rate by State for Year 2014';
proc print data = uscrpt.tot_crime_state_rate label noobs;
	var State Year Population_sum Violent_Crime_sum Property_Crime_sum Arson_sum 
		Total_crime_city_sum tot_crime_state_rate;
	label Population_Sum = 'State Population'
		  Violent_Crime_Sum = 'Total Violent Crime of State'
		  Property_Crime_Sum = 'Total Property Crime of State'
		  Arson_sum = 'Total Arson Crime of State'
		  Total_crime_city_sum = 'Total Crime of State'
		  Tot_crime_state_rate = 'Crime Rate of State';
	format population_sum comma9. violent_crime_sum comma9. property_crime_sum comma9.
		   arson_sum comma9. total_crime_city_sum comma9. total_crime_state_rate comma9.;

run;


data uscrpt.tot_crime_state_2015;
	set uscrpt.tot_crime_state;
	where year = 2015;
run;

proc print data = uscrpt.tot_crime_State (obs=43) noobs;
where year = 2015;
run;

data uscrpt.tot_crime_state_rate;
set uscrpt.tot_crime_state;
	tot_crime_state_rate = (total_crime_city_sum/Population_sum)*100000;
	format tot_crime_state_rate comma10.;
run;


proc sort data = uscrpt.tot_crime_state_rate;
by descending Tot_crime_state_rate;
where year = 2015;
run;

title 'Highest Total Crime Rate by State for Year 2015';
proc print data = uscrpt.tot_crime_state_rate label noobs;
	var State Year Population_sum Violent_Crime_sum Property_Crime_sum Arson_sum 
		Total_crime_city_sum tot_crime_state_rate;
	label Population_Sum = 'State Population'
		  Violent_Crime_Sum = 'Total Violent Crime of State'
		  Property_Crime_Sum = 'Total Property Crime of State'
		  Arson_sum = 'Total Arson Crime of State'
		  Total_crime_city_sum = 'Total Crime of State'
		  Tot_crime_state_rate = 'Crime Rate of State';
	format population_sum comma9. violent_crime_sum comma9. property_crime_sum comma9.
		   arson_sum comma9. total_crime_city_sum comma9. total_crime_state_rate comma9.;

run;




