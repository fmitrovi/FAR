* Encoding: UTF-8.
* Further analysis table for Pacific MICS Surveys. 

include "surveyname.sps".

* Merging needed variables from hl dataset to be analysed with child labour variable.
get file = "hl.sav".
sort cases by hh1 hh2 hl1.
save outfile = "tmpHL.sav"/keep hh1 hh2 hl1 hl4 hl6 hl12 hl13 hl14 hl16 hl17 hl18 /rename hl1 = fs3.

get file = "fs.sav".

sort cases hh1 hh2 fs3.

get file = 'fs.sav'.

sort cases by HH1 HH2 fs3.
match files
  /file = *
  /table = "tmpHL.sav"
  /by HH1 HH2 fs3  .

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

/* this is the beggining of recoding of table SR.11.1 in a background variables for child labour table
/***************************************************************************************************************************************************************************************************************/.

compute livingArrangements =0.
if (HL14 > 0 and HL18 > 0) livingArrangements = 10.
if ((HL12 = 2 or HL13 = 2) and (HL16 = 2 or HL17 = 2)) livingArrangements = 20.
if (HL14 > 0 and (HL16 = 2 or HL17 = 2)) livingArrangements = 30.
if ((HL12 = 2 or HL13 = 2) and HL18 > 0)  livingArrangements = 40.
if  (HL12 >= 8 or HL13 >= 8 or HL16 >= 8 or HL17 >= 8) livingArrangements = 99.
value labels livingArrangements  
     10 "Living with both parents"  
     20 "Living with neither parent"
     30 "Living with mother only (father dead or not in the HH)"
     40 "Living with father only (mother dead or not in the HH)"
     99 "Missing information/ not interviewed".
   
  
compute livingArrangements2 =0.
if ((HL12 = 2 or HL13 = 2) and (HL16 = 2 or HL17 = 2)) and (HL12 = 2  and HL16 = 1) livingArrangements2 = 21.    
if ((HL12 = 2 or HL13 = 2) and (HL16 = 2 or HL17 = 2)) and (HL12 = 1 and HL16 = 2)  livingArrangements2 = 22. 
if ((HL12 = 2 or HL13 = 2) and (HL16 = 2 or HL17 = 2)) and (HL12 = 1 and HL16 = 2)  livingArrangements2 = 23.
if ((HL12 = 2 or HL13 = 2) and (HL16 = 2 or HL17 = 2)) and (HL12 = 2  and HL16 = 2)  livingArrangements2 = 24.
variable labels livingArrangements2 "Living with neither parent".
value labels livingArrangements2 
     21 "   Only father alive"  
     22 "   Only mother alive"
     23 "   Both alive"
     24 "   Both dead".


compute livingArrangements3 =0.
if (HL14 > 0 and (HL16 = 2 or HL17 = 2)) and  (HL16 = 1)  livingArrangements3 = 31.
if (HL14 > 0 and (HL16 = 2 or HL17 = 2)) and  (HL16 = 2)  livingArrangements3 = 32.
variable labels livingArrangements3 "Living with mother only (father dead or not in the HH)".
value labels livingArrangements3 
       31 "   Father alive "  
       32 "   Father dead ".


compute livingArrangements4 =0.
if ((HL12 = 2 or HL13 = 2) and HL18 > 0)  and  (HL12 = 1)  livingArrangements4 = 41.
if ((HL12 = 2 or HL13 = 2) and HL18 > 0)  and  (HL12 = 2)   livingArrangements4 = 42.
variable labels livingArrangements4 "Living with mother only (father dead or not in the HH)".
value labels livingArrangements4 
       41 "   Mother alive "  
       42 "   Mother dead ".

mrsets
  /mcgroup name = $livingArrangements
           label = "Child's living arrangements"
           variables = livingArrangements livingArrangements2 livingArrangements3 livingArrangements4.


*Children who are not living with at least one biological parent, either because the parents live elsewhere or because the parents are dead:
*(HL12=2 or HL13=2) and (HL16=2 or HL17=2).
compute notWithParent = 2 .
if ((HL12 = 2 or HL13 = 2) and (HL16 = 2 or HL17 = 2)) notWithParent = 1.

*Not living with biological mother.
compute notWithMother= 2 .
if (HL12 <> 1 or HL13 <> 1) notWithMother = 1.
 
compute anyParentDead = 2 .
if (HL12 = 2 or HL16 = 2) anyParentDead = 1.

variable labels
notWithMother       "Not living with biological mother"
  /notWithParent "Living with neither biological parent"
  /anyParentDead "One or both parents dead" .
value labels 
    notWithParent   1  "Living with neither biological parent"   2  "Living with one or both biological parents"
    /notWithMother  1  "Not living with biological mother"       2  "Living with biological mother"
    /anyParentDead 1  "One or both parents dead"                2  "Both parents alive".


/* this is the end of recoding of table SR.11.1 in a background variables
/***************************************************************************************************************************************************************************************************************/.

* Ctables command in English.
ctables
  /vlabels variables = numChildren layerEA layerHHC
           display = none
  /table   total [c ]
         + $livingArrangements [c]
        + notWithMother [c]
        + notWithParent [c]
        + anyParentDead [c]
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
     "FA.Table CP.1.5: Child labour - Linkages with Child's living Arrangements"
      "Percentage of children age 5-17 years by involvement in economic activities or household chores during the last week and percentage engaged in child labour during the previous week, by child's living arrangements, " + surveyname
   caption=
     "[1] MICS indicator PR.3 - Child labour; SDG indicator 8.7.1"
     "[A] The definition of child labour used for SDG reporting does not include hazardous working conditions. This is a change over previously defined MICS6 indicator."						
     "[B] Includes attendance to early childhood education"	
     "[C] The disaggregate of Mother's education is not available for children age 15-17 years identified as emancipated."
     "[D] The disaggregate of Mother's functional difficulties is shown only for respondents to the Adult Functioning module, i.e. individually interviewed women age 18-49 years and men age 18-49 years in selected households."
     "na: not applicable"	
  .			


new file.
erase file = "tmpHL.sav".
