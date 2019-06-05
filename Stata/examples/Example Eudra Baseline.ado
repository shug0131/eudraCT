

cap program drop blinexmlloopercat
program define blinexmlloopercat
syntax [varlist] [if] , ///
	file(str) ///
	reportinggrp(str) 	///
	SUBJECTset(int) 	///
	TOTALBLgroup(int) 	///
	ctrl(int) ///
	exp(str) ///
	units(str) ///
	category(int) ///
[ 	Trt(varlist) ///  
	desc(str) ///
	qui ///
	type append	]
	
cap file close fhand 
if "`append'" == "" ///
file open fhand using "`file'", write replace
else file open fhand using "`file'", write append

// set trace on 

//
// 		"                <term>`desc'</term>" _n ///
// 		"				<organSystem>" _n ///
// 		"					<eutctId>`eutctId'</eutctId>" _n ///
// 		"				<version>22</version>" _n ///
// 		"				</organSystem>" _n ///

tokenize "`reportinggrp'"

local acount 1
foreach t in `ctrl' `exp' {
local reportinggrp`t' ``acount''
local ++acount
}
	
local vcount 1

foreach v in `varlist' {

local label : var label `v'
if "`label '" == "" local label  `v'
file write fhand ///
"            <studyCategoricalCharacteristic>" _n ///
"                <readyForValues>true</readyForValues>" _n ///
"                <title>`label'</title>" _n ///
"                <description></description>" _n ///
"                <unit>`units'</unit>" _n ///
"                <reportingGroups>" _n 

levelsof `v' `if' , local(`v') 
local levels = `r(r)'
	
	//within group
	foreach t in `ctrl' `exp' {
	file write fhand ///
	`"                    <reportingGroup baselineReportingGroupId="BaselineReportingGroup-`reportinggrp`t''">"' _n ///
	"                        <countableValues>" _n 

	local lcount 1
		foreach l in ``v'' {
		local category`lcount' = `category' + `lcount'
		if "`if'" != "" ///
		qui count `if' & `v' == `l' & `trt' == `t'
		else qui count if `v' == `l' & `trt' == `t'
		
		file write fhand ///
		`"                            <countableValue categoryId="Category-`category`lcount''">"' _n ///
		"								<value>`r(N)'</value>" _n ///
		"                            </countableValue>" _n 

		local ++lcount
		}	
	file write fhand ///
	"                        </countableValues>" _n ///
	"                    </reportingGroup>" _n 
	}	

	file write fhand ///
		"                </reportingGroups>" _n 
	
	//totals
	file write fhand ///
	"                <subjectAnalysisSets>" _n /// 
	`"                    <subjectAnalysisSet subjectAnalysisSetId="SubjectAnalysisSet-`subjectset'">"' _n 

	local lcount 1
	
	file write fhand ///	
	"                        <countableValues>" _n 
	
		foreach l in ``v'' {
		local category`lcount' = `category' + `lcount'
		if "`if'" != "" ///
		qui count `if' & `v' == `l' 
		else qui count if `v' == `l' 
		
		file write fhand ///	
		`"                            <countableValue categoryId="Category-`category`lcount''">"' _n ///
		"								<value>`r(N)'</value>" _n ///
		"                            </countableValue>" _n 

		local ++lcount
		}
	
	file write fhand ///
	"                        </countableValues>" _n ///	
	"                    </subjectAnalysisSet>" _n ///
	"                </subjectAnalysisSets>" _n 

	local lcount 1
	local ++totalblgroup
	
	file write fhand ///	
	`"                <totalBaselineGroup id="TotalBaselineGroup-`totalblgroup'">"' _n ///
    "                	<title>Total `label'</title>" _n  ///
	"						<countableValues>" _n
  
		foreach l in ``v'' {
		local category`lcount' = `category' + `lcount'
		if "`if'" != "" ///
		qui count `if' & `v' == `l' 
		else qui count if `v' == `l' 
		
		file write fhand ///	
		`"                            <countableValue categoryId="Category-`category`lcount''">"' _n ///
		"								<value>`r(N)'</value>" _n ///
		"                            </countableValue>" _n 

		local ++lcount
		}
                    
	file write fhand ///
	"                        </countableValues>" _n ///	
	"					</totalBaselineGroup>" _n
	
	local lcount 1
	
	file write fhand ///
	"                <categories>" _n 
	
	foreach l in ``v'' {
	local vlabel: value label `v'
	local vlabel: label `vlabel' `l'
	if "`vlabel'" == "" local vlabel `v'
	file write fhand ///
	`"                    <category id="Category-`category`lcount''">"' _n ///
	"                        <name>`vlabel'</name>" _n ///
	"                    </category>" _n 

	local ++lcount
	}
	
	file write fhand ///
	"                </categories>" _n ///	
	"            </studyCategoricalCharacteristic>" _n 

	local category = `category' + `levels' + 1 

	local ++vcount
	}		
cap file close fhand 

if "`type'" != "" type "`file'"

end

////////////////////////////////////////////////////////////////////////////////
