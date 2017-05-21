/* Data proc for creating my own annotate lables*/
data anno_labels; 
	set maps.uscenter;
		length function $8 color $8;
		retain flag 0;
		xsys='2'; ysys='2'; hsys='3'; when='a';
		function='label'; color='black'; size=2.3;
		if ocean^='Y' and flag^=1 then do;
			text=trim(left(fipstate(state))); position='5'; output;
		end;
		else if ocean='Y' then do;
			text=trim(left(fipstate(state))); position='6'; output;
			function='move'; text=''; position=''; output;
			flag=1;
		end;
		else if flag=1 then do;

			function='draw'; size=.25; output;
			flag=0;
		end;
run;


/*Proc template to create my own coloring style*/
proc template;
	define style patstyles.colors;
	pattern1 c=crimson;
	pattern2 c=green;
	pattern3 c=blue;
	pattern4 c=magenta;
end;
run;
proc format;                                   
   value rate 	low - 1000     = '<1000 - Low'  
                1001 - 2000    = '1000 >- 2000 - Medium'
                2001 - 3000    = '2000 >- 3000 - High'
                3001 - High    = '> 3000 - Extreme';
run;

/* Proc to generate US map with labels

/* Creating table to get separate data for year 2014 and 2015 */
proc sql;
create table state2014 as
	select distinct(state),sum(population) as Population,sum(property_crime) as PropertyCrime,
		   sum(arson) as arson,sum(violent_crime) AS ViolentCrime
	from uscrpt.tempuscr
	where year = 2014 group by State order by State;
run;


proc sql;
create table uscrpt.state2015 as
	select distinct(state),sum(population) as Population,sum(property_crime) as PropertyCrime,
		   sum(arson) as arson,sum(violent_crime) AS ViolentCrime
	from uscrpt.tempuscr
	where year = 2015 group by State order by State;
run;

proc print data = state2014;
run;

/*Creating a new data set with US State Codes*/
data usmaps_new(drop = _map_geometry_ states_geo cont country);
	set maps.us2;
	rename state = state_no
		   statename = state_name;
run;

data usmaps_new;
	set usmaps_new;
	rename state_name = State;
	format state $upcase29.;
run;


/* SQL Proc to create a table to innerjoin my state dataset and State code data set from maps.us2*/
proc sql;
create table uscrpt.state2014_maps as
	select b.state_no,b.statecode,a.State,a.population,a.ViolentCrime,a.Propertycrime,a.arson from state2014 as a 
			inner join usmaps_new as b on upcase(a.State) = upcase(b.State) order by state;
run;

proc print data = uscrpt.state2014_maps;
run;

title1 'United States of America';
title2 '2014 Crime Report per State';
proc print data = uscrpt.state2014_maps label noobs;
	label state_no = 'State No'
		  Statecode = 'State Code'
		  PropertyCrime = 'Property Crime 2014'
		  arson = 'Arson 2014'
		  ViolentCrime = 'Violent Crime 2014';
	format Population comma10. Propertycrime comma7. violentcrime comma7. Arson comma5.;
run;

/* Create maps based on state and with State Code label*/

ods listing style=patstyles.colors;
ods html style=patstyles.colors;
title1 'United States of America';
title2 'States classified with their Names and Code';
proc gmap data = uscrpt.state2014_maps map = maps.us;
	id statecode;
	choropleth State / discrete coutline = black annotate = anno_labels;;
run;
quit;

/* Maps for Total Violent Crime Distribution per state of year 2014*/
ods listing style=patstyles.colors;
ods html style=patstyles.colors;
title1 'United States of America';
title2 'Total Violent Crime Distribution for the year 2014';
proc gmap data = uscrpt.state2014_maps map = maps.us;
	format violentcrime rate. ;
	id statecode;
	choro violentcrime / discrete coutline=gold annotate=anno_labels;
run;
quit;



/* Violent Crime Distribution for year 2015*/
proc sql;
create table uscrpt.state2015_maps as
	select b.state_no,b.statecode,a.State,a.population,a.ViolentCrime,a.Propertycrime,a.arson from uscrpt.state2015 as a 
			inner join usmaps_new as b on upcase(a.State) = upcase(b.State) order by state;
run;


title1 'United States of America';
title2 '2015 Crime Report per State';
proc print data = uscrpt.state2015_maps label noobs;
	label state_no = 'State No'
		  Statecode = 'State Code'
		  PropertyCrime = 'Property Crime 2015'
		  arson = 'Arson 2015'
		  ViolentCrime = 'Violent Crime 2015';
	format Population comma10. Propertycrime comma7. violentcrime comma7. Arson comma5.;
run;

/* Create maps based on state and with State Code label*/



/* Maps for Total Violent Crime Distribution per state of year 2014*/
ods listing style=patstyles.colors;
ods html style=patstyles.colors;
title1 'United States of America';
title2 'Total Violent Crime Distribution for the year 2015';
proc gmap data = uscrpt.state2015_maps map = maps.us;
	format violentcrime rate. ;
	id statecode;
	choro violentcrime / discrete coutline=gold annotate=anno_labels;
run;
quit;

