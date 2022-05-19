* Encoding: UTF-8.
* Further analysis table for Pacific MICS Surveys. 

include "surveyname.sps".

* Merging needed variables from hl dataset to be analysed with attitudes toward physical punishment.
get file = "hl.sav".
sort cases by hh1 hh2 hl1.
save outfile = "tmpHL.sav"/keep hh1 hh2 hl1 hl4 hl6 hl12 hl13 hl14 hl16 hl17 hl18 /rename hl1 = mline.


* Merging needed variables from fs dataset to be analysed with childrens living arrangements.
get file = "fs.sav".

sort cases hh1 hh2 fs3.

rename variables 
FS17 = result
FS3 = mline
FCD5 = CD5
fshweight = hweight
fsdisability = cdisability.

save outfile = "tmpfs.sav"/keep HH1 HH2 LN mline CD5 hweight melevel cdisability caretakerdis religion wscore windex5 windex10 wscoreu windex5u windex10u wscorer windex5r windex10r 
 hh6 hh7 result.


* Merging needed variables from ch dataset to be analysed with childrens living arrangements.
get file = "ch.sav".
sort cases by hh1 hh2 ln.
rename variables 
UF17 = result
UF3 = mline 
UCD5 = CD5
chweight = hweight
.

save outfile = "tmpch.sav"/keep HH1 HH2 LN mline CD5 hweight melevel cdisability caretakerdis religion wscore windex5 windex10 wscoreu windex5u windex10u wscorer 
windex5r windex10r hh6 hh7 result.

get file = "tmpch.sav".

add files file = */file = "tmpfs.sav"
    .
weight by hweight.

* add tmpHL file in order to determine respondents education age.
sort cases by HH1 HH2 mline.
match files
  /file = *
  /table = "tmpHL.sav"
  /by HH1 HH2 mline  .

recode HL6
  (lo thru 24 = 1)
  (25 thru 34 = 2)
  (35 thru 49 = 3)
  (50 thru 96 = 4)
  (97 thru hi = 9) into ageGroup .
variable labels ageGroup "Age" .
value labels ageGroup
  1 "<25"
  2 "25-34"
  3 "35-49"
  4 "50+" 
  9 "Missing\DK".
select if (HL6 <= 14 and HL6 >= 1) .


/* this is the beggining of recoding of table SR.11.1 in a background variables for attitudes toward physical punishment table
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
compute numChildren = 1.
value labels numChildren 1 "Number of children age 0-17 years" .

compute total = 1.
variable labels total "Total".
value labels total 1 " ".
* Respondent believes that a child needs to be physically punished: CD4=1.
compute belivePunishment = 0 .
if (CD5 = 1) belivePunishment = 100 .
variable labels belivePunishment "Percentage of mothers/caretakers who believe that a child needs to be physically punished" .

compute numRespondents = 1.
value labels numRespondents 1 "Number of mothers/ caretakers responding to a child discipline module".

compute total = 1.
variable labels total "Total".
value labels total 1 " ".

variable labels melevel "Education".
variable labels caretakerdis "Mother's functional difficulties [A]".


* Ctables command in English.
ctables
   /vlabels variables = numRespondents
            display = none
   /table  total [c]
        + $livingArrangements [c]
        + notWithMother [c]
        + notWithParent [c]
        + anyParentDead [c]
    by
           belivePunishment [s][mean '' f5.1]
         + numRespondents [c] [count '' f5.0]
  /categories variables=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title=
    "FA Table CP.2.1: Attitudes toward physical punishment - Living Arrangements Linkages"
    "Percentage of mothers/caretakers of children age 1-14 years who believe that physical punishment is needed to bring up, raise, or educate a child properly, " + surveyname
.
new file.

erase file = "tmpch.sav" .
erase file = "tmpfs.sav" .
erase file = "tmpHL.sav" .

