* Encoding: UTF-8.
* Further analysis table for Pacific MICS Surveys. Syntax written based on Fiji MICS variable. 
include "surveyname.sps".

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
FS3 =HL1
.

save outfile = "tmpfs.sav"/keep  HH1 HH2 HL1 CD2A CD2B CD2C CD2D CD2E CD2F CD2G  CD2H CD2I CD2J CD2K CD5 hweight melevel
disability caretakerdis wscore windex5 windex10 wscoreu windex5u windex10u wscorer windex5r windex10r age hh6 hh7 hl4 result.

get file = 'hl.sav'.

sort cases by hh1 hh2 hl1.
match files
  /file = *
  /table = 'tmpfs.sav'
  /by HH1 HH2 hl1.

weight by hhweight.

* Select children who are of primary school age; this definition is
* country-specific and should be changed to reflect the situation in your
* country.

* include definition of primarySchoolEntryAge .
include 'define/MICS6 - 08 - LN.sps' .

variable labels schage "Age at beginning of school year".

select if (schage >= primarySchoolEntryAge and schage <= primarySchoolCompletionAge).

/*****************************************************************************/

compute primary  = 0.
if (ED10A >= 1 and ED10A <= 2)  primary =  100.

*Children that did not attend school in the current school year, but have already completed primary school are also included in the numerator (ED9=2 and ED5A=1 and ED5B=last grade of primary school and ED6=1). 
*All children of primary school age (at the beginning of the school year) are included in the denominator. 
if (ED5A = 1 and ED5B = primarySchoolGrades and ED6 = 1 and ED9 = 2) primary  = 100.

*Rates presented in this table are termed "adjusted" since they include not only primary school attendance, but also secondary school attendance in the numerator.
*The percentage of children: 
*i) Attending early childhood education are those who in the current school year have been attending early childhood education (ED10A=0).
compute attendingPreschool = 0.
if (ED10A = 0) attendingPreschool = 100 .

*ii) Out of school children are those who did not attend any level of education or early childhood education in the current school year (ED9=2).
*Children for whom it is not known whether they are attending school (ED9>2) are not considered out of school. 
*For this reason and because children who completed the level but are not attending school in the current school year will be in both numerators of ANAR and Out of school, the results do not necessarily sum to 100. 
* compute notAttendingSchoolPreschool = 0 .                                                                                                    Removed as per Tab Plan of 3 March 2021.
* if (ED9 = 2 or ED4 = 2) notAttendingSchoolPreschool = 100 .                                                                            Removed as per Tab Plan of 3 March 2021.
* if (ED5A = 1 and ED5B = primarySchoolGrades and ED6 = 1 and ED9 = 2) notAttendingSchoolPreschool  = 0.    Removed as per Tab Plan of 3 March 2021.

compute outOfSchool = 0.
if (ED4 = 2 or ED9 = 2) outOfSchool = 100.

variable labels primary "".
variable labels HL4 "".

compute layer = 1.
value labels layer 1 "Percentage of children:".

compute numChildren = 1.

variable labels caretakerdis "Mother's functional difficulties [B]".

compute total = 1.
variable labels total "Total".
value labels total 1 " ".

/***************************************************************************************************************************************************************************************************************/
/* Syntax in this section is based on Table PR.2.1 that were recoded as background variables to be matched with table LN.2.3 as per request from Education section of MCO in Fiji 
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

* Ctables command in English.
ctables
  /vlabels variables = hl4 primary layer attendingPreschool outOfSchool numChildren
           display = none
  /table   total [c]
         + anyViolent [c]  /* all these are the added variables for FA
         + nonViolent [c]
         + anyPhysical [c]
         + severePhysical [c]             
         + anyPsychological [c]
         + belivePunishment [c]
   by
           hl4 [c] > (
             primary [s][mean,'Net attendance rate (adjusted) [1]',f5.1]
           + layer [c] > (
               attendingPreschool [s] [mean,'Attending early childhood education',f5.1]
             + outOfSchool [s] [mean,'Out of school [A]',f5.1] )
           + numChildren [s] [validn,'Number of children of primary school age at beginning of school year'] )
  /categories variables=all empty=exclude missing=exclude
  /categories variables=hl4 total=yes position = after label = "Total"
  /slabels position=column
  /titles title=
    "FA Table ED.2.1: School attendance among children of primary school age - Linkages with Violent Discipline"
    "Percentage of children of primary school age at the beginning of the school year attending primary, lower or upper secondary school (net attendance rate, adjusted), " +
    "percentage attending early childhood education, and percentage out of school, by sex, " + surveyname
.

/*****************************************************************************/

new file.

erase file = "tmpfs.sav".
