***************************************Basic Analysis Program*****************************************************

qui {
*set trace on
cap findit svmat2dm79 from http://www.stata.com/stb/stb56
if _rc!=0 noi di "Please install dm79 from http://www.stata.com/stb/stb56"

cap program drop qcheckcat iqr
program define qcheckcat, rclass

*gettoken cmd 0 : 0

syntax anything                                    ///
          [if] [in]                                ///
          [aweight fweight pweight],               ///
          [                                        ///
                          file(string)             ///
                          out(string)              ///
          ] 
          
          foreach v of local anything {
          capture unab V : `v'
          if _rc == 0 local varlist `varlist' `V'
          else        local badlist `badlist' `v'
          }

          di

          if "`varlist'" != "" {
          local n : word count `varlist'
          local what = plural(`n', "variable")
          di as txt "{p}`what': `varlist'{p_end}"
          return local varlist "`varlist'"
          }
          if "`badlist'" != "" {
          local n : word count `badlist'
          local what = plural(`n', "not variable")
          di as err "{p}`what': `badlist'{p_end}"
          return local badlist "`badlist'"
            foreach z of local badlist {
                          gen `z'="Not originally in this database"
            }
          }
          
                local all_syntaxvars "`varlist' `badlist'"
                di as txt "qcheck categoric analysis will run for the following variables: `all_syntaxvars'"
          
          
                if ("`file'"=="") local file="`c(filename)'"
                if ("`out'"=="") local out="basic_check.dta"          

                * Weights treatment
                loc weight "[`weight' `exp']"
                cap postutil clear
                postfile postqcheckcat str50 file str30 var str30 description str30 analysis str30 case double value using `out' , replace
                
          local year=year 
          tempname P F A V Y B
          cap mat drop `P'
          
                    local vc = 0 
                    foreach varctg of local all_syntaxvars {

                    tempvar missvar
                    missings tag `varctg', gen(`missvar')
                    count
                    local n = r(N)
                    count if `missvar'
                    local mn = r(N)
                    local diffm = `mn'-`n'
          
                    if (`diffm' == 0) {
                                    cap confirm numeric variable `varctg'
                                    if (_rc == 0) replace `varctg'=-999
                                    else  replace `varctg'="NA"
                    }  
          
                    // generate auxiliary variable with proper labels
                    tempvar varctgaux
                    cap confirm numeric variable `varctg'
                    if _rc != 0 {
                                    rename  `varctg' `varctgaux' 
                                    encode `varctgaux', generate(`varctg') label(`varctg')
                    }
                    else {
                    local la: value label `varctg'
                    if ("`la'" != "") {
                                    cap labelrename `la' `varctg' 
                    }
                    }
          
                    // calculation of shares and extraction of labels in matrices
                    local ++vc
                    tab `varctg' `weight' , matcell(`F') matrow(`V')
                    mata: A = st_matrix("`F'")
                    mata: st_matrix("`F'", (A:/colsum(A))*100)
  
                    local nr = rowsof(`F')
                    mat `Y' = J(`nr', 1, `year')
                    mat `B' = J(`nr', 1, `vc')
					
					local rows 
					local this = strtoname("`: variable label `varctg''") 
					local rows `rows' `this'
					mat L=J(`nr',1,.)
					mat rownames L = `rows'
					mac li 
					mat li L
				
                    mat `A' = `Y', `V', `F', `B'  
					mat rownames `A' = `rows'
					mac li 
					mat li `A'
					
                    // matrix with year, categories value, proportion shares and var test
                    mat `P' = nullmat(`P')\ `A'
                    *}
                    } // End of local vars 
                          
                          // end loop categorical variable
                          mat colnames `P' = year valuelab freq varname
                          drop _all
                          *svmat `P', n(col)
						  svmat2 `P', n(col) rnames(label_var)
          
                          tostring varname valuelab, replace force
                          label var freq "Participation share (%)"
                          
                          local vc = 0
                          foreach varctg of local all_syntaxvars {
                    local ++vc
                    replace varname = "`varctg'" if varname == "`vc'"
                    levelsof valuelab if varname == "`varctg'", local(values)
                    di `valuelab'
                          
                    * asign value labels
                    foreach value of local values {
                                    replace valuelab = "`: label `varctg' `value''" ///
                              if  valuelab == "`value'"                      ///
                              & varname == "`varctg'"
                    }
                          }              
          

                
          save "`out'", replace
          
                postclose postqcheckcat
                
end
noi di "results were saved at `out'"
} // end of qui

