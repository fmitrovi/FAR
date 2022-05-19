* Encoding: UTF-8.
* Further analysis table for Pacific MICS Surveys. Syntax written based on Fiji MICS variable. 

include "surveyname.sps".

* extracting variables on place of birth from wm dataset.
get file = 'wm.sav'.

sort cases by HH1 HH2 LN BH4D_last BH4M_last BH4Y_last BH6_last .

save outfile = 'tmp.sav'
  /rename (LN BH4D_last BH4M_last BH4Y_last BH6_last = UF4 UB1D UB1M UB1Y UB2)
  /keep HH1 HH2 UF4 UB1D UB1M UB1Y UB2 MN34A MN20 MN21.

get file = 'ch.sav'.

sort cases by HH1 HH2 UF4 UB1D UB1M UB1Y UB2.

match files
  /file = *
  /table = "tmp.sav"
  /by HH1 HH2 UF4 UB1D UB1M UB1Y UB2.
save outfile 'ch_wght2.sav'.


get file="ch_wght2.sav".

sort cases by hh1 hh2 uf4.

weight by chweight.

select if (UF17 = 1).

* include definition of solidSemiSoft, exclusivelyBreastfed and predominantlyBreastfed .
include 'define/MICS6 - 07 - TC.sps' .

do if (cage >= 0 and cage <= 5).
+ compute childUpTo5 = 100.
end if.
value labels childUpTo5 100 "Children age 0-5 months".

do if (cage >= 12 and cage <= 15).
+ compute breastfed12_15 = 0.
+ if (BD3 = 1) breastfed12_15 = 100.
end if.
variable labels breastfed12_15 "Children age 12-15 months".

do if (cage >= 20 and cage <= 23).
+ compute breastfed20_23 = 0.
+ if (BD3 = 1) breastfed20_23 = 100.
end if.
variable labels breastfed20_23 "Children age 20-23 months".

variable labels caretakerdis "Mother's functional difficulties [A]".

compute total = 1.
variable labels total "Total".
value labels total 1 " ".

/* this is the beggining of recoding of table TM.6.1 in a background variables for place of delivery tables
/***************************************************************************************************************************************************************************************************************/.
compute deliveryType =9.
if (MN21=1) deliveryType = 2.
if (MN21=2) deliveryType = 1.
variable labels deliveryType "Type of delivery".
value labels deliveryType
  1 "Vaginal birth"
  2 "C-section" 
  9 "DK/Missing".

compute deliveryPlace = 98.
if (MN20 >= 21 and MN20 <= 26) deliveryPlace = 11.
if (MN20 >= 31 and MN20 <= 36) deliveryPlace = 12.
if (MN20 = 11 or MN20 = 12) deliveryPlace = 13.
if (MN20 = 96) deliveryPlace = 96.
if (MN20 = 76 or MN20 = 98 or MN20 = 99) deliveryPlace = 98.
variable labels deliveryPlace "Place of delivery".
value labels deliveryPlace
  11 "Public sector health facility"
  12 "Private sector health facility"
  13 "Home"
  96 "Other"
  98 "DK/Missing".
/* this is the end of recoding of table TM.6.1 in  background variables
/***************************************************************************************************************************************************************************************************************/.

* Ctables command in English.
ctables
  /vlabels variables = childUpTo5 exclusivelyBreastfed predominantlyBreastfed
           display = none
  /table   total [c]
         + deliveryPlace [c]         
        + deliveryType [c]
         by
           childUpTo5 [c] > (
             exclusivelyBreastfed [s] [mean,'Percent exclusively breastfed [1]',f5.1]
           + predominantlyBreastfed [s] [mean,'Percent predominantly breastfed [2]',f5.1
           validn,'Number of children',f5.0] )
         + breastfed12_15 [s] [mean,'Percent breastfed (Continued breastfeeding at 1 year) [3]',f5.1,
                               validn,'Number of children',f5.0]
         + breastfed20_23 [s] [mean,'Percent breastfed (Continued breastfeeding at 2 years) [4]',f5.1,
                               validn,'Number of children',f5.0]
  /categories variables=all empty=exclude missing=exclude
  /slabels position=column
  /titles title=
     "FA Table HN.1.3: Breastfeeding Status - Linkages with Place and Type of Delivery"
     "Percentage of living children according to breastfeeding status at selected age groups, " + surveyname
   .

new file.
erase file = 'tmp.sav'.
erase file ="ch_wght2.sav".
