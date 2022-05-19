* Encoding: UTF-8.
* Further analysis table for Pacific MICS Surveys. 

include "surveyname.sps".

get file = 'fs.sav'.

include "CommonVarsFS.sps".
select if (FS17 = 1 and FL28 = 1 and CB3<15).

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
  /numChildren 1 "Number of children age 7-14 years" /* changed to 14 from 17 years as only children who were given the FL module were counted
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

/***************************************************************************************************************************************************************************************************************/
/* Syntax in this section is based on Table PR.3.3 with  background variables recoded from Tables LN.4.1 and LN 4.2 as per request from CP section of MCO in Fiji. Syntax customised based on LN.4.1 andLN4.2 in KSDIS syntax. 
compute target1 = 0.
if (FL20A < 99 and FL20B < 99) target1 = FL20A - FL20B.
* Second story.


* Replace 72 and 61 below with total number of words in two stories in your survey.
compute readCorrect = 0.
if (target1 >= 0.9 * 78)  readCorrect = 100. /* this has to be adjusted for every specific survey
variable labels readCorrect " ".

compute aLiteral = 0.
if readCorrect = 100 and (FL22A=1 and FL22B=1 and FL22C=1) aLiteral = 100.
variable labels aLiteral " ".

compute aInferential = 0.
if readCorrect = 100 and (FL22D=1 and FL22E=1) aInferential = 100.
variable labels aInferential " ".

compute readingSkill = 9.
if (readCorrect = 100 and aLiteral = 100 and aInferential = 100) readingSkill = 1.
if (readCorrect <> 100 or aLiteral <> 100 or aInferential <> 100) readingSkill = 2.
variable labels readingSkill "Foundational reading skills" .
value labels readingSkill 
1 "Children who demonstrate foundational reading skills"
2 "Children who do not demonstrate foundational reading skills"
9 "Missing data for foundational reading skills". 

count numberReadTarget = FL23A FL23B FL23C FL23D FL23E FL23F (1).
compute numberRead = 0.
if (numberReadTarget = 6) numberRead = 100.
variable labels numberRead "Percentage of children who successfully completed tasks of: Number reading".

compute numberDiscr  = 0.
if (FL24A = "7" and FL24B = "24" and FL24C = "58" and FL24D = "67" and FL24E = "154" ) numberDiscr = 100.
*if (FL24A = 1 and FL24B = 1 and FL24C = 1  and FL24D = 1 and FL24E = 1) numberDiscr = 100.
variable labels numberDiscr "Percentage of children who successfully completed tasks of: Number discrimination".

compute numberAdd  = 0.
if (FL25A = "5" and FL25B = "14" and FL25C = "10" and FL25D = "19" and FL25E = "36") numberAdd = 100.
*if (FL25A = 1 and FL25B = 1 and FL25C = 1 and FL25D = 1 and FL25E =1) numberAdd = 100.
variable labels numberAdd "Percentage of children who successfully completed tasks of: Addition".

compute numberPattern = 0.
if (FL27A = "8" and FL27B = "16" and FL27C = "30" and FL27D = "8" and FL27E = "14") numberPattern = 100.
*if (FL27A = 1 and FL27B = 1 and FL27C = 1  and FL27D = 1 and FL27E = 1) numberPattern = 100.
variable labels numberPattern "Pattern recognition and completion".

compute numSkill = 9.
if (numberRead = 100 and numberDiscr = 100 and numberAdd = 100 and numberPattern = 100) numSkill = 1.
if (numberRead <> 100 or numberDiscr <> 100 or numberAdd <> 100 or numberPattern <> 100) numSkill = 2.
variable labels numSkill "Foundational numeracy skills".
value labels numSkill 
1 "Children who demonstrate foundational numeracy skills"
2 "Children who do not demonstrate numeracy reading skills"
9 "Missing data for numeracy reading skills". 


/* this is the end of recoding of tables.LN.4.1 and LN.4.2 in  background variables
/***************************************************************************************************************************************************************************************************************/.
* Ctables command in English.
ctables
  /vlabels variables = numChildren layerEA layerHHC
           display = none
  /table   total [c]
         + hl4 [c] 
         + hh6 [c]
         + hh7 [c]
         + schoolAttendance [c] /* This is the added variable for FA
         + readingSkill [c] /* This is the added variable for FA
         + numSkill [c]  /* This is the added variable for FA
         + ageGroup [c]
         + melevel [c]
         + fsdisability [c]
         + caretakerdis [c]
         + religion [c]
         + windex5 [c]
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
     "FA Table CP.1.1: Child labour - Foundational Learning  Skills Linkages"
      "Percentage of children age 7-14 years by involvement in economic activities or household chores during the last week and percentage engaged in child labour during the previous week"
       "by school attendance, literacy and numeracy skills" + surveyname
   caption=
     "[1] MICS indicator PR.3 - Child labour; SDG indicator 8.7.1 - for children 7-14 years"
     "[A] The definition of child labour used for SDG reporting does not include hazardous working conditions. This is a change over previously defined MICS6 indicator."						
     "[B] Includes attendance to early childhood education"	
     "[C] The disaggregate of Mother's education is not available for children age 15-17 years identified as emancipated."
     "[D] The disaggregate of Mother's functional difficulties is shown only for respondents to the Adult Functioning module, i.e. individually interviewed women age 18-49 years and men age 18-49 years in selected households."
     "na: not applicable"	
  .			


new file.
