* Encoding: UTF-8.
* Further analysis table for Pacific MICS Surveys. 

include "surveyname.sps".
/***************************************************************************************************************************************************************************************************************/
/* Syntax in this section is copying variables for children aged 5 -17 on child discpiline from  Table PR.2.1  to be matched with table LN.2.3 as per request from Education section of MCO in Fiji .
get file = "hh.sav".

save outfile = "tmpfs.sav"/keep  HH1 HH2 ST4U$1 ST4U$2 ST4U$3 ST4U$4 ST4U$5 ST4N$1 ST4N$2 ST4N$3 ST4N$4 ST4N$5.
/* this is the end of copying fs.sav variables from table PR.2.1 in a background variables to hl.sav dataset.
/***************************************************************************************************************************************************************************************************************/.
get file = 'hl.sav'.

sort cases by hh1 hh2.
match files
  /file = *
  /table = 'tmpfs.sav'
  /by HH1 HH2 .


weight by hhweight.

* Select children who are of primary school age; this definition is
* country-specific and should be changed to reflect the situation in your
* country.

* include definition of primarySchoolEntryAge .
include 'define/MICS6 - 08 - LN.sps' .

*All children of lower secondary school age at the beginning of the school year are included in the denominator.
select if (schage >= LowSecSchoolEntryAge and schage <= LowSecSchoolCompletionAge).

variable labels schage "Age at beginning of school year".

/*****************************************************************************/

*Children of lower secondary school age currently attending lower secondary school or higher (ED10A Level=2, 3 or 4) are included in the numerator.
compute secondary  = 0.
if ((ED10A = 1 and (ED10B = 7 or ED10B = 8)) or ED10A = 2 or ED10A = 3) secondary =  100.

*Children that did not attend school in the current school year, but have already completed lower secondary school are also included in the numerator (ED9=2 and ED5A=2 and ED5B=last grade of lower secondary school and ED6=1). 
*All children of lower secondary school age at the beginning of the school year are included in the denominator.
if (ED5A = 2 and ED5B = 10 and ED6 = 1 and ED9 = 2) secondary  = 100.

compute primary  = 0.
if (ED10A = 1 and ED10B < 7) primary =  100.

*The percentage of children out of school are those who did not attend any level of education or early childhood education in the current school year (ED9=2).
*Children for whom it is not known whether they are attending school (ED9>2) are not considered out of school. 
*For this reason and because children who completed the level but are not attending school in the current school year will be in both numerators of ANAR and Out of school, the results do not necessarily sum to 100. 
compute outOfSchool = 0 .
if (ED4 = 2 or ED9 = 2) outOfSchool = 100.
*if (ED5A = 2 and ED5B = LowSecSchoolGrades+6 and ED6 = 1 and ED9 = 2) outOfSchool  = 0.    Removed as per Tab Plan of 3 March 2021.

variable labels primary "".
variable labels secondary "".
variable labels outOfSchool "".
variable labels HL4 "".

compute layer = 1.
value labels layer 1 "Percentage of children:".

variable labels melevel "Mother's education [B]".
variable labels caretakerdis "Mother's functional difficulties [C]".

compute total = 1.
variable labels total "Total".
value labels total 1 " ".
/***************************************************************************************************************************************************************************************************************/
/* Syntax in this section is based on Table EQ.2.6 that were recoded as background variables to be matched with table LN.2.3 as per request from Education section of MCO in Fiji. 

compute Socialtransfer1=9.
if (ST4U$1=1 and ST4N$1<=3) Socialtransfer1=1.
if (ST4U$1<>1 and ST4N$1>3) Socialtransfer1=2.
variable labels Socialtransfer1 "Social Pension Scheme".
value labels Socialtransfer1 1 "Household receives transfer" 2 "Household does not receive transfer" 9 "DK/Missing". 

compute Socialtransfer2=9.
if (ST4U$2=1 and ST4N$2<=3) Socialtransfer2=1.
if (ST4U$2<>1 and ST4N$2>3) Socialtransfer2=2.
variable labels Socialtransfer2 "Poverty Benefit Scheme".
value labels Socialtransfer2 1 "Household receives transfer" 2 "Household does not receive transfer" 9 "DK/Missing". 

compute Socialtransfer3=9.
if (ST4U$3=1 and ST4N$3<=3) Socialtransfer3=1.
if (ST4U$3<>1 and ST4N$3>3) Socialtransfer3=2.
variable labels Socialtransfer3 "Care & Protection Allowance".
value labels Socialtransfer3 1 "Household receives transfer" 2 "Household does not receive transfer" 9 "DK/Missing". 

compute SocialtransferPension=9.
if (ST4U$4=1 and ST4N$4<=3) SocialtransferPension=1.
if (ST4U$4<>1 and ST4N$4>3) SocialtransferPension=2.
variable labels SocialtransferPension "Any retirement pension".
value labels SocialtransferPension 1 "Household receives transfer" 2 "Household does not receive transfer" 9 "DK/Missing".

compute SocialtransferOther=9.
if (ST4U$5=1 and ST4N$5<=3) SocialtransferOther=1.
if (ST4U$5<>1 and ST4N$5>3) SocialtransferOther=2.
variable labels SocialtransferOther "Any other external assistance program".
value labels SocialtransferOther 1 "Household receives transfer" 2 "Household does not receive transfer" 9 "DK/Missing".

do if ((HL6>=5 and HL6<=24) and (ED10A>=1 and ED10A<8)).
+ compute EDsupport=0.
+ if (ED12=1 or ED14=1) EDsupport=1.
end if.

compute nEDsupport=9.
if nEDsupport>0  EDsupport=1.
if nEDsupport<=0  EDsupport=2.
variable labels nEDsupport "School tuition or school related other support for any household member age 5-24 years attending primary school or higher".
value labels nEDsupport 1 "Household receives transfer" 2 "Household does not receive transfer" 9 "DK/Missing".

compute any=9.
if (Socialtransfer1=1 or Socialtransfer2=1 or Socialtransfer3=1 or SocialtransferPension=1 or SocialtransferOther=1 or EDsupport=1) any=1.
if not((Socialtransfer1=1 or Socialtransfer2=1 or Socialtransfer3=1 or SocialtransferPension=1 or SocialtransferOther=1 or EDsupport=1)) any=2.
variable labels any "Any social transfers or benefits".
value labels any 1 "Household receives transfer" 2 "Household does not receive transfer" 9 "DK/Missing".

/* this is the end of recoding of table EQ.2.6 in a background variables
/***************************************************************************************************************************************************************************************************************/.

* Ctables command in English.
ctables
  /vlabels variables = hl4 secondary primary outOfSchool layer
           display = none
  /table   total [c]
         + any [c]
         + Socialtransfer1 [c]
         + Socialtransfer2 [c]
         + Socialtransfer3 [c]             
         + SocialtransferPension [c]
         + SocialtransferOther [c]
         + nEDsupport [c]
   by
          hl4 [c] > (
             secondary [s] [mean,'Net attendance rate (adjusted) [1]',f5.1]
           + layer [c] > (primary   [s] [mean,'Attending primary school',f5.1]
           + outOfSchool [s] [mean,'Out of school [2],[A]',f5.1])
           + secondary [s] [validn,'Number of children of lower secondary school age at beginning of school year',f5.0] )
  /categories variables=all empty=exclude missing=exclude
  /categories variables=hl4 total=yes position = after label = "Total"
  /slabels position=column
  /titles title=
    "FA Table ED.6.1: School attendance among children of lower secondary school age - Linkages with Social Transfers"
    "Percentage of children of lower secondary school age at the beginning of the school year attending lower secondary school or higher (net attendance rate, adjusted), " +
    "percentage attending primary school, and percentage out of school, by sex, " + surveyname
  .

/*****************************************************************************/

new file.
erase file = "tmpfs.sav".
