data preamble;
infile "&PATH\&ct_original" dlmstr="nodlmstr";
format line $2000.;
input;
retain my_keep 1;
line = _infile_;
pos=find(line, "<reportedEvents");
if 0< pos then do;
	line= substr(line,1,pos-1);
	output;
	my_keep=0;
end;
if my_keep=1 then output;
keep line;
run;

data epilogue;
infile "&PATH\&ct_original" dlmstr="nodlmstr";
format line $2000.;
input;
retain my_keep 0;
line = _infile_;
pos=find(line, "<reportedEvents/>");
if 0< pos then do;
	line= substr(line,pos+17);
	my_keep=1;
end;
pos=find(line, "</reportedEvents>");
if 0< pos then do;
	line= substr(line,pos+17);
	my_keep=1;
end;
if my_keep=1 then output;
keep line;
run;



data content;
infile "&PATH\table_ct_gov.xml" dlmstr="nodlmstr";
format line $2000.;
input;
retain my_keep 0;
line = _infile_;
pos=find(line, "<reportedEvents>");
if 0< pos then do;
	line= substr(line,pos);
	my_keep=1;
end;
pos=find(line, "</reportedEvents>");
if 0< pos then do;
	line= substr(line,1, pos+16);
	output;
	my_keep=0;
end;
if my_keep=1 then output;
keep line;
run;


data _null_; 
set preamble content epilogue;
file "&PATH\table_ct_gov.xml" ;
put line ;
run;