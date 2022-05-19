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

 * recode CB3 (5 thru 11 = 1) (12 thru 14 = 2) (15 thru 17 = 3) into ageGroup .
 * variable labels ageGroup "Age" .
 * value labels ageGroup
1 "5-11"
2 "12-14"  
3 "15-17".
 * formats ageGroup (f1.0).

compute total = 1.
variable labels total "Total".
value labels total 1 " ".

variable labels schoolAttendance "School attendance".
value labels schoolAttendance 1 "Attending [B]" 2 "Not attending" 8 "Missing".
variable labels fsdisability "Child's functional difficulties".
variable labels melevel "Mother�s education [C]".
variable labels caretakerdis "Mother's functional difficulties [D]".


/* this is the beggining of recoding of table PR.2.1 in a background variables
/***************************************************************************************************************************************************************************************************************/.

compute anyViolent = 9 .
if (any(1, FCD2C, FCD2D, FCD2F, FCD2G, FCD2H, FCD2I, FCD2J, FCD2K)) anyViolent = 1 .
if (not(any(1, FCD2C, FCD2D, FCD2F, FCD2G, FCD2H, FCD2I, FCD2J, FCD2K))) anyViolent = 2 .
variable labels anyViolent "Any violent discipline method".
value labels anyViolent 1 "Children experiencing any violent discipline method" 2 "Children not experiencing any violent discipline method" 9 "Missing".

compute anyViolent1 = 0 .
if (any(1, FCD2C, FCD2D, FCD2F, FCD2G, FCD2H, FCD2I, FCD2J, FCD2K)) anyViolent1 = 100 .

compute nonViolent = 9.
if (any(1, FCD2A, FCD2B, FCD2E) and anyViolent1=0)  nonViolent = 1 .
if (not(any(1, FCD2A, FCD2B, FCD2E) and anyViolent1=0))  nonViolent = 2 .
variable labels nonViolent "Non violent discipline method".
value labels nonViolent 1 "Children experiencing only non violent discipline method" 2 "Children not experiencing non violent discipline method" 9 "Missing".

compute anyPhysical = 9.
if (any(1, fCD2C, fCD2F, fCD2G, fCD2I, fCD2J, fCD2K))   anyPhysical = 1 .
if (not(any(1, fCD2C, fCD2F, fCD2G, fCD2I, fCD2J, fCD2K)))  anyPhysical = 2 .
variable labels anyPhysical "Any physical discipline method".
value labels anyPhysical 1 "Children experiencing any physical discipline method" 2 "Children not experiencing any physical discipline method" 9 "Missing".

compute severePhysical = 9.
if (any(1, FCD2I, FCD2K))   severePhysical = 1 .
if (not(any(1, FCD2I, FCD2K)))  severePhysical = 2 .
variable labels severePhysical "Severe physical discipline method".
value labels severePhysical 1 "Children experiencing severe physical discipline method" 2 "Children not experiencing severe physical discipline method" 9 "Missing".


compute anyPsychological = 9.
if (any(1, FCD2D, FCD2H))  anyPsychological = 1 .
if (not(any(1, FCD2D, FCD2H)))  anyPsychological = 2 .
variable labels anyPsychological "Psychological aggression discipline method".
value labels anyPsychological 1 "Children experiencing psychological aggression discipline method" 2 "Children not experiencing psychological aggression discipline method" 9 "Missing".
/* this is the end of recoding of table PR.2.1 in a background variables
/***************************************************************************************************************************************************************************************************************/.

* Ctables command in English.
ctables
  /vlabels variables = numChildren layerEA layerHHC
           display = none
  /table   total [c ]
         + anyViolent [c] /* all these are the added variables for FA
         + nonViolent [c]
         + anyPhysical [c]
         + severePhysical [c]             
         + anyPsychological [c]
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
     "FA Table CP.1.3: Child labour - Linkages with Violent Discipline"
      "Percentage of children age 5-17 years by involvement in economic activities or household chores during the last week and percentage engaged in child labour during the previous week, by disciplinary method, " + surveyname
   caption=
     "[1] MICS indicator PR.3 - Child labour; SDG indicator 8.7.1"
     "[A] The definition of child labour used for SDG reporting does not include hazardous working conditions. This is a change over previously defined MICS6 indicator."						
  .			

new file.
