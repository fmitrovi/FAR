* Encoding: UTF-8.
* Further analysis table for Pacific MICS Surveys. Syntax written based on Fiji MICS variable. 

include "surveyname.sps".

get file = 'hl.sav'.

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
/* Syntax in this section is based on Table SR.11.1 that were recoded as background variables to be matched with table LN.2.6 as per request from Education section of MCO in Fiji 
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

* Ctables command in English.
ctables
  /vlabels variables = hl4 secondary lowsecondary primary outOfSchool layer
           display = none
  /table   total [c]
        + $livingArrangements [c]
        + notWithMother [c]
        + notWithParent [c]
        + anyParentDead [c]
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
    "FA Table ED.1.4 : School attendance among children of upper secondary school age by type of living arrangements"
    "Percentage of children of upper secondary school age at the beginning of the school year attending upper secondary school or higher (net attendance rate, adjusted), " +
    "percentage attending lower secondary school, percentage attending primary school, and percentage out of school, by sex, " + surveyname
  .

/*****************************************************************************/

new file.
