/* to get total crime ratio and percentage change*/
/* SHow top 3 and last 3*/
proc print data = uscrpt.formatdata;
run;

data uscrpt.rate;
	set uscrpt.formatdata;
crime_rate = (total_crime_city/population)*100000;
run;

proc sort data = uscrpt.rate;
	by state;
run;
proc print data = uscrpt.rate noobs;
by state;
run;

data rate2014 rate2015;
	set uscrpt.rate;
	if (Year = 2014) then output rate2014;
	if (Year = 2015) then output rate2015;
	
run;

proc print data = work.rate2014;
run;

proc print data = work.rate2015;
run;
data rate2015_new;
	set work.rate2015;
	rename crime_rate = crime_rate_2015
		   population = population_2015
		   violent_crime = vio_crime_2015
		   property_crime = pro_crime_2015
		   arson = arson_2015
		   total_crime_city = tot_crime_city_2015
		   vio_crime_per = vio_crime_per_2015
		   prop_crime_per = prop_crime_per_2015
		   arson_per = arson_per_2015;
run;

data uscrpt.rate_year (drop = year );
	merge rate2014 rate2015_new;
	by state;
	Tot_Crime_per_change = (crime_rate_2015-crime_rate)/crime_rate * 100;
	Vio_Crime_Per_Change = (Vio_crime_2015-violent_crime)/violent_crime * 100;
	Pro_Crime_per_Change = (Pro_Crime_2015 - property_Crime)/Property_Crime * 100;
run;

/*Sort data set in descending order of Violent Crime Change*/
proc sort data = uscrpt.rate_year;
by descending vio_crime_per_change;
run;


title 'Top Violent Crime Percentage Increase by Cities';
proc print data = uscrpt.rate_year label noobs; 
	var State City Population violent_crime vio_crime_2015 vio_crime_per_change;
	label violent_crime = '2014 Violent Crime'
		  vio_crime_2015 = '2015 Violent Crime' 
		  vio_crime_per_change = 'Violent Crime Percentage Change';
	format violent_crime comma6. vio_crime_2015 comma6. vio_crime_per_change comma7.2;
run;

proc sort data = uscrpt.rate_year;
by vio_crime_per_change;
run;

title 'Least Violent Crime Percentage Increase by Cities';
proc print data = uscrpt.rate_year label noobs; 
	var State City Population violent_crime vio_crime_2015 vio_crime_per_change;
	label violent_crime = '2014 Violent Crime'
		  vio_crime_2015 = '2015 Violent Crime' 
		  vio_crime_per_change = 'Violent Crime Percentage Change';
	format violent_crime comma6. vio_crime_2015 comma6. vio_crime_per_change comma7.2;
run;


/*Sort Dataset in descending order of Property Crime Change*/
proc sort data = uscrpt.rate_year;
by descending pro_crime_per_change;
run;

title 'Top Property Crime Percentage Increase by Cities';
proc print data = uscrpt.rate_year label noobs; 
	var State City Population Property_crime pro_crime_2015 pro_crime_per_change;
	label property_crime = '2014 Property Crime'
		  pro_crime_2015 = '2015 Property Crime' 
		  pro_crime_per_change = 'Property Crime Percentage Change';
	format property_crime comma6. pro_crime_2015 comma6. pro_crime_per_change comma7.2;
run;

/*Sort Dataset in descending order of Property Crime Change*/
proc sort data = uscrpt.rate_year;
by pro_crime_per_change;
run;

title 'Least Property Crime Percentage Increase by Cities';
proc print data = uscrpt.rate_year label noobs; 
	var State City Population Property_crime pro_crime_2015 pro_crime_per_change;
	label property_crime = '2014 Property Crime'
		  pro_crime_2015 = '2015 Property Crime' 
		  pro_crime_per_change = 'Property Crime Percentage Change';
	format property_crime comma6. pro_crime_2015 comma6. pro_crime_per_change comma7.2;
run;



/*State wise Violent Crime Change*/
proc sql;
create table uscrpt.vio_crime_state_change as
select distinct(State),SUM(Population)as Population,SUM(Violent_Crime)as ViolentCrime,
	   sum(Property_Crime)as PropertyCrime,sum(arson)as Arson,sum(vio_crime_2015)as ViolentCrime2015,
	   sum(pro_crime_2015)as PropertyCrime2015,sum(arson_2015)as ArsonCrime2015 from uscrpt.rate_year
	   where violent_crime < 30000 group by state;
run;

data  uscrpt.vio_crime_state_change;
set uscrpt.vio_crime_state_change;
Vio_Crime_Per_Change = (Violentcrime2015-violentcrime)/violentcrime * 100;
Pro_Crime_Per_Change = (PropertyCrime2015-PropertyCrime)/Propertycrime * 100;
format violentcrime comma6. violentcrime2015 comma6. vio_crime_per_change comma6.2 pro_crime_per_change comma6.2;
run;


/* Sort to display Top Violent Crime Change States*/
proc sort data = uscrpt.vio_crime_state_change;
by descending vio_crime_per_change;
run;

title 'Top Violent Crime Percentage Change States';
proc print data = uscrpt.vio_crime_state_change label noobs;
var State ViolentCrime ViolentCrime2015 vio_crime_per_change;
label ViolentCrime = 'Violent Crime 2014'
	  ViolentCrime2015 = 'Violent Crime 2015'
	  vio_crime_per_change = 'Violent Crime Percentage Change';
run;

/* Sort to display Least Violent Crime Change States*/
proc sort data = uscrpt.vio_crime_state_change;
by vio_crime_per_change;
run;

title 'Least Violent Crime Percentage Change States';
proc print data = uscrpt.vio_crime_state_change label noobs;
var State ViolentCrime ViolentCrime2015 vio_crime_per_change;
label ViolentCrime = 'Violent Crime 2014'
	  ViolentCrime2015 = 'Violent Crime 2015'
	  vio_crime_per_change = 'Violent Crime Percentage Change';
run;

/* Sort to display Top Property Crime Change States*/
proc sort data = uscrpt.vio_crime_state_change;
by descending pro_crime_per_change;
run;

title 'Top Property Crime Percentage Change States';
proc print data = uscrpt.vio_crime_state_change label noobs;
var State PropertyCrime PropertyCrime2015 Pro_crime_per_change;
	label PropertyCrime = 'Property Crime 2014'
	  	  PropertyCrime2015 = 'Property Crime 2015'
	  	  pro_crime_per_change = 'Property Crime Percentage Change';
	format PropertyCrime comma6. PropertyCrime2015 comma6. Pro_crime_per_change comma6.2;
	  
run;

/* Sort to display Least Property Crime Change States*/
proc sort data = uscrpt.vio_crime_state_change;
by pro_crime_per_change;
run;

title 'Least Property Crime Percentage Change States';
proc print data = uscrpt.vio_crime_state_change label noobs;
var State PropertyCrime PropertyCrime2015 Pro_crime_per_change;
	label PropertyCrime = 'Property Crime 2014'
	  	  PropertyCrime2015 = 'Property Crime 2015'
	  	  pro_crime_per_change = 'Property Crime Percentage Change';
	  format PropertyCrime comma6. PropertyCrime2015 comma6. Pro_crime_per_change comma6.2;
run;





