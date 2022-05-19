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

recode CM11 (sysmis = 0) .

do if (WB4 >=15 and WB4<=19).
+ compute numWoman15 = 1.
+ compute hadBirth = 0.
+ if (CM11 > 0) hadBirth = 100.
+ compute firstChild = 0.
+ if (hadBirth = 0 and CP1 = 1) firstChild = 100.
+ compute begunChildbearing = 0.
+ if (hadBirth = 100 or CP1 = 1) begunChildbearing  = 100.
+ compute birthBefore15 = 0.
+ if ((wdobfc - wdob)/12 < 15) birthBefore15 = 100.
end if.

variable labels
   numWoman15 "Number of women age 15-19 years"
  /hadBirth "Have had a live birth"
  /firstChild "Are pregnant with first child"
  /begunChildbearing "Have had a live birth or are pregnant with first child"
  /birthBefore15 "Have had a live birth before age 15"
  .

do if (WB4 >=20 and WB4 <= 24).
+ compute numWoman20 = 1.
+ compute birthBefore18 = 0.
+ if ((wdobfc - wdob)/12 < 18) birthBefore18 = 100.
end if.

variable labels
   numWoman20 "Number of women age 20-24 years"
  /birthBefore18 "Percentage of women age 20-24 years who have had a live birth before age 18 [1]"
  .

compute layer = 0.
value labels layer 0 "Percentage of women age 15-19 years who:".
variable labels layer " ".

compute total = 1.
variable labels total "Total".
value labels total 1" ".


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

* Ctables command in English.
ctables
  /vlabels variables = layer
           display = none
  /table   total [c]
         + $livingArrangements [c]
        + notWithMother [c]
        + notWithParent [c]
        + anyParentDead [c]
        + birthBefore[c] 
   by
           layer [c] > (
             hadBirth [s] [mean '' f5.1]
           + firstChild [s] [mean '' f5.1]
           + begunChildbearing [s] [mean '' f5.1]
           + birthBefore15 [s] [mean '' f5.1] )
         + numWoman15 [s] [sum '' f5.0]
  /slabels position=column visible =no
  /categories variables=all empty=exclude missing=exclude
  /titles title=
                 "FA Table CP.5.1: Early childbearing (young women) -  Linkages with living arrangements"						
                 "Percentage of women age 15-19 years who have had a live birth, are pregnant with the first child, have had a live birth or are pregnant with first child, "+
                 "and who have had a live birth before age 15 " + surveyname
   caption =
     "[1] MICS indicator TM.2 - Early childbearing"
  .
  
new file.
erase file = "tmpHL.sav".
