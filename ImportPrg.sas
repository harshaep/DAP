/*Program to import the USCrimeReport Excel file*/

libname USCRPT "/home/harshaep0/DAPAssignment";
run;

FILENAME TEMPFILE '/home/harshaep0/DAPAssignment/USCrimeReport.xls';
proc import datafile = TEMPFILE 
			out = USCRPT.USCReport 
			DBMS=XLS replace;
			options validvarname = V7;
			datarow = 5;
			getnames = yes;
			range = "15table4$A5:O525";
run;

proc print data=USCRPT.USCReport noobs;
run;

/* Data and stdize proc to clean and transform variable names and data to standard format for variable names, 
state names and mean value for missing integer values, state names, city names and calculate population */

data work.tempUSCR (drop = fil_state fil_city fil_population);
	 rename c = Year
	 		Population1 = Population
	 		VAR7 = Rape_Revised
	 		VAR8 = Rape_Legacy
	 		Larceny__theft = Larceny_theft
	 		Arson4 = Arson;
	 set uscrpt.USCREPORT;
	 retain fil_state fil_city fil_population;
	 if not missing (State) 
	 		then fil_state = State;
	 		State = fil_state;
	 if not missing (City)
	 		then fil_city = City;
	 		City = fil_city;
	 if not missing (Population1) 
	 		then fil_population = round(Population1+(Population1*0.0076));
	 		else Population1 = fil_population;
	 Rape = round(Sum(VAR7,VAR8));
	 City=compress(City,"0123456789");
   	 State=compress(State,"0123456789");
	 drop VAR7 VAR8;
	 output tempUSCR;
run;


/* Stdize proc to replace all the missing numeric values with mean*/

proc format;
 value $missval ' '='Missing' other='Not Missing';
 value  missval  . ='Missing' other='Not Missing';
run;
 
title1  h=7pt " ";
proc freq data=USCRPT.USCReport; 
format _Char_ $missval.; 
tables _Char_ / missing missprint nocum nopercent;
format _NUMERIC_ missval.;
tables _NUMERIC_ / missing missprint nocum nopercent;
run;

proc stdize data = work.tempUSCR out = USCRPT.CleanData missing = mean reponly;
	var _numeric_;	
	format violent_crime 9. murder 9. robbery 9. aggravated_assault 9. 
		   property_crime 9. burglary 9. larceny_theft 9. motor_vehicle_theft 9. arson 9. rape 9.;
run;

proc print data = USCRPT.CleanData noobs;
run;


/* Data Proc to generate new variables*/
data USCRPT.formatdata; 
	set USCRPT.CleanData;
	total_crime_city = sum(Violent_Crime,Property_crime,arson);
	vio_crime_per = (violent_crime/total_crime_city) * 100;
	prop_crime_per = (property_crime/total_crime_city) * 100;
	arson_per = (arson/total_crime_city) * 100;
	drop murder robbery aggravated_assault burglary larceny_theft motor_vehicle_theft rape;
	format population comma9. vio_crime_per 5.2 prop_crime_per 5.2 arson_per 5.2 total_crime_city 9.;
run;

proc print data = uscrpt.formatdata noobs;
run;



