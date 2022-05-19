* Encoding: UTF-8.
* Further analysis table for Pacific MICS Surveys. Syntax written based on Fiji MICS variable. 
***.

* Call include file for the working directory and the survey name.
include "surveyname.sps".

* open hl file to get info regarding mother (hl14) and father (hl18) being in household.
get file = 'hl.sav'.

* sorting the data.
sort cases by hh1 hh2 hl1.

* creating tmp file.
save outfile = 'tmp.sav'
     /keep = hh1 hh2 hl1 hl4 hl6 hl12 hl13 hl14 hl16 hl17 hl18 felevel
     /rename = (hl1 = ln) .

* Open household members data file.
get file = 'ch.sav'.

sort cases by hh1 hh2 ln.

* merging the data .
match files
  /file = *
  /table = 'tmp.sav'
  /by hh1 hh2 ln.

* recode variables in order to calculate percentages.
recode hl14 (sysmis, 0 = 0) (else = 100).
recode hl18 (sysmis, 0 = 0) (else = 100).

variable labels hl14 'Mother' .
variable labels hl18 'Father' .

* Select completed under 5 questionnaires.
select if (UF17  = 1 and UB2>=2).
weight by chweight.

* calculation of the indicators.
* 1 MICS indicator TC.49a - Support for learning.
compute ind62sum = 
	((EC5AA='A') or (EC5AB='B') or (EC5AX='X')) +
	((EC5BA='A') or (EC5BB='B') or (EC5BX='X')) +
	((EC5CA='A') or (EC5CB='B') or (EC5CX='X')) +
	((EC5DA='A') or (EC5DB='B') or (EC5DX='X')) +
	((EC5EA='A') or (EC5EB='B') or (EC5EX='X')) +
	((EC5FA='A') or (EC5FB='B') or (EC5FX='X')) .

compute ind62 = (ind62sum >= 4) * 100 .

* 2 MICS Indicator TC.49b - Father's support for learning.
compute ind63sum = (EC5AB='B') +
                   (EC5BB='B') +
                   (EC5CB='B') +
                   (EC5DB='B') +
                   (EC5EB='B') +
                   (EC5FB='B') .

compute ind63 = (ind63sum >= 4) * 100 .

* 3 MICS Indicator TC.49c - Mother's support for learning.
compute ind64sum = (EC5AA='A') +
                   (EC5BA='A') +
                   (EC5CA='A') +
                   (EC5DA='A') +
                   (EC5EA='A') +
                   (EC5FA='A') .

compute ind64 = (ind64sum >= 4) * 100 .
compute none=0.
if ind62sum=0 none=100.
variable labels none "Percentage of children with whom no adult household member have engaged in any activity".

* labeling variables for table heading.
variable labels
  ind62  "Percentage of children with whom adult household members have engaged in four or more activities [1]"
 /ind62sum "Mean number of activities with adult household members"
 /ind63  "Percentage of children with whom fathers have engaged in four or more activities [2]"
 /ind63sum "Mean number of activities with fathers"
 /ind64  "Percentage of children with whom mothers have engaged in four or more activities [3]"
 /ind64sum "Mean number of activities with mothers".

* Generate total.
compute total = 1.
compute totchild = 1.
compute tot2 = 1.
compute tot3 = 1.
compute tot4 = 1.
if (hl14>0) tot64 = 1 .
value labels total 1 "Total".
value labels tot4 1 "Percentage of children living with their".

value labels totchild 1 "Number of children age 2-4 years".

variable labels melevel "Mother's education".
variable labels cdisability "Functional difficulties".

variable labels UB2 "Age".
value labels UB2 2 "2" 3 "3" 4 "4".

compute layer1 = 0.
variable labels layer1 "".
value labels layer1 0 "Adult household members".
	
compute layer2 = 0.
variable labels layer2 "".				   
value labels layer2 0 "Father".

compute layer3 = 0.
variable labels layer3 "".
value labels layer3 0 "Mother".

add value labels felevel 5 "Biological father not in the household".
/***************************************************************************************************************************************************************************************************************/
/* Syntax in this section is based on Table SR.11.1 that were recoded as background variables to be matched with table TC.10.1 as per request from Education section of MCO in Fiji 
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
  /vlabels variables = tot2 tot3 tot4 tot64 total totchild layer1 layer2 layer3 display = none
  /table  total[c]
        + $livingArrangements [c]
        + notWithMother [c]
        + notWithParent [c]
        + anyParentDead [c]
   by
          layer1 [c] > (ind62  [s] [mean f5.1]
        + ind62sum [s] [mean f5.1]
        + none [s] [mean f5.1])
        + tot4[c] > ( 
           hl18 [s] [mean f5.1] + hl14 [s] [mean f5.1] )
        + layer2 [c] > (ind63 [s] [mean f5.1]
        + ind63sum [s] [mean f5.1])
        + layer3 [c] > (ind64 [s] [mean f5.1]
        + ind64sum [s] [mean f5.1])
        + totchild [c] [count f5.0]
  /categories variables=all empty=exclude missing=exclude
  /slabels visible=no
  /titles title=
    "FA Table ED.1.1: Support for learning by type of living arrangements"
    "Percentage of children age 2-4 years with whom adult household members engaged in activities that promote learning and school "
    "readiness during the last three days, and engagement in such activities by fathers and mothers, " + surveyname								
.

new file.

erase file = 'tmp.sav'.
