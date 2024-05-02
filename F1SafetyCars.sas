LIBNAME FPROJ '/home/u63866402/F1Data';
FILENAME REFFILE '/home/u63866402/F1Data/safety_cars.csv';

PROC IMPORT DATAFILE=REFFILE
	DBMS=CSV
	OUT=WORK.IMPORT;
	GETNAMES=YES;
DATA = FPROJ.WIDGE;
SET IMPORT;

*Splitting race column into two;
DATA want;
SET FPROJ.WIDGE;
Year = scan(Race,1,"");
Track = scan(Race,2);
proc PRINT DATA want;

*Frequency Tables for Categorical Variables;
PROC FREQ DATA = WORK.WANT;
TABLES  Track Cause Year;

*Boxplots for Deployed Retreated and FullLaps Variables;
PROC SGPLOT DATA = FPROJ.WIDGE2;
VBOX Deployed / FILLATTRS = (COLOR = VLIGB);
TITLE  "Boxplot For Deployed Variable";
YAXIS LABEL = "Lap";

PROC SGPLOT DATA = FPROJ.WIDGE2;
VBOX Retreated / FILLATTRS = (COLOR = VLIGB);
TITLE  "Boxplot For Retreated Variable";
YAXIS LABEL = "Lap";

PROC SGPLOT DATA = FPROJ.WIDGE2;
VBOX FullLaps / FILLATTRS = (COLOR = VLIGB);
TITLE  "Boxplot For FullLaps Variable";
YAXIS LABEL = "Laps";

*Histograms for Deployed Retreated and FullLaps Variables;
PROC SGPLOT DATA = FPROJ.WIDGE2;
Histogram Deployed / BINWIDTH=5 BINSTART=0 SCALE=count;
TITLE  "Histogram For Deployed Variable";
XAXIS LABEL = "Lap";

PROC SGPLOT DATA = FPROJ.WIDGE2;
HISTOGRAM Retreated / BINWIDTH=5 BINSTART=0 SCALE=count ;
TITLE  "Histogram For Retreated Variable";
XAXIS LABEL = "Lap";

PROC SGPLOT DATA = FPROJ.WIDGE2;
HISTOGRAM FullLaps / BINWIDTH=2 BINSTART=0 SCALE=count;
TITLE  "Histogram For FullLaps Variable";
XAXIS LABEL = "Laps";

*Descriptive Stats for Quantitative Variables;
PROC MEANS DATA = FPROJ.WIDGE MIN Q1 MEAN MEDIAN Q3 MAX STD QRANGE MAXDEC=2;
VAR Deployed Retreated FullLaps;

*Categorizing Deployed Variable;
DATA FPROJ.WIDGE2;
	SET FPROJ.WIDGE;
	IF Deployed < 21 THEN DeployedCat = 1;
	ELSE IF  21<= Deployed <41 THEN DeployedCat = 2;
	ELSE IF 41<= Deployed <61 THEN DeployedCat = 3;
	ELSE IF  Deployed>60 THEN DeployedCat = 4;
PROC FORMAT;
	  VALUE DeployedFormat 1 = 'First20Laps'
						   2 = 'Laps21To40'
						   3 = 'Laps 41To60'
						   4 = 'AfterLap60';
DATA FPROJ.WIDGE2;
	SET FPROJ.WIDGE2;
	FORMAT DeployedCat DeployedFormat.;
PROC PRINT DATA = FPROJ.WIDGE2 (OBS=10);

*Frequency Table for DeployedCat Variable;
PROC FREQ DATA = WORK.WANT;
TABLES  DeployedCat;

*Contingency Table for Track and Cause Variables;
PROC FREQ DATA = WORK.WANT;
TABLES  Track*Cause;

*Boxplots for FullLaps variable by Deployed Cat Variable;
PROC SGPLOT DATA = FPROJ.WIDGE2;
TITLE "Side-By-Side Boxplots of FullLaps By DeployedCat";
HBOX FullLaps / CATEGORY = DeployedCat;
XAXIS LABEL = "Full Laps";
 
