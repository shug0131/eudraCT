/*Define working directory*/
%let PATH=V:\STATISTICS\NON STUDY FOLDER\Academic Research\Eudract Tool;


/*Import data*/
proc import datafile="&path.\xslt material\group.csv"
        out=group
        dbms=csv
        replace;
run;
proc import datafile="&path.\xslt material\non_serious.csv"
        out=non_serious
        dbms=csv
        replace;
run;
proc import datafile="&path.\xslt material\serious.csv"
        out=serious
        dbms=csv
        replace;
run;


/*Output Data to XML file*/
%inc "V:\STATISTICS\NON STUDY FOLDER\Academic Research\Eudract Tool\SAS\xmlib.sas"; /*Source the macro for XML output*/

/*Method 1*/
/*Everything by hand*/

%xmlib; * only needed once, best in an automacro library called from autoexec;
%let xmlOut=V:\STATISTICS\NON STUDY FOLDER\Academic Research\Eudract Tool\SAS\safety.xml; 

%xmlappend(file=&xmlOut, data=group, start=1, which_data = group);
%xmlappend(file=&xmlOut, data=non_serious, which_data = non_serious);
%xmlappend(file=&xmlOut, data=serious, finish=1, which_data = serious);

/*Method 2*/
/*Define a macro*/

%macro Eudract(group=, non_serious=, serious=, outfile=);
	%xmlib; 
	%let xmlOut=&outfile; 

	%xmlappend(file=&xmlOut, data=&group, start=1, which_data = group);
	%xmlappend(file=&xmlOut, data=&non_serious, which_data = non_serious);
	%xmlappend(file=&xmlOut, data=&serious, finish=1, which_data = serious);
%mend;


%Eudract(group=group, non_serious=non_serious, serious=serious, 
		 outfile=V:\STATISTICS\NON STUDY FOLDER\Academic Research\Eudract Tool\SAS\safety.xml);









