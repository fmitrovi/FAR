* Encoding: UTF-8.
* Further analysis table for Pacific MICS Surveys. 



include "surveyname.sps".

get file = "fs.sav".

sort cases hh1 hh2 ln.

rename variables 
FS17 = result
FCD2A = CD2A
FCD2B = CD2B
FCD2C = CD2C
FCD2D = CD2D
FCD2E = CD2E
FCD2F = CD2F
FCD2G = CD2G
FCD2H = CD2H
FCD2I = CD2I
FCD2J = CD2J
FCD2K = CD2K
fsdisability = disability
fsweight = hweight
CB3 = age.

save outfile = "tmpfs.sav"/keep  HH1 HH2 LN CD2A CD2B CD2C CD2D CD2E CD2F CD2G  CD2H CD2I CD2J CD2K hweight melevel
disability caretakerdis wscore windex5 windex10 wscoreu windex5u windex10u wscorer windex5r windex10r age hh6 hh7 hl4 result.

get file = "ch.sav".

sort cases by hh1 hh2 ln.

rename variables 
UF17 = result
UCD2A = CD2A
UCD2B = CD2B
UCD2C = CD2C
UCD2D = CD2D
UCD2E = CD2E
UCD2F = CD2F
UCD2G = CD2G
UCD2H = CD2H
UCD2I = CD2I
UCD2J = CD2J
UCD2K = CD2K
cdisability = disability
chweight = hweight
ub2 = age.

save outfile = "tmpch.sav"/keep hh1 hh2 ln CD2A CD2B CD2C CD2D CD2E CD2F CD2G  CD2H CD2I CD2J CD2K hweight melevel
disability caretakerdis wscore windex5 windex10 wscoreu windex5u windex10u wscorer windex5r windex10r age hh6 hh7 hl4 result.

get file = "tmpch.sav".

add files file = * /file = "tmpfs.sav".

get file = "hl.sav".

sort cases by hh1 hh2 hl1.

save outfile = "tmpHL.sav"/keep hh1 hh2 hl1 hl4 hl6 hl12 hl13 hl14 hl16 hl17 hl18 /rename hl1 = ln.


get files="tmpch.sav".

match files
  /file = *
  /table = 'tmpHL.sav'
  /by HH1 HH2 LN.

select if (result = 1).

select if (age > 0 and age < 15).

weight by hweight.

recode age (1, 2 = 1) (3, 4 = 2) (5 thru 9 = 3) (10 thru 14 = 4) into ageGroup .
variable labels ageGroup "Age" .
value labels ageGroup
  1 "1-2"
  2 "3-4"
  3 "5-9"
  4 "10-14" .


* (F) Any violent discipline method . 
compute anyViolent = 0 .
if (any(1, CD2C, CD2D, CD2F, CD2G, CD2H, CD2I, CD2J, CD2K)) anyViolent = 100 .

* (B) Only non-violent discipline . 
compute nonViolent = 0.
if (any(1, CD2A, CD2B, CD2E) and anyViolent=0)  nonViolent = 100 .

* (C) Psychological aggression .
compute anyPsychological = 0 .
if (any(1, CD2D, CD2H)) anyPsychological = 100 .

* (D) Any physical punishment . 
compute anyPhysical = 0 .
if (any(1, CD2C, CD2F, CD2G, CD2I, CD2J, CD2K)) anyPhysical =  100 .

* (E) Severe physical punishment .
compute severePhysical = 0 .
if (any(1, CD2I, CD2K)) severePhysical = 100 .

variable labels
   nonViolent "Only non-violent discipline"
  /anyPsychological "Psychological  aggression"
  /anyPhysical "Any"
  /severePhysical "Severe [A]"
  /anyViolent "Any violent discipline method [1]" .

compute numChildren = 1.
value labels numChildren 1 "Number of children age 1-14 years".

compute layer = 1.
value labels layer 1 "Percentage of children age 1-14 years who experienced:" .

compute layerPhysical = 1.
value labels layerPhysical 1 "Physical punishment" .

compute total = 1.
variable labels total "Total".
value labels total 1 " ".

variable labels disability "Child's functional difficulties (age 2-14 years) [B]".
variable labels caretakerdis "Mother's functional difficulties [C]".

/* this is the beggining of recoding of table SR.11.2 in a background variables for child marriage
/***************************************************************************************************************************************************************************************************************/.
compute livingArrangements =99.
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



/* this is the end of recoding of table SR.11.2 in a background variables
/***************************************************************************************************************************************************************************************************************/.	
	
* Ctables command in English.
ctables
   /vlabels variables = layer layerPhysical numChildren
            display = none
   /table  total [c]
         + $livingArrangements [c]
        + notWithMother [c]
        + notWithParent [c]
        + anyParentDead [c]
    by 
           layer [c] > (
             nonViolent [s][mean '' f5.1]
           + anyPsychological [s][mean '' f5.1]
           + layerPhysical [c] > (
               anyPhysical [s][mean '' f5.1] 
             + severePhysical [s][mean '' f5.1] ) 
           + anyViolent [s][mean '' f5.1] ) 
         + numChildren [c] [count '' f5.0] 
  /categories variables=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title=
    "FA Table CP.6.1: Child discipline - Linkages with Child Living Arrangements"
    "Percentage of children age 1-14 years by child disciplining methods experienced during the last one month, " + surveyname
   caption =
     "[1] MICS indicator PR.2 - Violent discipline; SDG 16.2.1"				
     "[A] Severe physical punishment includes: 1) Hit or slapped on the face, head or ears or 2) Beat up, that is, hit over and over as hard as one could	"				
.	
	 
new file.

erase file = "tmpch.sav".
erase file = "tmpfs.sav".
erase file = "tmpHL.sav".
