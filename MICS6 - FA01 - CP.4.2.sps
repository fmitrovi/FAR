* Encoding: UTF-8.
* Further analysis table for Pacific MICS Surveys. 

include "surveyname.sps".

* extracting variables on child discipline from fs dataset.
get file = "fs.sav".

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
FCD5 = CD5
fsdisability = disability
fsweight = hweight
CB3 = age
FS3 =WM3
.

save outfile = "tmpfs.sav"/keep  HH1 HH2 WM3 CD2A CD2B CD2C CD2D CD2E CD2F CD2G  CD2H CD2I CD2J CD2K CD5 hweight melevel
disability caretakerdis wscore windex5 windex10 wscoreu windex5u windex10u wscorer windex5r windex10r age hh6 hh7 hl4 result.


* open women data file.
get files="wm.sav".

sort cases by hh1 hh2 wm3.
match files
  /file = *
  /table = 'tmpfs.sav'
  /by HH1 HH2 wm3.

include "CommonVarsWM.sps".

select if (WM17 = 1 and WB4<20).

weight by wmweight.

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
  /layer15_19 1 "Women age 15-19 years"
  /numWomen15_19 1 "Women age 15-19 years" .
 *   /numMarried 1 "Number of women age 15-49 years currently married/in union".
  
variable labels currentlyMarried "Percentage currently married/in union [1]".
 *    /inPolygynous "Percentage in polygynous marriage/in union [4]" .

compute total = 1.
variable labels total "Total".
value labels total 1 " ".


/* this is the beggining of recoding of table PR.2.1 in a background variables for domestic violence table
/***************************************************************************************************************************************************************************************************************/.
compute anyViolent = 9 .
if (any(1, CD2C, CD2D, CD2F, CD2G, CD2H, CD2I, CD2J, CD2K)) anyViolent = 1 .
if (not(any(1, CD2C, CD2D, CD2F, CD2G, CD2H, CD2I, CD2J, CD2K))) anyViolent = 2 .
variable labels anyViolent "Any violent discipline method".
value labels anyViolent 1 "Children experiencing any violent discipline method" 2 "Children not experiencing any violent discipline method" 9 "Missing".

compute anyViolent1 = 0 .
if (any(1, CD2C, CD2D, CD2F, CD2G, CD2H, CD2I, CD2J, CD2K)) anyViolent1 = 100 .

compute nonViolent = 9.
if (any(1, CD2A, CD2B, CD2E) and anyViolent1=0)  nonViolent = 1 .
if (not(any(1, CD2A, CD2B, CD2E) and anyViolent1=0))  nonViolent = 2 .
variable labels nonViolent "Non violent discipline method".
value labels nonViolent 1 "Children experiencing only non violent discipline method" 2 "Children not experiencing non violent discipline method" 9 "Missing".

compute anyPhysical = 9.
if (any(1, CD2C, CD2F, CD2G, CD2I, CD2J, CD2K))   anyPhysical = 1 .
if (not(any(1, CD2C, CD2F, CD2G, CD2I, CD2J, CD2K)))  anyPhysical = 2 .
variable labels anyPhysical "Any physical discipline method".
value labels anyPhysical 1 "Children experiencing any physical discipline method" 2 "Children not experiencing any physical discipline method" 9 "Missing".

compute severePhysical = 9.
if (any(1, CD2I, CD2K))   severePhysical = 1 .
if (not(any(1, CD2I, CD2K)))  severePhysical = 2 .
variable labels severePhysical "Severe physical discipline method".
value labels severePhysical 1 "Children experiencing severe physical discipline method" 2 "Children not experiencing severe physical discipline method" 9 "Missing".

compute anyPsychological = 9.
if (any(1, CD2D, CD2H))  anyPsychological = 1 .
if (not(any(1, CD2D, CD2H)))  anyPsychological = 2 .
variable labels anyPsychological "Severe physical discipline method".
value labels anyPsychological 1 "Children experiencing severe physical discipline method" 2 "Children not experiencing severe physical discipline method" 9 "Missing".

compute belivePunishment = 9 .
if (any(1, CD5)) belivePunishment = 1 .
if (not(any(1, CD5))) belivePunishment =2.
variable labels belivePunishment "Percentage of mothers/caretakers who believe that a child needs to be physically punished" .
value labels belivePunishment  1 "Percentage of mothers/caretakers who believe that a child needs to be physically punished" 2 "Percentage of mothers/caretakers who do not believe that a child needs to be physically punished" 9 "Missing".

/* this is the end of recoding of table PR.2.1 in a background variables
/***************************************************************************************************************************************************************************************************************/.
ctables
  /format missing = "na" 
  /vlabels variables = layer15_19 numWomen15_19
           display = none
  /table  total [c]
         + anyViolent [c]
         + nonViolent [c]
         + anyPhysical [c]
         + severePhysical [c]             
         + anyPsychological [c]
         + belivePunishment [c]
   by
         layer15_19 [c] > (
            currentlyMarried [s][mean '' f5.1]
          + numWomen15_19 [c][count '' f5.0] )
  /slabels position=column visible = no
  /categories variables=all empty=exclude missing=exclude
  /titles title=
    "FA Table CP.4.2: Child marriage (women) - Linkages with Child Labour and Violent Discipline"
    "Percentage of women age 15-49 years who first married or entered a marital union before their 15th birthday, " 
    "percentages of women age 20-49 and 20-24 years who first married or entered a marital union before their 15th and 18th birthdays, "
    "percentage of women age 15-19 years currently married or in union,  " + surveyname
  caption = 											
    "[1] MICS indicator PR.5 - Young women age 15-19 years currently married or in union"															
  .

new file.
erase file = "tmpfs.sav".
