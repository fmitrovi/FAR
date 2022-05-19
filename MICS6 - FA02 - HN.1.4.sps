* Encoding: UTF-8.
* Further analysis table for Pacific MICS Surveys. Syntax written based on Fiji MICS variable. 


* Call include file for the working directory and the survey name.
include "surveyname.sps".

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
save outfile 'ch_wght3.sav'.


get file="ch_wght3.sav".

sort cases by hh1 hh2 uf4.

include "CommonVarsCH.sps".

select if (UF17 = 1).

weight by chweight.

select if (cage <= 23).

compute numChildren = 1.
variable labels numChildren "Number of children age 0-23 months:".
value labels numChildren 1"".

* Bottle feeding: BD4=1 .
compute bottleFeeding = 0.
if (BD4 = 1) bottleFeeding = 100.
variable labels bottleFeeding "Percentage of children age 0-23 months fed with a bottle with a nipple [1]".

variable labels caretakerdis "Mother's functional difficulties [A]".

compute total = 1.
variable labels total  "Total".
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
  /table   total [c]
       + deliveryPlace [c]         
        + deliveryType [c]
   by
           bottleFeeding [s] [mean '' f5.1]
         + numChildren [s] [count,'' f5.0]
  /categories variables=all empty=exclude missing=exclude
  /slabels position=column visable = no
  /titles title=
     "FA Table HN.1.4: Bottle feeding - Linkages with Place and Type of Delivery"
     "Percentage of children age 0-23 months who were fed with a bottle with a nipple during the previous day, " + surveyname
 . 
 
new file.

erase file = 'tmp.sav'.
erase file ="ch_wght3.sav".
