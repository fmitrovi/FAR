* Encoding: UTF-8.
* Further analysis table for Pacific MICS Surveys. 

include "surveyname.sps".

get file = "hl.sav".

sort cases by hh1 hh2 hl1.

save outfile = "tmpHL.sav"/keep hh1 hh2 hl1 hl4 hl6 hl12 hl13 hl14 hl16 hl17 hl18 /rename hl1 = wm3.

get files="wm.sav".

match files
  /file = *
  /table = 'tmpHL.sav'
  /by HH1 HH2 WM3.

select if (WM17 = 1).

weight by wmweight.
compute before15 = 0.
if (WAGEM < 15) before15 = 100.

do if (WB4 < 18).
+ compute numWomen15_17 = 1.
+ compute currentlyMarried = 0.
+ if any(MA1, 1, 2) currentlyMarried = 100 .
end if.

compute layer15_17 = 1 .
value labels 
  /layer15_17 1 "Women age 15-17 years"
  /numWomen15_17 1 "Women age 15-17 years" .
 *   /numMarried 1 "Number of women age 15-49 years currently married/in union".
  
variable labels 
    before15    "Percentage married before age 15"
 .
compute total = 1.
variable labels total "Total".
value labels total 1 " ".

/* this is the beggining of recoding of table SR.11.2 in a background variables for child marriage
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
    /anyParentDead 1  "One or both parents dead"                2  "Both parents alive".                                                    .

recode CM11 (sysmis = 0) .
compute birthBefore = 0.
if (CM11 > 0)  and ((wdobfc - wdob)/12 < 15) birthBefore = 1.
if (CM11 > 0)  and ((wdobfc - wdob)/12 < 18) birthBefore = 2.
if (CM11 > 0)  and ((wdobfc - wdob)/12 >= 18) birthBefore =3.
if CM11=0 birthBefore=4.
variable labels birthBefore "Early childbearing".
value labels birthBefore 1 "Birth before 15" 2 "Birth before 18" 3 "Birth at 18 and after" 4 "No live births".   

/* this is the end of recoding of table SR.11.2 in a background variables
/***************************************************************************************************************************************************************************************************************/.


ctables
  /format missing = "na" 
  /vlabels variables = layer15_17 numWomen15_17 
           display = none
  /table total [c ]
         + $livingArrangements [c]
        + notWithMother [c]
        + notWithParent [c]
        + anyParentDead [c]
        + birthBefore[c]
   by
           layer15_17 [c] > (
            currentlyMarried [s][mean '' f5.1]
          + numWomen15_17 [c][count '' f5.0] )
  /slabels position=column visible = no
  /categories variables=all empty=exclude missing=exclude
  /titles title=
    "FA Table CP.4.3: Child marriage - Linkages with Child's living Arrangements"
    "Percentage of women age 15-49 years who first married or entered a marital union before their 15th birthday, " 
    "percentages of women age 20-49 and 20-24 years who first married or entered a marital union before their 15th and 18th birthdays, "
    "percentage of women age 15-19 years currently married or in union,  " + surveyname
  caption = 									
    "[1] MICS indicator PR.5 - Young women age 15-19 years currently married or in union"															
  .

new file.
erase file = 'tmpHL.sav'.
