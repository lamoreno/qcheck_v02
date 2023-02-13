/*====================================================================
project:       qcheck revision for SAR
Author:        Laura Moreno Herrera / Adriana Castillo Castillo
Dependencies:  SAR Stats Team-World Bank 
----------------------------------------------------------------------
Creation Date:    0Jun 2020 
Modification Date:   Feb 20203
Do-file version:    01
References:          
Output:             dta, excel
====================================================================*/
version 10
drop _all
*---------------------------------------------------------------------
*        0: Program set up
*---------------------------------------------------------------------
local user "WB473845"
local user "wb575362"

glo qcheckpath "P:\SARMD\SARDATABANK\qcheck\ado"
glo qcheckpath "C:\Users\\`user'\OneDrive - WBG\qcheck\v2023\qcheck_v02"
discard
adopath ++ "${qcheckpath}"

*---------------------------------------------------------------------
*        1: Data: Household survey
*---------------------------------------------------------------------
local pathout "C:\Users\\`user'\\OneDrive - WBG\qcheck\v2023\qcheck_v02\test1_out"

local countries "XXX"
foreach year in 2016 2018 2020 2023 {
    di "`code'"
	
	use "C:\Users\\`user'\OneDrive - WBG\qcheck\v2023\qcheck_v02\test1_data\XXX_`year'_TEST_V01_M_V01_A_HAR_MOD.dta", clear 

	qui des, varlist
	local Allvars=r(varlist)
		
	*-----------------------------------------------------------
	*## BASIC		
	qcheck `Allvars' [aw=weight], out(`pathout') report(basic) 
	**same results with: qchecksum `Allvars' [aw=weight], out(`pathout')
	
	*-----------------------------------------------------------
	*## CATEG	
	qcheck `Allvars' [aw=weight], out(`pathout') report(categoric) 
	**same results with: qcheckcat `Allvars' [aw=weight], file("`filename'") out(`pathout')

	*-----------------------------------------------------------
	*## STATIC	
	qcheck `Allvars' [aw=weight], file("`filename'") out(`pathout') report(static) input(${qcheckpath}\qcheck_NNN.xlsx) restore
	**same results with: qcheckstatuc `Allvars' [aw=weight], file("`filename'") out(`pathout') report(static) input(${qcheckpath}\qcheck_NNN.xlsx) restore

}
	*/

	


*---------------------------------------------------------------------
*        2: Data: WB Open Data
*---------------------------------------------------------------------
ssc install wbopendata
	wbopendata, indicator(ag.agr.trac.no;si.pov.dday; ny.gdp.pcap.pp.kd) clear long 
	keep if year==2015
	sort year countrycode
	
	local filename= r(filename) 
	di "`filename'"
	qui des, varlist
	local Allvars=r(varlist)
	
	local user "WB473845"
	local user "wb575362"

	glo qcheckpath "P:\SARMD\SARDATABANK\qcheck\ado"
	glo qcheckpath "C:\Users\\`user'\OneDrive - WBG\qcheck\v2023\qcheck_v02"
	discard
	adopath ++ "${qcheckpath}"
	local pathout "C:\Users\\`user'\\OneDrive - WBG\qcheck\v2023\qcheck_v02\test1_out"


	*-----------------------------------------------------------
	*## BASIC		
	qcheck `Allvars' , out(`pathout') report(basic) 
	**same results with: qchecksum `Allvars' [aw=weight], out(`pathout')
	
	*-----------------------------------------------------------
	*## CATEG	
	*qcheck `Allvars' , out(`pathout') report(categoric) 
	qcheck region , out(`pathout') report(categoric) 
	**same results with: qcheckcat `Allvars' [aw=weight], file("`filename'") out(`pathout')

	*-----------------------------------------------------------
	*## STATIC	
	qcheck `Allvars' , file("`filename'") out(`pathout') report(static) input(${qcheckpath}\qcheck_WBOpenData.xlsx) restore
	**same results with: qcheckstatuc `Allvars' [aw=weight], file("`filename'") out(`pathout') report(static) input(${qcheckpath}\qcheck_NNN.xlsx) restore



	
*---------------------------------------------------------------------
*        3: Data: US Census
*---------------------------------------------------------------------
    sysuse census.dta, clear 
	
	local filename= r(filename) 
	di "`filename'"
	qui des, varlist
	local Allvars=r(varlist)
	
	local user "WB473845"
	local user "wb575362"

	glo qcheckpath "P:\SARMD\SARDATABANK\qcheck\ado"
	glo qcheckpath "C:\Users\\`user'\OneDrive - WBG\qcheck\v2023\qcheck_v02"
	discard
	adopath ++ "${qcheckpath}"
    local pathout "C:\Users\\`user'\\OneDrive - WBG\qcheck\v2023\qcheck_v02\test1_out"

	*medage
	*-----------------------------------------------------------
	*## BASIC		
	qcheck medage, out(`pathout') report(basic) 
	*qcheck `Allvars' , out(`pathout') report(basic) 
	**same results with: qchecksum `Allvars' [aw=weight], out(`pathout')
	
	*-----------------------------------------------------------
	*## CATEG	
	*qcheck `Allvars' , out(`pathout') report(categoric) 
	qcheck medage , out(`pathout') report(categoric) 
	**same results with: qcheckcat `Allvars' [aw=weight], file("`filename'") out(`pathout')

	*-----------------------------------------------------------
	*## STATIC	
	qcheck medage , file("`filename'") out(`pathout') report(static) input(${qcheckpath}\qcheck_USCensus.xlsx) restore
	*qcheck `Allvars' , file("`filename'") out(`pathout') report(static) input(${qcheckpath}\qcheck_WBOpenData.xlsx) restore
	**same results with: qcheckstatuc `Allvars' [aw=weight], file("`filename'") out(`pathout') report(static) input(${qcheckpath}\qcheck_NNN.xlsx) restore

	


*---------------------------------------------------------------------
*        4: Data: City Temperature 
*---------------------------------------------------------------------
	sysuse citytemp.dta, clear 
	
	local filename= r(filename) 
	di "`filename'"
	qui des, varlist
	local Allvars=r(varlist)
	
	local filename= r(filename) 
	di "`filename'"
	qui des, varlist
	local Allvars=r(varlist)
	
	local user "WB473845"
	local user "wb575362"

	glo qcheckpath "P:\SARMD\SARDATABANK\qcheck\ado"
	glo qcheckpath "C:\Users\\`user'\OneDrive - WBG\qcheck\v2023\qcheck_v02"
	discard
	adopath ++ "${qcheckpath}"
    local pathout "C:\Users\\`user'\\OneDrive - WBG\qcheck\v2023\qcheck_v02\test1_out"
	
	*medage
	*-----------------------------------------------------------
	*## BASIC		
	qcheck heatdd, out(`pathout') report(basic) 
	*qcheck `Allvars' , out(`pathout') report(basic) 
	**same results with: qchecksum `Allvars' [aw=weight], out(`pathout')
	
	*-----------------------------------------------------------
	*## CATEG	
	*qcheck `Allvars' , out(`pathout') report(categoric) 
	qcheck division , out(`pathout') report(categoric) 
	**same results with: qcheckcat `Allvars' [aw=weight], file("`filename'") out(`pathout')

	*-----------------------------------------------------------
	*## STATIC	
	qcheck heatdd , file("`filename'") out(`pathout') report(static) input(${qcheckpath}\qcheck_CityTemperature.xlsx) restore
	*qcheck `Allvars' , file("`filename'") out(`pathout') report(static) input(${qcheckpath}\qcheck_WBOpenData.xlsx) restore
	**same results with: qcheckstatuc `Allvars' [aw=weight], file("`filename'") out(`pathout') report(static) input(${qcheckpath}\qcheck_NNN.xlsx) restore

	


*---------------------------------------------------------------------
*        5: Data: Votes
*---------------------------------------------------------------------
	sysuse voter.dta, clear 
	
	local filename= r(filename) 
	di "`filename'"
	qui des, varlist
	local Allvars=r(varlist)
	
	local user "WB473845"
	local user "wb575362"

	glo qcheckpath "P:\SARMD\SARDATABANK\qcheck\ado"
	glo qcheckpath "C:\Users\\`user'\OneDrive - WBG\qcheck\v2023\qcheck_v02"
	discard
	adopath ++ "${qcheckpath}"
    local pathout "C:\Users\\`user'\\OneDrive - WBG\qcheck\v2023\qcheck_v02\test1_out"
	
	
	*medage
	*-----------------------------------------------------------
	*## BASIC		
	qcheck pop, out(`pathout') report(basic) 
	*qcheck `Allvars' , out(`pathout') report(basic) 
	**same results with: qchecksum `Allvars' [aw=weight], out(`pathout')
	
	*-----------------------------------------------------------
	*## CATEG	
	*qcheck `Allvars' , out(`pathout') report(categoric) 
	qcheck candidat , out(`pathout') report(categoric) 
	**same results with: qcheckcat `Allvars' [aw=weight], file("`filename'") out(`pathout')

	*-----------------------------------------------------------
	*## STATIC	
	qcheck pop , file("`filename'") out(`pathout') report(static) input(${qcheckpath}\qcheck_CityVoter.xlsx) restore
	*qcheck `Allvars' , file("`filename'") out(`pathout') report(static) input(${qcheckpath}\qcheck_WBOpenData.xlsx) restore
	**same results with: qcheckstatuc `Allvars' [aw=weight], file("`filename'") out(`pathout') report(static) input(${qcheckpath}\qcheck_NNN.xlsx) restore

	
	
	
	*-----------------------------------------------------------
	*## BASIC		
	*summarizeout `Allvars' [aw=weight], file("`filename'") out(P:\SARMD\SARDATABANK\qcheck\Output\summarizeout)
	*qcheck urban [aw=weight], file("`filename'") out(P:\SARMD\SARDATABANK\qcheck\Output\output_basic) report(basic) 
	
	*-----------------------------------------------------------
	*## CATEG	
	*summarizeout_cat `Allvars' [aw=weight], file("`filename'") out(P:\SARMD\SARDATABANK\qcheck\Output\summarizeout_cat)
	preserve 
	qcheck urban [aw=weight], file("`filename'") out(P:\SARMD\SARDATABANK\qcheck\Output\output_categoric) report(categoric) 
	restore 
	
	*-----------------------------------------------------------
	*## STATIC	
	*qcheck urban [aw=weight], file("`filename'") out(P:\SARMD\SARDATABANK\qcheck\Output\output_static) report(static) input(P:\SARMD\SARDATABANK\qcheck\qcheck_NNN.xlsx)


exit
*<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>*
