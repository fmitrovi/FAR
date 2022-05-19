* Encoding: UTF-8.
* Further analysis table for Pacific MICS Surveys. 

include "surveyname.sps".

get file = 'wm.sav'.

select if (WM17 = 1 and DVD1 = 1 ).

weight by wmweight.

recode CM11 (sysmis = 0) .

do if (WB4 >=15 and WB4<=19).
+ compute numWoman15 = 1.
+ compute hadBirth = 0.
+ if (CM11 > 0) hadBirth = 100.
+ compute firstChild = 0.
+ if (hadBirth = 0 and CP1 = 1) firstChild = 100.
+ compute begunChildbearing = 0.
+ if (hadBirth = 100 or CP1 = 1) begunChildbearing  = 100.
+ compute birthBefore15 = 0.
+ if ((wdobfc - wdob)/12 < 15) birthBefore15 = 100.
end if.

variable labels
   numWoman15 "Number of women age 15-19 years"
  /hadBirth "Have had a live birth"
  /firstChild "Are pregnant with first child"
  /begunChildbearing "Have had a live birth or are pregnant with first child"
  /birthBefore15 "Have had a live birth before age 15"
  .

do if (WB4 >=20 and WB4 <= 24).
+ compute numWoman20 = 1.
+ compute birthBefore18 = 0.
+ if ((wdobfc - wdob)/12 < 18) birthBefore18 = 100.
end if.

variable labels
   numWoman20 "Number of women age 20-24 years"
  /birthBefore18 "Percentage of women age 20-24 years who have had a live birth before age 18 [1]"
  .

compute layer = 0.
value labels layer 0 "Percentage of women age 15-19 years who:".
variable labels layer " ".

compute total = 1.
variable labels total "Total".
value labels total 1" ".

/* this is the beggining of recoding of table DV.1.9 in a background variables for child labour table
/***************************************************************************************************************************************************************************************************************/.
compute sexviol = 2.
if ((DVD5H = 1 or DVD5I = 1 or DVD5J = 1) or DVD15B = 1 or DVD22A = 1 or DVD22B = 1) sexviol = 1.
variable labels sexviol "Experience of sexual violence".
value labels sexviol 1 "Ever experienced sexual violence" 2 "Never experienced sexual violence" .

compute sexviol12 = 2.
if ((DVD5H1 <= 2 or DVD5I1 <= 2 or DVD5J1 <= 2) or DVD15B1 = 1 or DVD24 = 1) sexviol12 = 1.
variable labels sexviol12 "Experience of sexual violence in last 12 months".
value labels sexviol12 1 "Experienced sexual violence in last 12 months" 2 "Did not experience sexual violence in last 12 months".

compute violence15 = 2.
if ((DVD5A = 1 or DVD5B = 1 or DVD5C = 1 or DVD5D = 1 or DVD5E = 1 or DVD5F = 1 or DVD5G = 1) or DVD15A = 1 or DVD16 = 1 or DVD20 = 1) violence15 = 1.
variable labels violence15 "Percentage who have experienced physical violence since age 15-17".
value labels violence15 1 "Ever experienced physical violence" 2 "Never experienced physical violence" .

compute v12Often = 20.
if ((DVD5A1 = 1 or DVD5B1 = 1 or DVD5C1 = 1 or DVD5D1 = 1 or DVD5E1 = 1 or DVD5F1 = 1 or DVD5G1 = 1) or DVD18 = 1) v12Often = 11.
variable labels v12Often "Often".

compute v12Smt = 20.
if (((DVD5A1 <> 1 and DVD5B1 <> 1 and DVD5C1 <> 1 and DVD5D1 <> 1 and DVD5E1 <> 1 and DVD5F1 <> 1 and DVD5G1 <> 1) and 
    (DVD5A1 = 2 or DVD5B1 = 2 or DVD5C1 = 2 or DVD5D1 = 2 or DVD5E1 = 2 or DVD5F1 = 2 or DVD5G1 = 2)) or
    DVD18 = 2)  v12Smt = 12.
variable labels v12Smt "Sometimes".

compute v12Any = 20.
if (v12Often = 11 or v12Smt = 12 or DVD15A1 = 1) v12Any = 10.
variable labels v12Any "Often or sometimes".

value labels v12Any
    10 "Experience of physical violence often or sometimes in last 12 months"
    11 "   Often "
    12 "   Sometimes "
    20  "No experience of physical violence often or sometimes in last 12 months".

mrsets
  /mcgroup name = $v12Any
           label = 'Experience of physical violence in last 12 months'
           variables = v12Any v12Often v12Smt.


/* this is the end of recoding of table DV.1.9 in a background variables
/***************************************************************************************************************************************************************************************************************/.
* Ctables command in English.
ctables
  /vlabels variables = layer
           display = none
  /table   total [c]
         + sexviol [c]
         + sexviol12 [c]
         + violence15 [c]
         + $v12Any [c]
   by
           layer [c] > (
             hadBirth [s] [mean '' f5.1]
           + firstChild [s] [mean '' f5.1]
           + begunChildbearing [s] [mean '' f5.1]
           + birthBefore15 [s] [mean '' f5.1] )
         + numWoman15 [s] [sum '' f5.0]
         + birthBefore18 [s] [mean '' f5.1]
         + numWoman20 [s] [sum '' f5.0]
  /slabels position=column visible =no
  /categories variables=all empty=exclude missing=exclude
  /titles title=
                 "FA Table CP.5.2: Early childbearing (young women)- Linkages with Sexual Violence "						
                 "Percentage of women age 15-19 years who have had a live birth, are pregnant with the first child, have had a live birth or are pregnant with first child, "+
                 "and who have had a live birth before age 15, and percentage of women age 20-24 years who have had a live birth before age 18, " + surveyname
  .
  
new file.
