* Encoding: UTF-8.
* Further analysis table for Pacific MICS Surveys. 


include "surveyname.sps".

get file = 'wm.sav'.

include "CommonVarsWM.sps".

select if (WM17 = 1 and DVD1=1).

weight by wmweight.

compute numWomen15_49 = 1.
compute before15 = 0.
if (WAGEM < 15) before15 = 100.

do if (WB4 >= 20).
+ compute numWomen20_49 = 1.
+ compute before152049 = 0.
+ if (WAGEM < 15) before152049 = 100.
+ compute before18 = 0.
+ if (WAGEM < 18) before18 = 100.
end if.

do if (WB4 >= 20 and WB4 <= 24).
+ compute numWomen20_24 = 1.
+ compute before15_1 = 0.
+ if (WAGEM < 15) before15_1 = 100.
+ compute before18_1 = 0.
+ if (WAGEM < 18) before18_1 = 100.
end if.

do if (WB4 < 20).
+ compute numWomen15_19 = 1.
+ compute currentlyMarried = 0.
+ if any(MA1, 1, 2) currentlyMarried = 100 .
end if.

 * do if (any(MA1, 1, 2)) .
 * + compute numMarried = 1 .
 * + compute inPolygynous = 0.
 * + if (MA3=1) inPolygynous = 100 .
 * end if.

compute layer15_49 = 1 .
compute layer20_49 = 1 . 
compute layer20_24 = 1 . 
compute layer15_19 = 1 .
value labels 
   layer15_49 1 "Women age 15-49 years"
  /layer20_49 1 "Women age 20-49 years" 
  /layer20_24 1 "Women age 20-24 years" 
  /layer15_19 1 "Women age 15-19 years"
  /numWomen15_49 1 "Number of women age 15-49 years" 
  /numWomen20_49 1 "Number of women age 20-49 years"
  /numWomen20_24 1 "Number of women age 20-24 years"
  /numWomen15_19 1 "Women age 15-19 years" .
 *   /numMarried 1 "Number of women age 15-49 years currently married/in union".
  
variable labels 
    before15    "Percentage married before age 15"
   /before152049    "Percentage married before age 15"
   /before15_1  "Percentage married before age 15 [1]" 
   /before18    "Percentage married before age 18"
   /before18_1    "Percentage married before age 18 [2]"
   /currentlyMarried "Percentage currently married/in union [3]".
 *    /inPolygynous "Percentage in polygynous marriage/in union [4]" .

compute total = 1.
variable labels total "Total".
value labels total 1 " ".


/* this is the beggining of recoding of table DVD.1.9 in a background variables for domestic violence table
/***************************************************************************************************************************************************************************************************************/. 
compute sexviol = 2.
if ((DVD5H = 1 or DVD5I = 1 or DVD5J = 1) or DVD15B = 1 or DVD22A = 1 or DVD22B = 1) sexviol = 1.
variable labels sexviol "Experience of sexual violence".
value labels sexviol 1 "Ever experienced sexual violence" 2 "Never experienced sexual violence" .

compute sexviol12 = 2.
if ((DVD5H1 <= 2 or DVD5I1 <= 2 or DVD5J1 <= 2) or DVD15B1 = 1 or DVD24 = 1) sexviol12 = 1.
variable labels sexviol12 "Experience of sexual violence in last 12 months".
value labels sexviol12 1 "Experienced sexual violence in last 12 months" 2 "Did not experience sexual violence in last 12 months".

compute violence15 = 2.
if ((DVD5A = 1 or DVD5B = 1 or DVD5C = 1 or DVD5D = 1 or DVD5E = 1 or DVD5F = 1 or DVD5G = 1) or DVD15A = 1 or DVD16 = 1 or DVD20 = 1) violence15 = 1.
variable labels violence15 "Percentage who have experienced physical violence since age 15".
value labels violence15 1 "Ever experienced physical violence" 2 "Never experienced physical violence" .

compute v12Often = 20.
if ((DVD5A1 = 1 or DVD5B1 = 1 or DVD5C1 = 1 or DVD5D1 = 1 or DVD5E1 = 1 or DVD5F1 = 1 or DVD5G1 = 1) or DVD18 = 1) v12Often = 11.
variable labels v12Often "Often".

compute v12Smt = 20.
if (((DVD5A1 <> 1 and DVD5B1 <> 1 and DVD5C1 <> 1 and DVD5D1 <> 1 and DVD5E1 <> 1 and DVD5F1 <> 1 and DVD5G1 <> 1) and 
    (DVD5A1 = 2 or DVD5B1 = 2 or DVD5C1 = 2 or DVD5D1 = 2 or DVD5E1 = 2 or DVD5F1 = 2 or DVD5G1 = 2)) or
    DVD18 = 2)  v12Smt = 12.
variable labels v12Smt "Sometimes".

compute v12Any = 20.
if (v12Often = 11 or v12Smt = 12 or DVD15A1 = 1) v12Any = 10.
variable labels v12Any "Often or sometimes".

value labels v12Any
    10 "Experience of physical violence often or sometimes in last 12 months"
    11 "   Often "
    12 "   Sometimes "
    20  "No experience of physical violence often or sometimes in last 12 months".

mrsets
  /mcgroup name = $v12Any
           label = 'Experience of physical violence in last 12 months'
           variables = v12Any v12Often v12Smt.


recode WB9 (1 = 1) (9 = 8) (else = 2) into schoolAttendance.
variable labels schoolAttendance "School attendance".
value labels schoolAttendance 1 "Attending" 2 "Not attending" 8 "Missing".


/* this is the end of recoding of table DV.1.9 in a background variables
/***************************************************************************************************************************************************************************************************************/.
* Ctables command in English.
ctables
  /format missing = "na" 
  /vlabels variables = layer15_19 layer15_49 layer20_49 layer20_24 numWomen15_19 numWomen15_49 numWomen20_49
           display = none
  /table  total [c]
        + sexviol [c]
        + sexviol12 [c]
        + violence15 [c]
        + $v12Any [c]
        + schoolAttendance [c]
   by
          layer15_49 [c] > (
            before15 [s][mean '' f5.1]
          + numWomen15_49 [c][count '' f5.0] )
        + layer20_49 [c] > (
            before152049 [s][mean '' f5.1]
          + before18 [s][mean '' f5.1]
          + numWomen20_49 [c][count '' f5.0] )
        + layer20_24 [c] > (
            before15_1 [s][mean '' f5.1]
          + before18_1 [s][mean '' f5.1]
          + numWomen20_24 [c][count '' f5.0] )          
        + layer15_19 [c] > (
            currentlyMarried [s][mean '' f5.1]
          + numWomen15_19 [c][count '' f5.0] )
  /slabels position=column visible = no
  /categories variables=all empty=exclude missing=exclude
  /titles title=
    "FA Table CP.4.1: Child marriage (women)  - Linkages with Sexual and Physical Violence, School Attendnace and Early Childbearing"
    "Percentage of women age 15-49 years who first married or entered a marital union before their 15th birthday, " 
    "percentages of women age 20-49 and 20-24 years who first married or entered a marital union before their 15th and 18th birthdays, "
    "percentage of women age 15-19 years currently married or in union,  " + surveyname
  caption = 
    "[1] MICS indicator PR.4a - Child marriage (before age 15); SDG 5.3.1"														
    "[2] MICS indicator PR.4b - Child marriage (before age 18); SDG 5.3.1"														
    "[3] MICS indicator PR.5 - Young women age 15-19 years currently married or in union"															
     "na: not applicable"
  .

new file.
