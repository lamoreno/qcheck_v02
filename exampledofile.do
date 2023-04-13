
* do "P:\SARMD\SAR_GMD\qcheck\do-file\example_dofile.do"
/*====================================================================
project:       qcheck revision for SAR
Author:        Laura Moreno Herrera / Adriana Castillo Castillo
Dependencies:  SAR Stats Team-World Bank 
----------------------------------------------------------------------
Creation Date:    06 04 Jun 2020 
Modification Date:   06 06 Jun 2020 
Do-file version:    01
References:          
Output:             dta, excel
====================================================================*/
version 10
drop _all
*------------------------------
*        0: Program set up
*------------------------------
glo qcheckpath "...\qcheck"
discard
adopath ++ "${qcheckpath}\ado"
global qcheckoutSAR "${qcheckpath}\Output\country-output"

local countries "XXX"

foreach code in `countries' {
    di "`code'"
}



foreach code in `countries' {
	foreach yy of numlist 2018 {
		
*Call data
			
*-----------------------------------------------------------
*## BASIC		
			qchecksum `Allvars' [aw=weight], file("`filename'") out(${qcheckoutSAR}\basicqcheck_`filename')
			
*-----------------------------------------------------------
*## CATEG	
			qcheckcat `ALLvar' [aw=weight], file("`filename'") out(${qcheckoutSAR}\cateqcheck_`filename')

			
	} 
}
 
 
exit
