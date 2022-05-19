* Encoding: UTF-8.
* Further analysis table for Pacific MICS Surveys. Syntax written based on Fiji MICS variable. 
/*.
/*****************************************************************************/

include "surveyname.sps".

get file = 'hl.sav'.

weight by hhweight.

* Select children who are of primary school age; this definition is
* country-specific and should be changed to reflect the situation in your
* country.

* include definition of primarySchoolEntryAge .
include 'define/MICS6 - 08 - LN.sps' .

/*****************************************************************************/

*The gross intake rate to the last grade of primary school (and similar for lower secondary school) is the ratio of the total number of students currently
attending the last grade of primary school for the first time (i.e. who are not repeating the grade) to the total number of children of primary school completion age
(age at the beginning of the school year appropriate for the last grade of primary school):
100 * (number of children attending the last grade of primary school - repeaters) / (number of children of primary school completion age at the beginning of the school year).
 * - Children attending the last grade of primary school are those with ED10A=1 and ED10B=last grade of primary.
 * - Repeaters are those in the last grade of primary in both ED10A/B and ED16A/B (ED10A=1 and ED10B=the last grade of primary and ED16A=1 and ED16B=the last grade of primary).
 * - The denominator is children whose age at the beginning of the school year is equal to the age corresponding to the last grade of primary school.

* Primary.
* number of repeaters.
compute repeatersP = 0.
if ((ED10A = 1 and ED10B = primarySchoolGrades)  and ED16A = ED10A and ED16B  = ED10B) repeatersP = 1.

* number of children in last primary grade.
compute inLastGradeP = 0.
if ((ED10A = 1 and ED10B = primarySchoolGrades) and repeatersP = 0) inLastGradeP  = 1.

* number of children o primary school completion age.
compute denominatorP = 0.
if (schage = primarySchoolCompletionAge) denominatorP  = 1.

* The primary completion rate (and similar for lower and upper secondary school) is percentage of children age 3-5 years above the intended age
*for the last grade who completed the last grade of primary school. Primary school completion is calculated as:
*- ED5A=2, 3 or 4 OR (ED5A=1 and ED5B=the last grade of primary and ED6=1)
*- The appropriate age group (which should be customised in the table and syntax) is found by adding 3-5 years to the age corresponding to the last grade of primary school.

compute numberLastP = 0.
if (schage >= primarySchoolCompletionAge + 3 and schage <= primarySchoolCompletionAge + 5) numberLastP = 1.

compute completionP = 0.
* IB customized to exclude Special education.
if  numberLastP = 1 and ((ED5A=1 and (ED5B=7 or ED5B=8)) or (ED5A > 1 and ED5A < 5) or (ED5A=1 and ED5B = primarySchoolGrades and ED6=1)) completionP  = 1.

* Lower secondary.
* number of repeaters.
compute repeatersLS = 0.
* IB customized.
if ((ED10A = 2 and ED10B = LowSecSchoolGrades+6)  and ED16A = ED10A and ED16B  = ED10B) repeatersLS = 1.

* number of children in last low secondary grade.
compute inLastGradeLS = 0.
* IB customized.
if ((ED10A = 2 and ED10B = LowSecSchoolGrades+6) and repeatersLS = 0) inLastGradeLS  = 1.

* number of children of  low secondary completion age.
compute denominatorLS = 0.
if (schage = LowSecSchoolCompletionAge) denominatorLS  = 1.

* The primary completion rate (and similar for lower and upper secondary school) is percentage of children age 3-5 years above the intended age
*for the last grade who completed the last grade of primary school. Primary school completion is calculated as:
*- ED5A=2, 3 or 4 OR (ED5A=1 and ED5B=the last grade of primary and ED6=1)
*- The appropriate age group (which should be customised in the table and syntax) is found by adding 3-5 years to the age corresponding to the last grade of primary school.

compute numberLastLS = 0.
if (schage >= LowSecSchoolCompletionAge + 3 and schage <= LowSecSchoolCompletionAge + 5) numberLastLS = 1.

compute completionLS = 0.
if  numberLastLS = 1 and ((ED5A > 3 and ED5A < 5) or (ED5A = 2 and ED5B > 10) or (ED5A=2 and ED5B = LowSecSchoolGrades+6 and ED6=1)) completionLS  = 1.

* Upper secondary.
* number of repeaters.
compute repeatersUS = 0.
if ((ED10A = 2 and ED10B = 13)  and ED16A = ED10A and ED16B  = ED10B) repeatersUS = 1.

* number of children in last low secondary grade.
compute inLastGradeUS = 0.
if ((ED10A = 2 and ED10B = 13) and repeatersUS = 0) inLastGradeUS  = 1.

* number of children of  low secondary completion age.
compute denominatorUS = 0.
if (schage = UpSecSchoolCompletionAge) denominatorUS  = 1.

* The primary completion rate (and similar for lower and upper secondary school) is percentage of children age 3-5 years above the intended age
*for the last grade who completed the last grade of primary school. Primary school completion is calculated as:
*- ED5A=2, 3 or 4 OR (ED5A=1 and ED5B=the last grade of primary and ED6=1)
*- The appropriate age group (which should be customised in the table and syntax) is found by adding 3-5 years to the age corresponding to the last grade of primary school.

compute numberLastUS = 0.
if (schage >= UpSecSchoolCompletionAge + 3 and schage <= UpSecSchoolCompletionAge + 5) numberLastUS = 1.

compute completionUS = 0.
if  numberLastUS = 1 and ((ED5A > 3 and ED5A < 8) or (ED5A = 2 and ED5B = 13 and ED6 = 1) or (ED5A = 3 and ED5B = 3)) completionUS  = 1.

 * Children attending lower secondary school who were in primary school the year before the survey are those with ED10A=2 and ED16A=1 and ED16B=last grade of primary.
 * The denominator is children who were in the last grade of primary the previous year (ED16A Level=1 and ED16B Grade=last grade of primary).

 * The effective transition rate is:
100 * (number of children in the first grade of lower secondary school who were in the last grade of primary school the previous year)
/ (number of children in the last grade of primary school the previous year who are not repeating the last grade of primary school in the current year) or in the form of the algorithm:
- (ED10A=2 and ED10B=1 and ED16A=1 and ED16B=the last grade of primary) / (ED16A=1 and ED16B=the last grade of primary <> (ED10A=1 and ED10B=the last grade of primary))

* number of children in first secondary grade who were in primary last year.
compute inLowSecondary1 = 0.
* Customized to take into account those in grade 7 of primary school who were in grade 6 last year).
if (ED10A = 1 and ED10B = 7 and ED16A = 1 and ED16B = primarySchoolGrades) inLowSecondary1  = 1.

compute inPrimaryLast = 0.
if (ED16A = 1 and ED16B = primarySchoolGrades) inPrimaryLast = 1.

compute total = 1.
variable labels total "".
value labels total 1 "Total".

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

/*****************************************************************************/

aggregate outfile = 'tmp1.sav'
  /break    = total
  /repeatersP = sum(repeatersP)
  /inLastGradeP = sum(inLastGradeP)
  /denominatorP = sum(denominatorP)
  /numberLastP = sum(numberLastP)
  /completionP = sum(completionP)
  /repeatersLS = sum(repeatersLS)
  /inLastGradeLS = sum(inLastGradeLS)
  /denominatorLS = sum(denominatorLS)
  /numberLastLS = sum(numberLastLS)
  /completionLS = sum(completionLS)
  /repeatersUS = sum(repeatersUS)
  /inLastGradeUS = sum(inLastGradeUS)
  /denominatorUS = sum(denominatorUS)
  /numberLastUS = sum(numberLastUS)
  /completionUS = sum(completionUS)
  /inLowSecondary1 = sum(inLowSecondary1)
  /inPrimaryLast = sum(inPrimaryLast).

aggregate outfile = 'tmp2.sav'
  /break    = livingArrangements
  /repeatersP = sum(repeatersP)
  /inLastGradeP = sum(inLastGradeP)
  /denominatorP = sum(denominatorP)
  /numberLastP = sum(numberLastP)
  /completionP = sum(completionP)
  /repeatersLS = sum(repeatersLS)
  /inLastGradeLS = sum(inLastGradeLS)
  /denominatorLS = sum(denominatorLS)
  /numberLastLS = sum(numberLastLS)
  /completionLS = sum(completionLS)
  /repeatersUS = sum(repeatersUS)
  /inLastGradeUS = sum(inLastGradeUS)
  /denominatorUS = sum(denominatorUS)
  /numberLastUS = sum(numberLastUS)
  /completionUS = sum(completionUS)
  /inLowSecondary1 = sum(inLowSecondary1)
  /inPrimaryLast = sum(inPrimaryLast).

aggregate outfile = 'tmp3.sav'
  /break    = livingArrangements2
  /repeatersP = sum(repeatersP)
  /inLastGradeP = sum(inLastGradeP)
  /denominatorP = sum(denominatorP)
  /numberLastP = sum(numberLastP)
  /completionP = sum(completionP)
  /repeatersLS = sum(repeatersLS)
  /inLastGradeLS = sum(inLastGradeLS)
  /denominatorLS = sum(denominatorLS)
  /numberLastLS = sum(numberLastLS)
  /completionLS = sum(completionLS)
  /repeatersUS = sum(repeatersUS)
  /inLastGradeUS = sum(inLastGradeUS)
  /denominatorUS = sum(denominatorUS)
  /numberLastUS = sum(numberLastUS)
  /completionUS = sum(completionUS)
  /inLowSecondary1 = sum(inLowSecondary1)
  /inPrimaryLast = sum(inPrimaryLast).

aggregate outfile = 'tmp4.sav'
  /break    = livingArrangements3
  /repeatersP = sum(repeatersP)
  /inLastGradeP = sum(inLastGradeP)
  /denominatorP = sum(denominatorP)
  /numberLastP = sum(numberLastP)
  /completionP = sum(completionP)
  /repeatersLS = sum(repeatersLS)
  /inLastGradeLS = sum(inLastGradeLS)
  /denominatorLS = sum(denominatorLS)
  /numberLastLS = sum(numberLastLS)
  /completionLS = sum(completionLS)
  /repeatersUS = sum(repeatersUS)
  /inLastGradeUS = sum(inLastGradeUS)
  /denominatorUS = sum(denominatorUS)
  /numberLastUS = sum(numberLastUS)
  /completionUS = sum(completionUS)
  /inLowSecondary1 = sum(inLowSecondary1)
  /inPrimaryLast = sum(inPrimaryLast).

aggregate outfile = 'tmp5.sav'
  /break    = livingArrangements4
  /repeatersP = sum(repeatersP)
  /inLastGradeP = sum(inLastGradeP)
  /denominatorP = sum(denominatorP)
  /numberLastP = sum(numberLastP)
  /completionP = sum(completionP)
  /repeatersLS = sum(repeatersLS)
  /inLastGradeLS = sum(inLastGradeLS)
  /denominatorLS = sum(denominatorLS)
  /numberLastLS = sum(numberLastLS)
  /completionLS = sum(completionLS)
  /repeatersUS = sum(repeatersUS)
  /inLastGradeUS = sum(inLastGradeUS)
  /denominatorUS = sum(denominatorUS)
  /numberLastUS = sum(numberLastUS)
  /completionUS = sum(completionUS)
  /inLowSecondary1 = sum(inLowSecondary1)
  /inPrimaryLast = sum(inPrimaryLast).

aggregate outfile = 'tmp6.sav'
  /break    = windex5
  /repeatersP = sum(repeatersP)
  /inLastGradeP = sum(inLastGradeP)
  /denominatorP = sum(denominatorP)
  /numberLastP = sum(numberLastP)
  /completionP = sum(completionP)
  /repeatersLS = sum(repeatersLS)
  /inLastGradeLS = sum(inLastGradeLS)
  /denominatorLS = sum(denominatorLS)
  /numberLastLS = sum(numberLastLS)
  /completionLS = sum(completionLS)
  /repeatersUS = sum(repeatersUS)
  /inLastGradeUS = sum(inLastGradeUS)
  /denominatorUS = sum(denominatorUS)
  /numberLastUS = sum(numberLastUS)
  /completionUS = sum(completionUS)
  /inLowSecondary1 = sum(inLowSecondary1)
  /inPrimaryLast = sum(inPrimaryLast).


aggregate outfile = 'tmp7.sav'
  /break    = notWithMother
  /repeatersP = sum(repeatersP)
  /inLastGradeP = sum(inLastGradeP)
  /denominatorP = sum(denominatorP)
  /numberLastP = sum(numberLastP)
  /completionP = sum(completionP)
  /repeatersLS = sum(repeatersLS)
  /inLastGradeLS = sum(inLastGradeLS)
  /denominatorLS = sum(denominatorLS)
  /numberLastLS = sum(numberLastLS)
  /completionLS = sum(completionLS)
  /repeatersUS = sum(repeatersUS)
  /inLastGradeUS = sum(inLastGradeUS)
  /denominatorUS = sum(denominatorUS)
  /numberLastUS = sum(numberLastUS)
  /completionUS = sum(completionUS)
  /inLowSecondary1 = sum(inLowSecondary1)
  /inPrimaryLast = sum(inPrimaryLast).

aggregate outfile = 'tmp8.sav'
  /break    = notWithParent
  /repeatersP = sum(repeatersP)
  /inLastGradeP = sum(inLastGradeP)
  /denominatorP = sum(denominatorP)
  /numberLastP = sum(numberLastP)
  /completionP = sum(completionP)
  /repeatersLS = sum(repeatersLS)
  /inLastGradeLS = sum(inLastGradeLS)
  /denominatorLS = sum(denominatorLS)
  /numberLastLS = sum(numberLastLS)
  /completionLS = sum(completionLS)
  /repeatersUS = sum(repeatersUS)
  /inLastGradeUS = sum(inLastGradeUS)
  /denominatorUS = sum(denominatorUS)
  /numberLastUS = sum(numberLastUS)
  /completionUS = sum(completionUS)
  /inLowSecondary1 = sum(inLowSecondary1)
  /inPrimaryLast = sum(inPrimaryLast).

aggregate outfile = 'tmp9.sav'
  /break    = anyParentDead
  /repeatersP = sum(repeatersP)
  /inLastGradeP = sum(inLastGradeP)
  /denominatorP = sum(denominatorP)
  /numberLastP = sum(numberLastP)
  /completionP = sum(completionP)
  /repeatersLS = sum(repeatersLS)
  /inLastGradeLS = sum(inLastGradeLS)
  /denominatorLS = sum(denominatorLS)
  /numberLastLS = sum(numberLastLS)
  /completionLS = sum(completionLS)
  /repeatersUS = sum(repeatersUS)
  /inLastGradeUS = sum(inLastGradeUS)
  /denominatorUS = sum(denominatorUS)
  /numberLastUS = sum(numberLastUS)
  /completionUS = sum(completionUS)
  /inLowSecondary1 = sum(inLowSecondary1)
  /inPrimaryLast = sum(inPrimaryLast).

get file = 'tmp1.sav'.
add files
  /file = *
  /file = 'tmp2.sav'
  /file = 'tmp3.sav'
  /file = 'tmp4.sav'
  /file = 'tmp5.sav'
  /file = 'tmp6.sav'
  /file = 'tmp7.sav'
  /file = 'tmp8.sav'
  /file = 'tmp9.sav'
.
/*****************************************************************************/

if (denominatorP > 0) primaryGross = (inLastGradeP / denominatorP)*100.
if (denominatorLS > 0) LowSecGross = (inLastGradeLS / denominatorLS)*100.
if (denominatorUS > 0) UpSecGross = (inLastGradeUS / denominatorUS)*100.

if (numberLastP > 0) primarySchoolCompletionRate = (completionP / numberLastP)*100.
if (numberLastLS > 0) LowSecCompletionRate = (completionLS / numberLastLS)*100.
if (numberLastUS > 0) UpSecCompletionRate = (completionUS / numberLastUS)*100.

if (inPrimaryLast > 0) transitionRateToSecondary = (inLowSecondary1 / inPrimaryLast)*100.

compute adjInLastPrimaryGrade = inPrimaryLast - repeatersP .

if (adjInLastPrimaryGrade > 0) effectiveTransitionRateToSecondary = (inLowSecondary1 / adjInLastPrimaryGrade)*100.

variable labels
  primaryGross                                    "Gross intake ratio to the last grade of primary school [1]"
  /denominatorP                                   "Number of children of primary school completion age at beginning of school year"
  /primarySchoolCompletionRate            "Primary school completion rate [2]"
  /numberLastP                                    "Number of children age 14-16 years at beginning of school year [A]"
  /effectiveTransitionRateToSecondary    "Effective transition rate to lower secondary school [3]"
  /adjInLastPrimaryGrade                       "Number of children who were in the last grade of primary school the previous year and are not repeating that grade in the current school year"
  /LowSecGross                                    "Gross intake ratio to the last grade of lower secondary school [4]"
  /denominatorLS                                  "Number of children of lower secondary school completion age at beginning of school year"
  /LowSecCompletionRate                     "Lower secondary completion rate [5]"
  /numberLastLS                                   "Number of adolescents age 17-19 years at beginning of school year [A]"
  /UpSecCompletionRate                       "Upper secondary completion rate [6]"
  /numberLastUS                                  "Number of youth age 20-22 years at beginning of school year [A]"
.

/*****************************************************************************/

* Ctables command in English.
ctables
  /format missing = "na"
  /vlabels variables = total
           display = none
  /table   total [c]
        + livingArrangements [c]
        + livingArrangements2 [c]
        + livingArrangements3 [c]
        + livingArrangements4 [c]
        + notWithMother [c]
        + notWithParent [c]
        + anyParentDead [c]
   by
           primaryGross [s] [mean '' f5.1]
         + denominatorP [s] [sum '' f5.0]
         + primarySchoolCompletionRate [s] [mean '' f5.1]
         + numberLastP [s] [sum '' f5.0]
         + effectiveTransitionRateToSecondary [s] [mean '' f5.1]
         + adjInLastPrimaryGrade [s] [sum '' f5.0]
         + LowSecGross [s] [mean '' f5.1]
         + denominatorLS [s] [sum '' f5.0]
         + LowSecCompletionRate [s] [mean '' f5.1]
         + numberLastLS [s] [sum '' f5.0]
         + UpSecCompletionRate [s] [mean '' f5.1]
         + numberLastUS [s] [sum '' f5.0]
  /categories variables=all empty=exclude missing=exclude
  /slabels visible=no
  /titles title=
    "FA Table ED.1.5: Gross intake, completion and effective transition rates  by type of living arrangements"
    "Gross intake ratio and completion rate for primary school, effective transition rate to lower secondary school, gross intake ratio and completion rate for lower secondary school and completion rate for upper secondary school, " + surveyname
.

/*****************************************************************************/

new file.

* delete working files.
erase file = 'tmp1.sav'.
erase file = 'tmp2.sav'.
erase file = 'tmp3.sav'.
erase file = 'tmp4.sav'.
erase file = 'tmp5.sav'.
erase file = 'tmp6.sav'.
erase file = 'tmp7.sav'.
erase file = 'tmp8.sav'.
erase file = 'tmp9.sav'.
