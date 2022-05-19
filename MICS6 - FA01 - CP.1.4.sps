* Encoding: UTF-8.
* Further analysis table for Pacific MICS Surveys. 


include "surveyname.sps".

* Merging needed variables from wm dataset to be analysed with child labour variable.
get file = 'wm.sav'.
save outfile = "tmpdvd.sav" /keep HH1 HH2 WM3 DVD1 DVD5H DVD5I DVD5J DVD15B DVD22A DVD22B DVD5H1 DVD5I1 DVD5J1 DVD15B1 DVD24 DVD5A DVD5B DVD5C DVD5D DVD5E DVD5F DVD5G DVD15A DVD16 DVD20 DVD18 DVD5A1 DVD5B1 DVD5C1 DVD5D1 DVD5E1 DVD5F1 DVD5G1 DVD15A1
     /rename WM3 = FS3.
new file.


get file = 'fs.sav'.

match files
  /file = *
  /table = 'tmpdvd.sav'
  /by HH1 HH2 FS3.


include "CommonVarsFS.sps".
select if (FS17 = 1 and DVD1 = 1 ).
select if (CB3>=15 and CB3<=17 and hl4=2).

weight by fsweight.

* definitions of econcomic activity variables  (ea1more, ea14less, ea14more, ea43less, ea43more) .
include 'define\MICS6 - 09 - PR.sps' .

variable labels
   eaLess "Below the age specific threshold"
  /eaMore "At or above the age specific threshold"
  /hhcLess "Below the age specific threshold"
  /hhcMore "At or above the age specific threshold"
  /childLabor "Total child labour [1] [A]" .

compute layerEA = 1 .
compute layerHHC = 1 .
compute numChildren = 1 .

value labels
   layerEA   1 "Adolescent girls involved in economic activities for a total number of hours during last week:"
  /layerHHC  1 "Adolescent girls involved in household chores for a total number of hours during last week:"
  /numChildren 1 "Number of adolescent girls age 15-17 years"
  .

recode CB3 (5 thru 11 = 1) (12 thru 14 = 2) (15 thru 17 = 3) into ageGroup .
variable labels ageGroup "Age" .
value labels ageGroup
1 "5-11"
2 "12-14"  
3 "15-17".
formats ageGroup (f1.0).

compute total = 1.
variable labels total "Total".
value labels total 1 " ".

variable labels schoolAttendance "School attendance".
value labels schoolAttendance 1 "Attending [B]" 2 "Not attending" .
variable labels fsdisability "Child's functional difficulties".
variable labels melevel "Mother’s education [C]".
variable labels caretakerdis "Mother's functional difficulties [D]".

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


recode CB7 (1 = 1) (9 = 8) (else = 2) into schoolAttendance.
variable labels schoolAttendance "School attendance".
value labels schoolAttendance 1 "Attending" 2 "Not attending" 8 "Missing".

/* this is the end of recoding of table DV.1.9 in a background variables
/***************************************************************************************************************************************************************************************************************/.
* Ctables command in English.
ctables
  /vlabels variables = numChildren layerEA layerHHC
           display = none
  /table   total [c]
         + sexviol [c]
         + sexviol12 [c]
         + violence15 [c]
         + $v12Any [c]
         + schoolAttendance [c]
   by
           layerEA [c] > (
             ealess[s] [mean '' f5.1]
           + eaMore[s] [mean '' f5.1] )
         + layerHHC [c] > (
             hhcLess[s] [mean '' f5.1]
           + hhcMore[s] [mean '' f5.1] )
         + childLabor [s] [mean '' f5.1]
         + numChildren [c] [count '' f5.0]
  /categories variables=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title=
     "FA.Table CP.1.4: Child labour - Linkages with Sexual Violence"
      "Percentage of adolescent girls age 15-17 years by involvement in economic activities or household chores during the last week and percentage engaged in child labour during the previous week"
       + surveyname
  .			
new file.

erase file = "tmpdvd.sav".
