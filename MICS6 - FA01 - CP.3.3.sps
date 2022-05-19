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
FS4 =WM3
.

save outfile = "tmpfs.sav"/keep  HH1 HH2 WM3 CD2A CD2B CD2C CD2D CD2E CD2F CD2G  CD2H CD2I CD2J CD2K CD5 hweight melevel
disability caretakerdis wscore windex5 windex10 wscoreu windex5u windex10u wscorer windex5r windex10r age hh6 hh7 hl4 result.

* extracting variables on child discipline from ch dataset.
*get file = "ch.sav".

*sort cases by hh1 hh2 uf4 uf3.

*rename variables 
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
UCD5 = CD5
cdisability = disability
chweight = hweight
ub2 = age
UF4=WM3
.

*save outfile = "tmpch.sav"/keep hh1 hh2 wm3 CD2A CD2B CD2C CD2D CD2E CD2F CD2G  CD2H CD2I CD2J CD2K CD5 hweight melevel
disability caretakerdis wscore windex5 windex10 wscoreu windex5u windex10u wscorer windex5r windex10r age hh6 hh7 hl4 result.

*get file = "tmpch.sav".

*add files file = * /file = "tmpfs.sav".

* open women data file.
get files="wm.sav".

sort cases by hh1 hh2 wm3.
match files
  /file = *
  /table = 'tmpfs.sav'
  /by HH1 HH2 wm3.

include "CommonVarsWM.sps".

* select completed questionnaires, and women selected for domestic violence.
select if (WM17 = 1 and sysmis (DVD1)=0 and DVD1 = 1).

* select women who have ever been married.
select if (mstatus = 1 or mstatus = 2).

weight by dvweight.

* create total row.
compute total = 1.
variable labels total "Total".
value labels total 1" ".

********************DHS.
 * PROGRAMMING Table DV10: 
Denominator 
All ever-married women for all columns.

 * Numerator 
Column 1: Emotional violence: A YES on at least one of items DV04A (a-c)
Column 2 Physical violence: A YES on at least one of items DV05A (a-g)
Column 3: Sexual violence: A YES on at least one of items DV05A (h-j)
Column 4: Physical and sexual violence: A YES on at least one of items DV05A (a-g) AND at least one item DV05A (h-j)
Column 5: Physical and sexual and emotional violence: A YES on at least one of items DV05A (a-g) AND at least one item DV05A (h-j) AND at least one item DV04A (a-c)
Column 6: Physical and/or sexual violence: A YES on at least one of items DV05A(a-j)
Column 7: Physical or sexual or emotional violence: A YES on at least one of items DV05A (a-j) OR DV04A (a-c)


********************MICS.
*
PROGRAMMING Table DV10: 
Denominator 
All ever-married women for all columns.

 * Numerator 
Column 1: Emotional violence: A YES on at least one of items DVD4A (a-c)
Column 2 Physical violence: A YES on at least one of items DVD5 (a-g)
Column 3: Sexual violence: A YES on at least one of items DVD5 (h-j)
Column 4: Physical and sexual violence: A YES on at least one of items DVD5 (a-g) AND at least one item DVD5 (h-j)
Column 5: Physical and sexual and emotional violence: A YES on at least one of items DVD5 (a-g) AND at least one item DVD5 (h-j) AND at least one item DVD4A (a-c)
Column 6: Physical and/or sexual violence: A YES on at least one of items DVD5(a-j)
Column 7: Physical or sexual or emotional violence: A YES on at least one of items DVD5 (a-j) OR DVD4A (a-c).

compute emotional = 0.
if (DVD4A = 1 or DVD4B = 1 or DVD4C = 1) emotional = 100.
variable labels emotional "Emotional violence".

compute physical = 0.
if (DVD5A = 1 or DVD5B = 1 or DVD5C = 1 or DVD5D = 1 or DVD5E = 1 or DVD5F = 1 or DVD5G = 1) physical = 100.
variable labels physical "Physical violence".

compute sexual = 0.
if (DVD5H = 1 or DVD5I = 1 or DVD5J = 1) sexual = 100.
variable labels sexual "Sexual violence".

compute PysAndSex =0.
if (physical = 100 and sexual = 100) PysAndSex = 100.
variable lables PysAndSex "Physical and sexual".

compute PysAndSexAndEm =0.
if (physical = 100 and sexual = 100 and emotional = 100) PysAndSexAndEm = 100.
variable labels PysAndSexAndEm "Physical and sexual and emotional".

compute PysOrSex =0.
if (physical = 100 or sexual = 100) PysOrSex = 100.
variable lables PysOrSex "Physical or sexual".

compute PysOrSexOrEm =0.
if (physical = 100 or sexual = 100 or emotional = 100) PysOrSexOrEm = 100.
variable labels PysOrSexOrEm "Physical or sexual or emotional".

compute nwm = 1.
value labels nwm 1 "Number of ever-married women".
variable labels nwm "".

variable labels mstatus "Marital status".
value labels mstatus 1"Married or living together" 2"Divorced/separated/widowed".

variable labels DVD13 "Women afraid of husband/partner".


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
  /vlabels variables = total nwm  
           display = none
  /table  total [c]
         + anyViolent [c]
         + nonViolent [c]
         + anyPhysical [c]
         + severePhysical [c]             
         + anyPsychological [c]
         + belivePunishment [c]
  by
        emotional [s] [mean,'',f5.1] + physical [s] [mean,'',f5.1] + sexual [s][mean,'',f5.1] + PysAndSex [s][mean,'',f5.1] + PysAndSexAndEm [s][mean,'',f5.1] + PysOrSex [s][mean,'',f5.1] + PysOrSexOrEm [s][mean,'',f5.1] +
         nwm [c] [count,'',f5.0]
  /categories var=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title=
                  "FA Table CP.3.3: Spousal violence -  Linkage with Child Discipline (5-17)"			
                  "Percentage of ever-married women age 15-49 who have ever experienced emotional, physical, or sexual violence committed by their current or most recent husband/partner, by child discipline (5-17), " + surveyname 			
.										
									
new file.

erase file= 'tmpfs.sav'.


