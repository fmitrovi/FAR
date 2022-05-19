* Encoding: UTF-8.
* Further analysis table for Pacific MICS Surveys. Syntax written based on Fiji MICS variable. 

***.
include "surveyname.sps".

get file = 'hh.sav'.

sort cases by HH1 HH2 .
* extracting variables on WASH from hh dataset.
save outfile = 'tmp.sav'
  /keep HH1 HH2 WS1 WS2 WS3 WS4 WS11 WS16 WS17 HW1 HW2 HW7A HW7B.

get file = 'ch.sav'.

sort cases by HH1 HH2.

match files
  /file = "ch.sav"
  /table = "tmp.sav"
  /by HH1 HH2.
save outfile 'ch_wght4.sav'.


get file="ch_wght4.sav".

sort cases by hh1 hh2 uf4.
* Call include file for the working directory and the survey name.

include "CommonVarsCH.sps".

select if (UF17 = 1).

weight by chweight.

select if (cage >= 6 and cage <= 23).

* Recode system missing and missing to zero, even the variable is one digit 7 is 7+ not Incositent, so 7 is not included.
recode BD7D1 BD7E1 BD8A1 BD9
  (sysmis, 8, 9 = 0) .

* Generate indicators.
recode BD3 (sysmis, 8, 9 = 2) .
* Minimum dietary diversity.
 * The 8 food groups as listed above are distributed here:.
 * 1) Breastmilk: BD3=1
2) Grains, roots, and tubers: BD8[B], BD8[C], and BD8[E]
3) Legumes and nuts: BD8[M]
4) Dairy products: BD7[D], BD7[E], BD8[A], and BD8[N]
5) Flesh foods: BD8[I], BD8[J], and BD8pc [L]
6) Eggs: BD8[K]
7) Vitamin A rich fruits and vegetables: BD8[D], BD8[F], and BD8[G]
8) Other fruits and vegetables: BD8[H].

compute breastmilk= any(1, BD3) .
compute grainsRootsTubers = any(1, BD8B, BD8C, BD8E) .
compute legumesNuts = any(1, BD8M) .
compute dairyProducts = any(1, BD7D, BD7E, BD8A, BD8N) .
compute fleshFoods = any(1, BD8I, BD8J, BD8L) .
compute eggs = any(1, BD8K) .
compute vitaminA = any(1, BD8D, BD8F, BD8G) .
compute other = any(1, BD8H, BD8O) .

* Children who received food from at least 5 of the 8 groups listed above.
compute minimumDietaryDiversity = sum(breastmilk, grainsRootsTubers, legumesNuts, dairyProducts, fleshFoods, eggs, vitaminA, other) >= 5 .

* Adjusted minimum dietary diversity (as defined above, with the exception that food group 3 is limited to just BD8[N]) for non breastfed children.
 * do if (BD3 = 1).
 * + compute dairyProductsAdj = any(1, BD7D, BD7E, BD8A, BD8N) .
 * else .
 * + compute dairyProductsAdj = any(1,                   BD8N) .
 * end if.

do if (BD3<> 1).
+compute minimumDietaryDiversityAdj = sum(grainsRootsTubers, legumesNuts, fleshFoods, eggs, vitaminA, other) >= 4 .
end if.

* Minimum meal frequency .

*Currently breastfed.
do if (BD3 = 1) .
* Age 6-8 months: Solid, semi-solid, or soft foods at least two times (BD9>=2).
+ do if (cage >= 6 and cage <= 8).
+   compute minimumMealFrequency = BD9>=2 .
* Age 9-23 months: Solid, semi-solid, or soft foods at least three times (BD9>=3).
+ else .
+   compute minimumMealFrequency = BD9>=3 .
+ end if.
*Currently not breastfed.
else .
* Solid, semi-solid, soft, or milk feeds at least four times: (BD7[D]1+BD7[E]1+BD9 >= 4).
+ compute minimumMealFrequency = BD7D1+BD7E1+BD9 >= 4 .
* Currently not breastfed children who received at least 2 milk feeds.
* (BD7[D]1+BD7[E]1+BD8[A]1 >= 2).
+ compute atLeast2MilkFeeds = BD7D1+BD7E1+BD8A1 >= 2 .
end if.

* Minimum acceptable diet .
* Currently breastfed.
do if (BD3 = 1) .
* Children who received the minimum dietary diversity and the minimum meal frequency as defined above.
+ compute minimumAcceptableDiet = minimumDietaryDiversity & minimumMealFrequency .
* Currently not breastfed.
else .
* Children who received the minimum meal frequency, at least 2 milk feeds, 
* and the minimum dietary diversity (as defined above, with the exception that food group 3 is limited to just BD8[N]).
+ compute minimumAcceptableDiet = minimumDietaryDiversityAdj & minimumMealFrequency & atLeast2MilkFeeds.
end if .

compute childrenNo = 1.
variable labels childrenNo "Number of children age 6-23 months".
value labels childrenNo 1 "".

compute layerAll = 1.
do if (BD3 = 1).
+ compute layerBreastefed = 1.
else .
+ compute layerNotBreastefed = 1.
end if.

compute layerPercent  = 1.
compute total = 1.

variable labels layerAll ""
  /layerBreastefed ""
  /layerNotBreastefed ""
  /layerPercent ""
  /total "Total" .

value labels layerAll 1 "All"
  /layerBreastefed 1 "Currently breastfeeding"
  /layerNotBreastefed 1 "Currently not breastfeeding"
  /layerPercent 1 "Percent of children who received:"
  /total 1 " " .

* multiplay by 100 to obtain percents .
compute minimumDietaryDiversity = 100 * minimumDietaryDiversity .
compute minimumMealFrequency    = 100 * minimumMealFrequency .
compute minimumAcceptableDiet   = 100 * minimumAcceptableDiet .
compute atLeast2MilkFeeds       = 100 * atLeast2MilkFeeds .

variable labels caretakerdis "Mother's functional difficulties [D]".

/* this is the beggining of recoding of table WS.3.6 in a background variables for drinking water, sanitation and handwashing ladders
/***************************************************************************************************************************************************************************************************************/.
do if any(WS1, 11, 12, 13, 14, 21, 31, 41, 51, 61, 71,  91, 92) .
+ compute drinkingWater = 1 .
else if WS1=99.
+ compute drinkingWater = 9 .
else .
+ compute drinkingWater = 2 .
end if.

variable labels drinkingWater "Main source of drinking water".
value labels drinkingWater
  1 "Improved sources"
  2 "Unimproved sources"
  9 "Missing".
recode WS4
  (0 = 2)
 (1 thru 30 = 2)
  (31 thru 990 = 3)
  (998, 999 = 9) into time.

* Water on premises.
if ( any(WS1, 11, 12) or
     any(WS2, 11, 12) or
     any(WS3, 1, 2) )        time = 1.

variable labels  time "Time to source of drinking water".
value labels time
    1 "Water on premises"
    2 "Up to and including 30 minutes [A]"
    3 "More than 30 minutes"
    9 "DK/Missing" .


if (drinkingwater=1 and time <=2) drinking =1. 
if (drinkingwater=1 and time >=3) drinking =2. 
if (drinkingwater=2) drinking =3. 
if (WS1=81) drinking =4. 
variable labels drinking "Drinking water".
value labels drinking 1 "Basic service" 2 "Limited service" 3 "Unimproved" 4 " Surface water".

recode WS11
  (11, 12, 13, 18, 21, 22, 31 = 1)
  (95 = 3)
  (99 = 9)
  (else = 2) into toiletType.
variable labels  toiletType "Type of sanitation facility".
value labels toiletType
    1 "Improved"
    2 "Unimproved"
    3 "Open defecation (no facility, bush, field)" 
    9 "Missing".

compute flush=$sysmis.
recode WS11
  (11, 12, 13, 14, 18= 1) into flush.
variable labels  flush "".
value labels flush 1 "Flush/Pour flush to:".

* Shared facilities.
recode WS17
  (1 thru 5 = 1)
  (97, 98, 99 = 9)
  (sysmis = 0)
  (else = 2) into sharedToilet.

if (WS16 = 2) sharedToilet = 3.

variable labels sharedToilet " ".
value labels sharedToilet
  0 "Not shared"
  1 "5 households or less"
  2 "More than 5 households"
  3 "Public facility"
  9 "DK/Missing".

compute sanitation=toiletType+1.
if (toiletType=1 and sharedToilet = 0) sanitation=1.
variable labels sanitation "Sanitation".
value labels sanitation 1 "Basic service" 2 "Limited service" 3 "Unimproved" 4 " Open defecation" 10 "Missing".

compute handwashing=4.
if HW1<=3 handwashing = 2.
if HW1=4 handwashing = 3.
if (HW1<=4) and (HW2=1 and (HW7A="A" or HW7B="B")) handwashing = 1.
variable labels handwashing "Handwashing".
value labels handwashing 1 "Basic facility" 2 "Limited facility" 3 "No facility" 4 " No permission to see/Other".

compute basictotal=0.
if (drinking=1 and sanitation=1 and handwashing=1) basictotal=100.
variable labels basictotal "Basic drinking water, sanitation and hygiene service".

/* this is the end of recoding of table WS.3.6 in  background variables
/***************************************************************************************************************************************************************************************************************/.

* Ctables command in English.
ctables
  /vlabels variables = layerAll layerBreastefed layerNotBreastefed layerPercent
                       minimumDietaryDiversity minimumMealFrequency minimumAcceptableDiet 
                       atLeast2MilkFeeds childrenNo
           display = none
  /table   total [c]
         + drinking [c]
         + sanitation [c]
         + handwashing [c]
   by
           layerBreastefed [c] > (
             layerPercent [c] > (
               minimumDietaryDiversity[s][mean, "Minimum dietary diversity [A]" ,f5.1]
             + minimumMealFrequency   [s][mean, "Minimum meal frequency [B]" ,f5.1]
             + minimumAcceptableDiet  [s][mean, "Minimum acceptable diet [1] [C]" ,f5.1] )
           + childrenNo [s][validn,'Number of children age 6-23 months',f5.0] )
         + layerNotBreastefed [c] > (
             layerPercent [c] > (
               minimumDietaryDiversity[s][mean, "Minimum dietary diversity [A]" ,f5.1]
             + minimumMealFrequency   [s][mean, "Minimum meal frequency [B]" ,f5.1]
             + minimumAcceptableDiet  [s][mean, "Minimum acceptable diet [2] [C]" ,f5.1]
             + atLeast2MilkFeeds      [s][mean, "At least 2 milk feeds [3]" ,f5.1] )
           + childrenNo [s][validn,'Number of children age 6-23 months',f5.0] )
         + layerAll [c] > (
             layerPercent [c] > (
               minimumDietaryDiversity[s][mean, "Minimum dietary diversity [4] [A]" ,f5.1]
             + minimumMealFrequency   [s][mean, "Minimum meal frequency [5] [B]" ,f5.1]
             + minimumAcceptableDiet  [s][mean, "Minimum acceptable diet [C]" ,f5.1] )
           + childrenNo [s][validn,'Number of children age 6-23 months',f5.0] )
  /categories variables=all empty=exclude missing=exclude
  /titles title=
     "FA Table HN.1.9: Infant and young child feeding (IYCF) practices - Linkages with Drinking Water, Sanitation and Handwashing"
     "Percentage of children age 6-23 months who received appropriate liquids and solid, semi-solid, or soft foods " +
     "the minimum number of times or more during the previous day, by breastfeeding status, " + surveyname
 .

new file.
erase file = 'tmp.sav'.
erase file ="ch_wght4.sav".
