/*----------------------------------------------------------------------------*
| MACRO NAME  : xmlib
| SHORT DESC  : This macro is for multiple data export to one XML file with 
|               LIBNAME ENGINE. 
*-----------------------------------------------------------------------------*
| CREATED BY  : Alimu Dayimu                   (25/01/2019)
*-----------------------------------------------------------------------------*
| PURPOSE
|
| Create a multiple data XML output macro with LIBNAME ENGINE.
*-----------------------------------------------------------------------------*
| Macros
| 1. xmlib     - Setup XML target template.
| 2. xmlappend - Export (append) dataset(s) to one XML file.
*-----------------------------------------------------------------------------*
| OPERATING SYSTEM COMPATIBILITY
| PC SAS v9.4 TS1M2   :   Passed
|
*-----------------------------------------------------------------------------*
| NOTE
|
| Based on macro from Richard A. DeVenezia, http://www.devenezia.com
|
*-----------------------------------------------------------------------------*/


%macro xmlib (store=sasuser.templat);

   /*
    * Note: Tagset names xmlib<0|1><0|1> correspond to 0|1 state values
    * of start and finish macro variables in xmlappend
    */

   ods path &store (update)
            sashelp.tmplmst (read);

   proc template;

      define tagset Tagsets.xmlib__ /store=&store;
	  mvar which_data;
         notes "multiple tables SAS-XML generic";

         define event doc;
            start: break;
            finish:break;
         end;

		 notes "SAS XML Engine output event model(interface)";

      indent = 3;
      map = '<>&"''';
      mapsub = '/&lt;/&gt;/&amp;/&quot;/&apos;/';


   /* +------------------------------------------------+
      |                                                |
      +------------------------------------------------+ */

      define event XMLversion;
         put  '<?xml version="1.0"';
         putq ' encoding=' ENCODING;
         put  ' ?>' CR;
         break;
      end;


      define event XMLcomment;
         put  '<!-- ' CR;
         put  '     ' TEXT CR;
         put  '  -->' CR;
         break;
      end;


      define event initialize;
      set   $LIBRARYNAME          'safety_data' ;
      set   $TABLENAME            'DATASET' ;
      set   $COLTAG               'column' ;
      set   $META                 'FULL' ;

      end;


   /* +------------------------------------------------+
      |                                                |
      +------------------------------------------------+ */

	  define event doc;
            start: 
			trigger initialize;
			break;
            finish:break;
         end;

      define event doc_head;
      start:
         break;
      finish:
         break;
      end;


      define event doc_body;
      start:
         break;
      finish:
         break;
      end;

      define event table;
      start:
         unset $col_names;
         unset $col_types;
         unset $col_width;
         eval  $index      1;
         eval  $index_max  0;
         set   $TABLENAME name / if name;           /* LIBNAME ENGINE */
         set   $META XMLMETADATA / if XMLMETADATA ; /* LIBNAME ENGINE */
         set   $SCHEMA XMLSCHEMA / if XMLSCHEMA ;   /* LIBNAME ENGINE */
         break;
      finish:
         break;
      end;


      define event colspecs;
      start:
         break / if cmp(XMLMETADATA, "NONE");
      finish:
         break / if cmp(XMLMETADATA, "NONE");
      end;


      define event colgroup;
      start:
         break / if cmp(XMLMETADATA, "NONE");
      finish:
         break / if cmp(XMLMETADATA, "NONE");
      end;


   /* +------------------------------------------------+
      |                                                |
      +------------------------------------------------+ */

      define event colspec_entry;
      start:
         break / if ^$is_engine and $index eq 1 and cmp(name, "Obs");
         eval  $index_max $index_max+1;
         set $col_names[] name;
         set $col_types[] type;
         set $col_width[] width;
         break;
      finish:
         break;
      end;

      
      define event table_head;
      start:
         break;
      finish:
         break;
      end;


      define event table_body;
      start:
		 put '<' which_data '>' CR ; /*Add table name*/
         break;
      finish:
	  put '</' which_data '>' CR; /*Add table name*/
         break;
      end;

   /* +------------------------------------------------+
      |                                                |
      +------------------------------------------------+ */

      define event row;
      start:
         break / if !cmp(SECTION, "body");
         break / if cmp(XMLMETADATA, "ONLY");
         eval    $index 1;
         unset   $col_values;
         break;
      finish:
         break / if !cmp(SECTION, "body");
         break / if cmp(XMLMETADATA, "ONLY");
         trigger EmitRow ;
         break;
      end;


      define event data;
      start:
         break / if !cmp(SECTION, "body");
         break / if !cmp(XMLCONTROL, "Data");
         break / if cmp(XMLMETADATA, "ONLY");
         set $name $col_names[$index];
         do / if exists(MISSING);
            eval  $is_MISSING  1;
            eval  $value_MISSING MISSING;
            set   $col_values[$name] " ";
         else ;
            eval  $is_MISSING  0;
            set   $col_values[$name] VALUE;
         done;
         break;
      finish:
         break / if !cmp(SECTION, "body");
         break / if !cmp(XMLCONTROL, "Data");
         break / if cmp(XMLMETADATA, "ONLY");
         set  $name  $col_names[$index];
         eval $index $index+1;
         break;
      end;

   /* +------------------------------------------------+
      |                                                |
      | at this point, we just take over XML output.   |
      | EmitRow() is triggered each time the data is   |
      |           loaded into the $col_values array.   |
      |                                                |
      | we can output anything we desire from here...  |
      |                                                |
      +------------------------------------------------+ */


/*Loop columns*/
      define event EmitRow; 
         ndent; 
         put '<row>' CR ; 
         ndent; 
         eval    $index 1; 
         eval $count $col_names; 
         do /while $index <= $count; 
            set  $name  $col_names[$index] ; 
            set  $value $col_values[$name] ; 
            trigger EmitCol ; 
            eval $index $index+1; 
            done; 
         xdent; 
         put '</row>' CR ; 
         xdent; 
         break; 
      end; 

      define event EmitCol; 
         unset $value;
         set $value $col_values[$name];
         put '<'  $name '>' ;
         put      $value ;
         put '</' $name '>' CR ;
         break;
      end;

	end;

      define tagset Tagsets.xmlib10 /store=&store;
         parent = tagsets.xmlib__;
         notes "first of multiple tables SAS-XML generic";
         define event doc;
            start:
			trigger initialize;
         	trigger XMLversion;
		 	put '<safety_data>' CR ;
         end;
      end;

      define tagset Tagsets.xmlib00 /store=&store;
         parent = tagsets.xmlib__;
         notes "middle of multiple tables SAS-XML generic";
      end;

      define tagset Tagsets.xmlib01 /store=&store;
         parent = tagsets.xmlib__;
         notes "last of multiple tables SAS-XML generic";
         define event doc;
		 	start:
				trigger initialize;
            finish:
              put "</safety_data>" CR;
         end;
      end;

      define tagset Tagsets.xmlib11 /store=&store;
         parent = tagsets.xmlib__;
         notes "only of multiple tables SAS-XML generic";
         define event doc;
      start:
         trigger initialize;
         trigger XMLversion;
		   put '<safety_data>' CR ;
         break;
      finish:
	  	   put '</safety_data>' CR;
         break;
      end;

      end;
   run;

%mend;


%macro xmlappend (
    file=
  , data = 
  , out=
  , start  = 0
  , finish = 0
  , which_data=
);

  %if &start ne 0 and &start ne 1 %then %do;
    %put ERROR: Start must be 0 or 1;
    %goto EndMacro;
  %end;

  %if &finish ne 0 and &finish ne 1 %then %do;
    %put ERROR: Finish must be 0 or 1;
    %goto EndMacro;
  %end;

  %if (%superq(file) eq ) %then %do;
    %put ERROR: File should be supplied;
    %goto EndMacro;
  %end;

  /*
   * Note: tagset specified corresponds directly with <start><finish> state
   * Note: mod option allows only appending, if not present (asis in start=1 state)
   *       each datastep would overwrite destination file
   * Note: if out= is not specified the member name of the data set is used
   */

  %local xmlib mod dsid out which_data;

  %let which_data = &which_data;

  %let xmlib = _%substr (%sysfunc (ranuni(0), 9.7), 3);

  %if &start=0 %then %let mod=mod;

  filename &xmlib "&file" &mod;
  libname  &xmlib xml tagset=tagsets.xmlib&start&finish;

   %if %length(&out)=0 %then %do;
     %let dsid = %sysfunc (open (&data));
     %let out  = %sysfunc (attrc (&dsid, MEM));
     %let dsid = %sysfunc (close (&dsid));
   %end;

   %local any;
   %let any = 0;

   data &xmlib..&out;
     set &data end=__end__;

     if __end__ then call symput ('any', '1');
   run;

   libname  &xmlib;
   filename &xmlib;

%EndMacro:

%mend;

