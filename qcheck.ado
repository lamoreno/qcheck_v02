*!v 0.1 <30Nov2016> <Laura Moreno> <Andres Castaneda>
*=====================================================================
*	Qcheck: Program to check the quality of the data
*	Reference: 
*-------------------------------------------------------------------
*Created for datalib/LAC:		15Jul2013	(Santiago Garriga & Andres Castaneda) 
*Adapted for datalibweb:		8/1/2016	(Laura Moreno) 
*Last Modifications: 7Oct2019   Sandra Segovia / Laura Moreno
*Last Modifications: 20Dec2019   Sandra Segovia / Laura Moreno / Jayne Jungsun
*Last Modifications: 02Jan2020   Laura Moreno / Jayne Jungsun
*Version not using datalibweb/datalib:  Adriana Casillo / Laura Moreno
*version:		01 
*Dependencies: 	WORLD BANK - LCSPP
*=====================================================================
#delimit ;
discard;
cap program drop qcheck;
program define qcheck, rclass;
syntax varlist									///
		[if] [in]								///
		[aweight fweight pweight], 				///
		[									///
			SUMmarize				///
			CATsummarize			///
			STAtic					///
			load					///
			file(string)			///
			out(string)				///
			TESTname(string)		///
			TESTPath(string)		///
			TESTFile(string)		///
			replace 				///
		]

*---------------------------------;
*	Save database open         ;
*---------------------------------;

*---------------------------------;
*		Update Static Analysis  test         ;
*---------------------------------;
cap which unique;
if _rc ssc describe unique;

cap which missings;
if _rc ssc install missings;

cap which labelrename;
if _rc net install dm0012, from(http://www.stata-journal.com/software/sj5-2/);

cap which filelist;
if _rc ssc install filelist;

cap which apoverty;
if _rc ssc install apoverty;

cap which ainequal;
if _rc ssc install ainequal;



*---------------------------------------------;
* Weights treatment
loc weight "[`weight' `exp']"
	
*---------------------------------;
*		Dynamic Analysis          ;
*---------------------------------;

if ("`summarize'"=="summarize") {;

	qchecksum `varlist' `weight', file("`file'") out(`out');	

};
* end dynamic;
*---------------------------------;
*		Categorical Analysis          ;
*---------------------------------;

if ("`catsummarize'"=="catsummarize") {;

	qcheckcat `varlist' `weight', file("`file'") out(`out');	

};

*---------------------------------;
*		Static Analysis           ;
*---------------------------------;
if ("`static'"=="static") {;

	quietly findfile qcheck.ado;
	global salt_adoeditpath=subinstr("`r(fn)'","/qcheck.ado","",.);
* check testpath;
		if ("`testpath'"=="") {;
			noi di as error "Define a folder to save results, type path" _request(_testpath) ;
				if ("`testpath'"=="cd") | ("`path'"=="CD") {;
				local testpath "`c(pwd)'";
				noi di  _col(10) as result "results will be saved in the current directory: `testpath' ";
				};
				glo salt_pathfile "`path'" ;
				noi di  _col(10) as result "results will be saved in the following directory: `testpath' ";
			};
		else {;
			glo salt_pathfile "`testpath'";
			noi di  _col(10) as result "results will be saved in the following directory: `testpath' ";
			};
* check testfile;
	if ("`testfile'"=="") {;
			noi di as error "Test file is not defined, type test file test" _request(_testfile) ;
			local test `testfile';
		};
		if (strmatch("`testfile'","qcheck")==0) {;
			if (strmatch("`testfile'","qcheck_")==0) {;
				local test=subinstr("`testfile'", "qcheck_","",.);
			};
			else {;
				local test=subinstr("`testfile'", "qcheck","",.);
			};
		};
		else {; local test "`testfile'"; };
* load test file
if (regexm("`load'", `"^load"')) {;
	qui{ ;  
		************* RELOAD OPTION;
		noi di in text "Tests from `testfile'.xlsx. Note: sheets must be named Test and Variable";
		import excel using "${salt_pathfile}\\`testfile'.xlsx", sheet(Test) case(lower) clear firstrow;
		cap save "${salt_adoeditpath}\testqcheck_`testname'.dta", `replace' ;
		if (_rc==602) {; noi di in red "	-> `test' already exists. Try with the option replace"; exit; };
		
		import excel using "${salt_pathfile}\\`testfile'.xlsx", sheet(Variables) case(lower) clear firstrow;
		save "${salt_adoeditpath}\varqcheck_`testname'.dta", `replace' ;
		noi di in text "Tests from `testfile'.xlsx saved. Both sheets Test and Variables were saved";
	} ; 
	exit;
};

	qcheckstatic `varlist' `weight', file("`file'") out(`out') testname(`testname');	

};

*end static;

****************************************************test completed, saved in long format**************
*---------------------------------;
*		Excel dashboard           ;
*---------------------------------;


#delimit cr	 	
end


exit
****************************************************************************************************************










