* Encoding: UTF-8.
* Further analysis table for Pacific MICS Surveys. Syntax written based on Fiji MICS variable. 


* Call include file for the working directory and the survey name.
include "surveyname.sps".

* open children dataset.
get file = 'ch.sav'.

include "CommonVarsCH.sps".

* Select completed interviews.
select if (UF17 = 1).

* Select children 2-4 years of age.
select if (UB2 >= 2).

*crosstabs ub2 by cage.

* Weight the data by the children weight.
weight by chweight.

* Generate number of children age 2-4.
compute numChildren = 1.
value labels numChildren  1 "".
variable labels numChildren "Number of children age 2-4 years".

 * Achievement of developmental milestones is calculated as follows:
 “Yes” answer to questions EC21 to EC38 (EC21-EC38=1); 
any answer other than “daily” to question EC39 (EC39=2, 3, 4 or 5);  any answer other than “more” or “a lot more” to question EC40 (ECD40=1, 2 or 3).

* Compute indicators.
recode EC21 EC22 EC23 EC24 EC25 EC26 EC27 EC28 EC29 EC30 EC31 EC32 EC33 EC34 EC35 EC36 EC37 EC38 (1 = 100) (else = 0).

recode EC39 (2, 3 ,4 ,5 = 100) (else = 0).
recode EC40 (1, 2, 3 = 100) (else = 0).

 * Thus defined, the number of achieved developmental milestones are used to determine whether children are developmentally on track, according to age-specific cut-scores:
   24-29 months: at least 7 milestones.
 * 30-35 months: at least 9 milestones.
 * 36-41 months: at least 11 milestones.
 * 42-47 months: at least 13 milestones.
 * 48-59 months:at least 15 milestones.

count develop = EC21 EC22 EC23 EC24 EC25 EC26 EC27 EC28 EC29 EC30 EC31 EC32 EC33 EC34 EC35 EC36 EC37 EC38 EC39 EC40 (100).

compute target = 0.
if cage >= 24 and cage <= 29 and develop >= 7 target = 100.
if cage >= 30 and cage <= 35 and develop >= 9 target = 100.
if cage >= 36 and cage <= 41 and develop >= 11 target = 100.
if cage >= 42 and cage <= 47 and develop >= 13 target = 100.
if cage >= 48 and cage <= 59 and develop >= 15 target = 100.

variable labels target "Early child development index score [1]".

do if UB2 > 2.
+recode UB8 (1 = 1) (9 = 8) (else = 2).
end if.
variable labels UB8 "Attendance to early childhood education [A]".
value labels UB8
  1 "Attending"
  2 "Not attending "
  8 "Missing".
	
									  
variable labels ub2 "Age".
value labels ub2 2 "2" 3 "3" 4 "4".

compute total = 1.
variable labels total "Total".
value labels total 1" ".

variable labels cdisability "Functional difficulties".

* Household Memeber's support for learning.
compute ind62sum = 
	((EC5AA='A') or (EC5AB='B') or (EC5AX='X')) +
	((EC5BA='A') or (EC5BB='B') or (EC5BX='X')) +
	((EC5CA='A') or (EC5CB='B') or (EC5CX='X')) +
	((EC5DA='A') or (EC5DB='B') or (EC5DX='X')) +
	((EC5EA='A') or (EC5EB='B') or (EC5EX='X')) +
	((EC5FA='A') or (EC5FB='B') or (EC5FX='X')) .

compute ind62 = 9.
if (ind62sum >= 4) ind62 = 1 .
if (ind62sum < 4) ind62 = 2 .
variable labels ind62 "Children with whom adult household members have engaged in activities".
value labels ind62 1 "Children with whom adult household members have engaged in four or more activities" 2 "Children with whom adult household members have not engaged in four or more activities" 9 "DK/Missing".


* Father's support for learning.
compute ind63sum = (EC5AB='B') +
                   (EC5BB='B') +
                   (EC5CB='B') +
                   (EC5DB='B') +
                   (EC5EB='B') +
                   (EC5FB='B') .

compute ind63 = 9.
if (ind63sum >= 4) ind63 = 1 .
if (ind63sum < 4) ind63 = 2 .
variable labels ind63 "Children with whom fathers have engaged in activities".
value labels ind63 1 "Children with whom fathers have engaged in four or more activities" 2 "Children with whom fathers have not engaged in four or more activities" 9 "DK/Missing".

* Mother's support for learning.
compute ind64sum = (EC5AA='A') +
                   (EC5BA='A') +
                   (EC5CA='A') +
                   (EC5DA='A') +
                   (EC5EA='A') +
                   (EC5FA='A') .
compute ind64 = 9.
if (ind64sum >= 4) ind64 = 1 .
if (ind64sum < 4) ind64 = 2 .
variable labels ind64 "Children with whom mothers have engaged in activities".
value labels ind64 1 "Children with whom mothers have engaged in four or more activities" 2 "Children with whom mothers have not engaged in four or more activities" 9 "DK/Missing".
* No support for learning.

compute none=9.
if (ind62sum=0) none=1.
if (ind62sum<>0) none=2.
variable labels none "Children with whom no adult household member have engaged in any activity".
value labels none 1 "Children with whom adult household members have engaged in any activity" 2 "Children with whom adult household members have engaged in any activity" 9 "DK/Missing".

* Ctables command in English.
ctables
  /table   total [c]
         + ind62 [c]
         + ind63 [c]
         + ind64 [c]
         + none [c]
   by
          target[s] [mean '' f5.1]
         + numChildren [s] [sum '' f5.0]
  /categories variables=all empty=exclude
  /slabels position=column visible = no
  /titles title=
     "FA Table ECD.5.1: Early child development index - Linkage with Early Support for Learning"
     "Percentage of children age 2-4 years who have achieved the minimum number of milestones expected for their age group, by stunting,  " + surveyname
.


new file.
