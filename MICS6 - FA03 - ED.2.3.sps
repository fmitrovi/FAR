* Encoding: UTF-8.
* Further analysis table for Pacific MICS Surveys. 

include "surveyname.sps".
/***************************************************************************************************************************************************************************************************************/
/* Syntax in this section is copying variables for children aged 5 -17 on child discpiline from  Table PR.2.1  to be matched with table LN.2.3 as per request from Education section of MCO in Fiji .
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
/* this is the end of copying fs.sav variables from table PR.2.1 in a background variables to hl.sav dataset.
/***************************************************************************************************************************************************************************************************************/.
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

*All children of upper secondary school age at the beginning of the school year are included in the denominator.
select if (schage >= UpSecSchoolEntryAge  and schage <= UpSecSchoolCompletionAge).

variable labels schage "Age at beginning of school year".

/*****************************************************************************/

*Children of upper secondary school age currently attending upper secondary school or higher (ED10A=3 or 4) are included in the numerator.
compute secondary  = 0.
if (ED10A = 2 and (ED10B = 11 or ED10B = 12 or ED10B = 13)) or ED10A = 3 or ED10A = 4 secondary =  100.

* Set test for "Age at the begining of school year" equal to age in last grade of secondary and test for ED4B equal to the last grade of secondary.
*  upper secondary school grades are 13. 
if (ED5A = 2 and ED5B = 13 and ED6 = 1 and ED9 = 2) secondary  = 100.
* IB: included vocational education too.
if (ED5A = 3 and ED5B = 3 and ED6 = 1 and ED9 = 2) secondary  = 100.

compute primary  = 0.
if (ED10A = 1 and ED10B < 7) primary =  100.

compute lowsecondary  = 0.
if (ED10A = 1 and (ED10B = 7 or ED10B = 8)) or (ED10A = 2 and (ED10B = 9 or ED10B = 10)) lowsecondary =  100.

* The percentage of children out of school are those who did not attend any level of education or early childhood education in the current school year (ED9=2).
compute outOfSchool = 0 .
if (ED9 = 2 or ED4 = 2) outOfSchool = 100.
*if (ED5A = 2 and ED5B = UpSecSchoolGrades+8 and ED6 = 1 and ED9 = 2) outOfSchool  = 0.    Removed as per Tab Plan of 3 March 2021.

variable labels melevel "Mother's education [B]".
variable labels caretakerdis "Mother's functional difficulties [C]".

variable labels primary "".
variable labels lowsecondary "".
variable labels secondary "".
variable labels outOfSchool "".
variable labels HL4 "".

compute total = 1.
variable labels total "Total".
value labels total 1 " ".

compute layer = 1.
value labels layer 1 "Percentage of children:".
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
  /vlabels variables = hl4 secondary lowsecondary primary outOfSchool layer
           display = none
  /table   total [c]
         + anyViolent [c]
         + nonViolent [c]
         + anyPhysical [c]
         + severePhysical [c]             
         + anyPsychological [c]
         + belivePunishment [c]
   by
           hl4 [c] > (
             secondary [s] [mean,'Net attendance rate (adjusted) [1]',f5.1]
           + layer [c] > (lowsecondary  [s] [mean,'Attending lower secondary school',f5.1]
           + primary   [s] [mean,'Attending primary school',f5.1]
           + outOfSchool [s] [mean,'Out of school [A]',f5.1])
           + secondary [s] [validn,'Number of children of upper secondary school age at beginning of school year',f5.0] )
  /categories variables=all empty=exclude missing=exclude
  /categories variables=hl4 total=yes position = after label = "Total"
  /slabels position=column
  /titles title=
    "FA Table ED.2.3 : School attendance among children of upper secondary school age by type of living arrangements"
    "Percentage of children of upper secondary school age at the beginning of the school year attending upper secondary school or higher (net attendance rate, adjusted), " +
    "percentage attending lower secondary school, percentage attending primary school, and percentage out of school, by sex, " + surveyname
  .

/*****************************************************************************/

new file.
