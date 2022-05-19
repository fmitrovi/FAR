* Encoding: UTF-8.
* Further analysis table for Pacific MICS Surveys. Syntax written based on Fiji MICS variable. 

* extracting variables on child height and weight from hl dataset.
include "surveyname.sps".

get file = 'hl.sav'.

sort cases by HH1 HH2 HL1 .

save outfile = 'tmp.sav'
  /rename (HL1 = AN5)
  /keep HH1 HH2 AN5 HL5M HL5Y HL6.

get file = 'ch.sav'.

sort cases by HH1 HH2 AN5.

match files
  /file = *
  /table = "tmp.sav"
  /by HH1 HH2 AN5.
save outfile 'ch2.sav'.

* extracting variables on tobacco and alcohol use from wm dataset.
get file = "wm.sav".

sort cases by hh1 hh2 wm3.

save outfile = "tmpTA.sav"/keep hh1 hh2 wm3 ta1 ta2 ta3 ta4 ta5 ta6 ta7 ta9 ta10 ta13 ta14 ta15 ta16 /rename wm3 = uf4.

get file="ch2.sav".
sort cases by hh1 hh2 uf4.
  match files
  /file = *
  /table = 'tmpTA.sav'
  /by HH1 HH2 UF4.

sort cases by hh1 hh2 uf4.

if HL5Y<9997 and HL5M<=12 CMCmother= (HL5M+ (HL5Y-1900)*12).
compute CMCint=(UF7M+(UF7Y-1900)*12).
compute motherageinmonth=CMCint-CMCMother.
if (HL5Y>=9997 or HL5M>12) motherageinmonth=HL6*12+6.

compute motherAgeAtBirth= TRUNC((motherageinmonth-CAGE)/12).

recode motherAgeAtBirth
  (12 thru 20 = 1)
  (20 thru 34 = 2)
  (35 thru 49 = 3) (else=9)  into motherAgeAtBirthx .
variable labels motherAgeAtBirthx "Mother's age at birth" .
value labels motherAgeAtBirthx
  1 "Less than 20"
  2 "20-34 years"
  3 "35-49 years" 
  9 "No information on biological mother".

select if (UF17 = 1).

weight by chweight.

do if (wazflag = 0).
+ recode WAZ2 (sysmis=sysmis) (-2.00 thru hi = 0) (else = 100) into wa2sd.
+ recode WAZ2 (sysmis=sysmis) (-3.00 thru hi = 0) (else = 100) into wa3sd.
+ compute waMean = WAZ2.
+ compute waCount = 1.
else.
+ compute wa2sd = $SYSMIS.
+ compute wa3sd = $SYSMIS.
end if.
variable labels wa2sd "- 2 SD [1]".
variable labels wa3sd "- 3 SD [2]".
variable labels waMean "Mean Z-Score (SD)".
variable labels waCount "Number of children with weight and age [A]".

do if (hazflag = 0).
+ recode HAZ2 (sysmis=sysmis) (-2.00 thru hi = 0) (else = 100) into ha2sd.
+ recode HAZ2 (sysmis=sysmis) (-3.00 thru hi = 0) (else = 100) into ha3sd.
+ compute haMean = HAZ2.
+ compute haCount = 1.
else.
+ compute ha2sd = $SYSMIS.
+ compute ha3sd = $SYSMIS.
end if.
variable labels ha2sd "- 2 SD [3]".
variable labels ha3sd "- 3 SD [4]".
variable labels haMean "Mean Z-Score (SD)".
variable labels haCount "Number of children with height and age [A]".

do if (whzflag = 0).
+ recode WHZ2 (sysmis=sysmis) (-2.00 thru hi = 0) (else = 100) into wh2sd.
+ recode WHZ2 (sysmis=sysmis) (-3.00 thru hi = 0) (else = 100) into wh3sd.
+ recode WHZ2 (sysmis=sysmis) (lo thru +2.00 = 0) (else = 100) into wh2sdAbove.
+ recode WHZ2 (sysmis=sysmis) (lo thru +3.00 = 0) (else = 100) into wh3sdAbove.
+ compute whMean = WHZ2.
+ compute whCount = 1.
else.
+ compute wh2sd = $SYSMIS.
+ compute wh3sd = $SYSMIS.
+ compute wh2sdAbove = $SYSMIS.
end if.
variable labels wh2sd " - 2 SD [5]".
variable labels wh3sd "- 3 SD [6]".
variable labels wh2sdAbove "+ 2 SD [7]".
variable labels wh3sdAbove "+ 3 SD [8]".
variable labels whMean "Mean Z-Score (SD)".
variable labels whCount "Number of children with weight and height [A]".

compute total = 1.
variable labels total "Total".
value labels total 1 " ".

* generate layers .
compute waPercentBelow = 1 .
compute haPercentBelow = 1 .
compute whPercentBelow = 1 .
compute whAbove = 1 .
compute underweight = 1 .
compute stunted = 1 .
compute wasted = 1 .
compute overweight = 1 .
compute weightForAge = 1 .
compute heightForAge = 1 .
compute weightForHeight = 1 .

value labels
  weightForAge 1 'Weight for age'/
  heightForAge 1 'Height for age'/
  weightForHeight 1 'Weight for height'/
  waPercentBelow haPercentBelow whPercentBelow 1 'Percent below'/
  whAbove 1 'Percent above'/
  underweight 1 'Underweight'/
  stunted 1 'Stunted'/
  wasted 1 'Wasted'/
  overweight 1 'Overweight' .

recode cage
  (0 thru 5 = 1)
  (6 thru 11 = 2)
  (12 thru 17 = 3)
  (18 thru 23 = 4)
  (24 thru 35= 5)
  (36 thru 47= 6)
  (else = 7) into childAge7.
variable labels childAge7 "Age (in months)".

value labels childAge7
  1 "0-5"
  2 "6-11"
  3 "12-17"
  4 "18-23"
  5 "24-35"
  6 "36-47"
  7 "48-59".

variable labels caretakerdis "Mother's functional difficulties [B]".
/* this is the beggining of recoding of table SR.10.1W and SR.10.3W in a background variables for tobacco and alcohol use tables
/***************************************************************************************************************************************************************************************************************/.
* Smoking mothers ever.
* Not users: (TA1=2 or (TA1=2 and TA2=00)) and TA6=2 and TA10=2.
compute eversmoke = 99.
if ((TA1=2 or (TA1=1 and TA2=00)) and TA6=2 and TA10=2) eversmoke = 10.
if ((TA2 > 00 and TA2 < 97) or TA6 = 1 and TA10 =1)  eversmoke = 20.
variable labels eversmoke "Ever users".
value labels eversmoke  10 "Never smoked cigarettes or used other tobacco products"
                                      20 "Any tobacco product"
                                      99 "DK/Missing".
compute eversmokeany = 0.
if (TA2 > 00 and TA2 < 97 and TA6 <> 1 and TA10 <> 1)  eversmokeany = 21.
if (TA2 > 00 and TA2 < 97 and (TA6 = 1 or TA10 = 1))  eversmokeany = 22.
if (TA2 = 00 or TA2 >= 97 and (TA6 = 1 or TA10 = 1))  eversmokeany = 23.
variable labels eversmokeany "".
value labels eversmokeany 
                                      21 "   Only cigarettes"
                                      22 "   Cigarettes and other tobacco products"
                                      23 "   Only other tobacco products".
mrsets
  /mcgroup name = $eversmoke
           label = "Ever tobacco product users"
           variables = eversmoke eversmokeany.


* Only cigarettes during last month.

compute monthsmoke =99.
if ((TA1 = 2 or (TA1 = 1 and TA2 = 00) or TA3 = 2 or (TA4 = 00 and TA5 = 00)) and (TA6 = 2 or TA7 = 2)) monthsmoke = 10.
if (((TA4>00 and TA4<97) or (TA5>00 and TA5<97)) or (TA9>00 and TA9<97) or (TA13>00 and TA13<97)) monthsmoke = 20.
variable labels monthsmoke "Last month users".
value labels monthsmoke  10 "Not smoked cigarettes or used other tobacco products in the last month"
                                          20 "Used any tobacco product in the last month"
                                          99 "DK/Missing".
compute monthsmokeany = 0.
if (((TA4>00 and TA4<97) or (TA5>00 and TA5<97)) and ((TA9=00 and TA9 >= 97)) or ((TA13>00 and TA13>= 97))) monthsmokeany = 21.
if (((TA4>00 and TA4<97) or (TA5>00 and TA5<97)) and (TA9>00 and TA9<97) or (TA13>00 and TA13<97)) monthsmokeany = 22.
if (((TA4=00 and TA4>=97) or (TA5=00 and TA5>=97)) and (TA9=00 and TA9>=97) or (TA13=00 and TA13>=97)) monthsmokeany = 23.
value labels monthsmokeany 21 "    Only cigarettes"  22"    Cigarettes and other tobacco products" 23 "    Only other tobacco products".

mrsets
  /mcgroup name = $monthsmoke
           label = "Tobacco product users during last month"
           variables = monthsmoke monthsmokeany.

 
* Use of alcohol. 
 compute noalcohol = 2.
if (TA14 = 2 or (TA14=1 and TA15=0)) noalcohol = 1.
variable labels noalcohol "Usage of alcoholic drinks by mothers/caretakers".   
value labels noalcohol 1 "Never had alcoholic drink"  2 " Had alcoholic drink"   .

compute atLeastOne = 2.
if (TA16 > 0 and TA16 < 97) atLeastOne = 1.
variable labels atLeastOne "Usage of alcoholic drinks by mothers/caretakers in the last month".
value labels atLeastOne 1 "Had at least one alcoholic drink at any time during the last one month"  2 "Did not have alcoholic drink during last month" .
/* this is the end of recoding of table SR.10.1W and SR.10.3W in a background variables
/***************************************************************************************************************************************************************************************************************/.
* Ctables command in English.
ctables
  /vlabels variables = weightForAge heightForAge weightForHeight
                       waPercentBelow haPercentBelow whPercentBelow whAbove
                       underweight stunted wasted overweight
           display=none
  /table   total [c]
         + $monthsmoke [c]
         + $eversmoke [c]
         + atLeastOne [c]
         + noalcohol [c]
     by
           weightForAge [c] > (
             underweight [c] >
               waPercentBelow [c] > (
                 wa2sd [s] [mean f5.1]
               + wa3sd [s] [mean f5.1] )
           + waMean [s] [mean f5.1] )
         + waCount [s] [validn f5.0]
         + heightForAge [c] > (
             stunted [c] >
               haPercentBelow [c] > (
                 ha2sd [s] [mean f5.1]
               + ha3sd [s] [mean f5.1] )
           + haMean [s] [mean f5.1] )
         + haCount [s] [validn f5.0]
         + weightForHeight [c] > (
             wasted [c] >
               whPercentBelow [c] > (
                 wh2sd [s] [mean f5.1]
               + wh3sd [s] [mean f5.1] )
           + overweight [c] >
               whAbove [c] >
                 (wh2sdAbove [s] [mean f5.1]
               + wh3sdAbove [s] [mean f5.1])
           + whMean [s] [mean f5.1] )
         + whCount [s] [validn f5.0]
  /categories variables=all empty=exclude missing=exclude
  /slabels visible = no
  /titles title=
     "FA Table HN.1.1: Nutritional status of children - Linkages with Tobbaco and Alcohol Use"
     "Percentage of children under age 5 by nutritional status according to three anthropometric " +
     "indices: weight for age, height for age, and weight for height," + surveyname
   caption=
     "[1] MICS indicator TC.44a - Underweight prevalence (moderate and severe)"
     "[2] MICS indicator TC.44b - Underweight prevalence (severe)"
     "[3] MICS indicator TC.45a - Stunting prevalence (moderate and severe); SDG indicator 2.2.1"
     "[4] MICS indicator TC.45b - Stunting prevalence (severe)"
     "[5] MICS indicator TC.46a - Wasting prevalence (moderate and severe); SDG indicator 2.2.2"
     "[6] MICS indicator TC.46b - Wasting prevalence (severe)"
     "[7] MICS indicator TC.47a - Overweight prevalence (moderate and severe); SDG indicator 2.2.2"
     "[8] MICS indicator TC.47b - Overweight prevalence (severe)" 
     "[A] Denominators for weight for age, height for age, and weight for height may be different. " +
      "Children are excluded from one or more of the anthropometric indicators when their weights and heights " +
     "have not been measured or are implausible (flagged), or their age is not available, whichever applicable. See Appendix D: Data quality, Tables DQ.3.4-6."
.

new file.
erase file = "tmp.sav".
erase file = "tmpTA.sav".
erase file = "ch2.sav".
