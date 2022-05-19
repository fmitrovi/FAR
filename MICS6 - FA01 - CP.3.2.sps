* Encoding: UTF-8.
* Further analysis table for Pacific MICS Surveys. 

include "surveyname.sps".
* open women data file.
get files="wm.sav".

include "CommonVarsWM.sps".

* select completed questionnaires, and women selected for domestic violence.
select if (WM17 = 1 and sysmis (DVD1)=0 and DVD1 = 1).

* select women who have ever been married.
select if (mstatus = 1 or mstatus = 2).

weight by dvweight.

* create total row.
compute total = 1.
variable labels total "Total".
value labels total 1" ".

********************DHS.
 * PROGRAMMING Table DV10: 
Denominator 
All ever-married women for all columns.

 * Numerator 
Column 1: Emotional violence: A YES on at least one of items DV04A (a-c)
Column 2 Physical violence: A YES on at least one of items DV05A (a-g)
Column 3: Sexual violence: A YES on at least one of items DV05A (h-j)
Column 4: Physical and sexual violence: A YES on at least one of items DV05A (a-g) AND at least one item DV05A (h-j)
Column 5: Physical and sexual and emotional violence: A YES on at least one of items DV05A (a-g) AND at least one item DV05A (h-j) AND at least one item DV04A (a-c)
Column 6: Physical and/or sexual violence: A YES on at least one of items DV05A(a-j)
Column 7: Physical or sexual or emotional violence: A YES on at least one of items DV05A (a-j) OR DV04A (a-c)


********************MICS.
*
PROGRAMMING Table DV10: 
Denominator 
All ever-married women for all columns.

 * Numerator 
Column 1: Emotional violence: A YES on at least one of items DVD4A (a-c)
Column 2 Physical violence: A YES on at least one of items DVD5 (a-g)
Column 3: Sexual violence: A YES on at least one of items DVD5 (h-j)
Column 4: Physical and sexual violence: A YES on at least one of items DVD5 (a-g) AND at least one item DVD5 (h-j)
Column 5: Physical and sexual and emotional violence: A YES on at least one of items DVD5 (a-g) AND at least one item DVD5 (h-j) AND at least one item DVD4A (a-c)
Column 6: Physical and/or sexual violence: A YES on at least one of items DVD5(a-j)
Column 7: Physical or sexual or emotional violence: A YES on at least one of items DVD5 (a-j) OR DVD4A (a-c).

compute emotional = 0.
if (DVD4A = 1 or DVD4B = 1 or DVD4C = 1) emotional = 100.
variable labels emotional "Emotional violence".

compute physical = 0.
if (DVD5A = 1 or DVD5B = 1 or DVD5C = 1 or DVD5D = 1 or DVD5E = 1 or DVD5F = 1 or DVD5G = 1) physical = 100.
variable labels physical "Physical violence".

compute sexual = 0.
if (DVD5H = 1 or DVD5I = 1 or DVD5J = 1) sexual = 100.
variable labels sexual "Sexual violence".

compute PysAndSex =0.
if (physical = 100 and sexual = 100) PysAndSex = 100.
variable lables PysAndSex "Physical and sexual".

compute PysAndSexAndEm =0.
if (physical = 100 and sexual = 100 and emotional = 100) PysAndSexAndEm = 100.
variable labels PysAndSexAndEm "Physical and sexual and emotional".

compute PysOrSex =0.
if (physical = 100 or sexual = 100) PysOrSex = 100.
variable lables PysOrSex "Physical or sexual".

compute PysOrSexOrEm =0.
if (physical = 100 or sexual = 100 or emotional = 100) PysOrSexOrEm = 100.
variable labels PysOrSexOrEm "Physical or sexual or emotional".

compute nwm = 1.
value labels nwm 1 "Number of ever-married women".
variable labels nwm "".

variable labels mstatus "Marital status".
value labels mstatus 1"Married or living together" 2"Divorced/separated/widowed".

variable labels DVD13 "Women afraid of husband/partner".


/* this is the beggining of recoding of table PR.8.1W in a background variables for domestic violence table
/***************************************************************************************************************************************************************************************************************/.
compute goesOut = 8.
if (DV1A = 1) goesOut = 1.
if (DV1A = 2) goesOut = 2.
variable labels goesOut "If she goes out without telling him".

compute neglectsKids = 8.
if (DV1B = 1) neglectsKids = 1.
if (DV1B = 2) neglectsKids = 2.
variable labels neglectsKids "If she neglects the children".

compute sheArgues = 8.
if (DV1C = 1) sheArgues = 1.
if (DV1C = 2) sheArgues = 2.
variable labels sheArgues "If she argues with him".

compute refusesSex = 8.
if (DV1D = 1) refusesSex = 1.
if (DV1D = 2) refusesSex = 2.
variable labels refusesSex "If she refuses sex with him".

compute burnsFood = 8.
if (DV1E = 1) burnsFood = 1.
if (DV1E = 2) burnsFood = 2.
variable labels burnsFood "If she burns the food".
exe.
compute comesLate = 8.
if (DV1F = 1) comesLate = 1.
if (DV1F = 2) comesLate = 2.
variable labels comesLate "Comes home late".

compute anyReason = 2.
if (any(1, DV1A, DV1B, DV1C, DV1D, DV1E)) anyReason = 1.
variable labels anyReason "For any of these five reasons [1]".

value labels goesOut neglectsKids sheArgues refusesSex burnsFood comesLate anyReason 
    1 "Beating is justified"
    2 "Beating is not justified"
    8 "DK/Missing".
/* this is the end of recoding of table PR.8.1W in a background variables
/***************************************************************************************************************************************************************************************************************/.

ctables
  /vlabels variables = total nwm  
           display = none
  /table  total [c]
  + goesOut [c]
          + neglectsKids [c]
          + sheArgues [c]
          + refusesSex [c]          
          + burnsFood [c]
          + comesLate [c]
          + anyReason [c]
  by
        emotional [s] [mean,'',f5.1] + physical [s] [mean,'',f5.1] + sexual [s][mean,'',f5.1] + PysAndSex [s][mean,'',f5.1] + PysAndSexAndEm [s][mean,'',f5.1] + PysOrSex [s][mean,'',f5.1] + PysOrSexOrEm [s][mean,'',f5.1] +
         nwm [c] [count,'',f5.0]
  /categories var=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title=
                  "FA TableCP.3.1: Spousal violence -  Linkage with Attitudes Towards Wife Beating"			
                  "Percentage of ever-married women age 15-49 who have ever experienced emotional, physical, or sexual violence committed by their current or most recent husband/partner, by attitides toward wife beating, " + surveyname 			
.										
									
new file.


