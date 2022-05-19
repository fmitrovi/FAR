* Encoding: UTF-8.
* Further analysis table for Pacific MICS Surveys. 

include "surveyname.sps".

get file = 'fs.sav'.

include "CommonVarsFS.sps".

select if (FS17 = 1).

weight by fsweight.

* definitions of econcomic activity variables  (ea1more, ea14less, ea14more, ea43less, ea43more) .
include 'define\MICS6 - 09 - PR.sps' .

variable labels
   eaLess "Below the age specific threshold"
  /eaMore "At or above the age specific threshold"
  /hhcLess "Below the age specific threshold"
  /hhcMore "At or above the age specific threshold"
  /childLabor "Total child labour [1] [A]" .

compute layerEA = 1 .
compute layerHHC = 1 .
compute numChildren = 1 .

value labels
   layerEA   1 "Children involved in economic activities for a total number of hours during last week:"
  /layerHHC  1 "Children involved in household chores for a total number of hours during last week:"
  /numChildren 1 "Number of children age 5-17 years"
  .

recode CB3 (5 thru 11 = 1) (12 thru 14 = 2) (15 thru 17 = 3) into ageGroup .
variable labels ageGroup "Age" .
value labels ageGroup
1 "5-11"
2 "12-14"  
3 "15-17".
formats ageGroup (f1.0).

compute total = 1.
variable labels total "Total".
value labels total 1 " ".

variable labels schoolAttendance "School attendance".
value labels schoolAttendance 1 "Attending [B]" 2 "Not attending" .
variable labels fsdisability "Child's functional difficulties".
variable labels melevel "Mother’s education [C]".
variable labels caretakerdis "Mother's functional difficulties [D]".



/* this is the end of recoding of table PR.3.4 in a background variables
/***************************************************************************************************************************************************************************************************************/.
compute carry =9.
if (CL4=1) carry=1.
if (cl4=2) carry=2.
variable labels carry "Carrying heavy loads".
value labels carry 1 "Children carrying heavy loads" 2 "Children not carrying heavy loads" 9 "DK/Missing/no response". 

compute tools =9.
if (CL5=1) tools=1.
if (cl5=2) tools=2.
variable labels tools "Working with dangerous tools or operating heavy machinery".
value labels tools 1 "Children working with dangerous tools or operating heavy machinery" 2 "Children not working with dangerous tools or operating heavy machinery"  9"DK/Missing/no response". 

compute dust =9.
if (CL6A=1) dust=1.
if (cl6A=2) dust=2.
variable labels dust "Exposed to dust, fumes or gas".
value labels dust 1 "Children exposed to dust, fumes or gas" 2 "Children not exposed to dust, fumes or gas"  9"DK/Missing/no response". 

compute weather =9.
if (CL6B=1) weather=1.
if (CL6B=2) weather=2.
variable labels weather "Exposed to extreme cold, heat or humidity".
value labels weather 1 "Children exposed to extreme cold, heat or humidity" 2 "Children not exposed to extreme cold, heat or humidity" 9 "DK/Missing/no response". 

compute noise =9.
if (CL6C=1) noise=1.
if (CL6C=2) noise=2.
variable labels noise "Exposed to loud noise or vibration".
value labels noise 1 "Children exposed to loud noise or vibration" 2 "Children not exposed to loud noise or vibration"  9 "DK/Missing/no response". 

compute heights =9.
if (CL6D=1) heights=1.
if (CL6D=2) heights=2.
variable labels heights "Working at heights".
value labels heights 1 "Children working at heights" 2 "Children not working at heights" 9"DK/Missing/no response". 

compute chemicals =9.
if (CL6E=1) chemicals=1.
if (CL6E=2) chemicals=2.
variable labels chemicals "Working with chemicals or explosives".
value labels chemicals 1 "Children working with chemicals or explosives" 2 "Children not working with chemicals or explosives" 9 "DK/Missing/no response". 

compute other =9.
if (CL6X=1) other=1.
if (CL6X=2) other=2.
variable labels other "Exposed to other unsafe or unhealthy things, processes or conditions".
value labels other 1 "Children exposed to other unsafe or unhealthy things, processes or conditions" 2 "Children not exposed to other unsafe or unhealthy things, processes or conditions" 9"DK/Missing/no response". 

compute hazardConditions = 9 .
if (any(1, CL4, CL5, CL6A, CL6B, CL6C, CL6D, CL6E, CL6X)) hazardConditions = 1 .
if not (any(1, CL4, CL5, CL6A, CL6B, CL6C, CL6D, CL6E, CL6X)) hazardConditions =2 .
variable labels hazardConditions "Hazardous work".
value labels hazardConditions 1 "Children exposed to any hazardous work" 2 "Children not exposed to any hazardous work" 9 "DK/Missing/no response". 

* Ctables command in English.
ctables
  /vlabels variables = numChildren layerEA layerHHC
           display = none
  /table   total [c]
         + hazardConditions [c]
         + carry [c] /* all these are the added variables for FA
         + tools [c]
         + dust [c]
         + weather [c]
         + noise [c]
         + heights [c]
         + chemicals [c]
         + other [c] 
   by
           layerEA [c] > (
             ealess[s] [mean '' f5.1]
           + eaMore[s] [mean '' f5.1] )
         + layerHHC [c] > (
             hhcLess[s] [mean '' f5.1]
           + hhcMore[s] [mean '' f5.1] )
         + childLabor [s] [mean '' f5.1]
         + numChildren [c] [count '' f5.0]
  /categories variables=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title=
     "FA Table CP.1.2: Child labour - Hazardous Labour Linkages"
      "Percentage of children age 5-17 years by involvement in economic activities or household chores during the last week and percentage engaged in child labour during the previous week, by hazardous labour activities, " + surveyname
   caption=
     "[1] MICS indicator PR.3 - Child labour; SDG indicator 8.7.1"
  .			

new file.
