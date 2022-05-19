* Encoding: UTF-8.
* Further analysis table for Pacific MICS Surveys. 


include "surveyname.sps".
* open women data file.
get files="wm.sav".

include "CommonVarsWM.sps".

* select completed questionnaires, and women selected for domestinc violence.
select if (WM17 = 1 and sysmis (DVD1)=0 and DVD1 = 1 and wb4<=19).

weight by dvweight.

* create total row.
compute total = 1.
variable labels total "Total".
value labels total 1" ".

********************DHS.
*
"PROGRAMMING Table DV6: 
Denominator
All women 

 * Numerator
Column 1: 
-Ever-married women who say (YES to one or more items DV05A (a-g) OR DV15A (a) OR DV16 OR DV20) AND (NO to all three DV05A (h-j) AND DV15A(b) AND DV22A);
 -Never married women who say (YES to DV16 OR DVD20) AND (NO to DV22B).

 * Column 2: 
-Ever-married women who say (YES to one or more DV05A (h-j) OR YES to DV15A(b) OR YES to DV22A) AND (NO to all items DV05A (a-g ) AND DV15A(a) AND DV16 AND DVD20) 
-Never married women who say (YES to DV22B) AND (NO to DV16 AND DVD20).

 * Column 3: 
-Ever-married women who say (YES to one or more items DV05A (a-g ) OR DV15A(a) OR DV16, OR DVD20) AND (YES to one or more items DV05A (h-j) OR DV15A(b) OR DV22A);
 -Never married women who say (YES to DV16 OR DVD20) AND (YES to DV22B).

 * Column 4: 
-Ever-married women who say (YES to one or more items DV05A (a-g ) OR DV15A (a) OR DV16 OR DVD20 OR YES to one or more items DV05A (h-j) OR DV15A(b) OR DV22A);
 -Never married women who say (YES to DV16 OR DVD20 OR DV22B)


********************MICS.
*
"PROGRAMMING Table DV6: 
Denominator
All women 

 * Numerator
Column 1: 
-Ever-married women who say (YES to one or more items  DVD5 (a-g), DVD15A(a), DVD16, OR DVD20 AND (NO to all DVD5 (h,i, or j) AND DVD15A(b)  AND DVD22A );
 -Never married women who say (YES to DVD16, OR DVD2 AND (NO to DVD22B).

 * Column 2: 
-Ever-married women who say (YES to one or more DVD5 (h-j) OR YES to DVD15A(b) OR YES to DVD22A) AND (NO to all items DVD5 (a-g ) AND DVD15A(a) AND DVD16 AND DVD20) 
-Never married women who say (YES to DVD22B) AND (NO to DVD16 AND DVD20).

 * Column 3: 
-Ever-married women who say (YES to one or more items DV05A (a-g ) OR DV15A(a) OR DV16, OR DVD20) AND (YES to one or more items DV05A (h-j) OR DV15A(b) OR DV22A);
 -Never married women who say (YES to DVD16 OR DVD20) AND (YES to DV22B).

 * Column 4: 
-Ever-married women who say (YES to one or more items DV05A (a-g ) OR DV15A (a) OR DV16 OR DVD20 OR YES to one or more items DV05A (h-j) OR DV15A(b) OR DV22A);
 -Never married women who say (YES to DV16 OR DVD20 OR DV22B).


compute physical =0.
if (DVD5A = 1 or DVD5B = 1 or DVD5C = 1 or DVD5D = 1 or DVD5E = 1 or DVD5F = 1 or DVD5G = 1 or DVD15A = 1 or DVD16 = 1 or DVD20 = 1
    or DVD16=1) physical=1.

compute sexual=0.
if (DVD5H = 1 or DVD5I = 1 or DVD5J = 1 or DVD15B = 1 or DVD22A = 1 or DVD22B =1 ) sexual=1.

compute sexVonly=0.
if sexual=1 and physical=0 sexVonly=100.

compute physonly = 0.
if sexual=0 and physical=1 physonly=100.

compute bothV = 0.
if sexual=1 and physical=1 bothV=100.

compute eitherV = 0.
if sexual=1 or physical=1 eitherV=100.

variable labels physonly "Physical violence only".
variable labels sexVonly "Sexual violence only".
variable labels bothV "Physical and sexual violence".
variable labels eitherV "Physical or sexual violence".


/* this is the beggining of recoding of table PR.8.1W in a background variables for domestic violence table
/***************************************************************************************************************************************************************************************************************/.
compute goesOut = 8.
if (DV1A = 1) goesOut = 1.
if (DV1A = 2) goesOut = 2.
variable labels goesOut "If she goes out without telling him".

compute neglectsKids = 8.
if (DV1B = 1) neglectsKids = 1.
if (DV1B = 2) neglectsKids = 2.
variable labels neglectsKids "If she neglects the children".

compute sheArgues = 8.
if (DV1C = 1) sheArgues = 1.
if (DV1C = 2) sheArgues = 2.
variable labels sheArgues "If she argues with him".

compute refusesSex = 8.
if (DV1D = 1) refusesSex = 1.
if (DV1D = 2) refusesSex = 2.
variable labels refusesSex "If she refuses sex with him".

compute burnsFood = 8.
if (DV1E = 1) burnsFood = 1.
if (DV1E = 2) burnsFood = 2.
variable labels burnsFood "If she burns the food".
exe.
compute comesLate = 8.
if (DV1F = 1) comesLate = 1.
if (DV1F = 2) comesLate = 2.
variable labels comesLate "Comes home late".

compute anyReason = 2.
if (any(1, DV1A, DV1B, DV1C, DV1D, DV1E)) anyReason = 1.
variable labels anyReason "For any of these five reasons [1]".

value labels goesOut neglectsKids sheArgues refusesSex burnsFood comesLate anyReason 
    1 "Beating is justified"
    2 "Beating is not justified"
    8 "DK/Missing".

/* this is the end of recoding of table PR.8.1W in a background variables
/***************************************************************************************************************************************************************************************************************/.

compute nwm = 1.
value labels nwm 1 "Number of women age 15-19".
variable labels nwm "".
	
ctables
  /vlabels variables =  nwm  
           display = none
  /table  total [c]
          + goesOut [c]
          + neglectsKids [c]
          + sheArgues [c]
          + refusesSex [c]          
          + burnsFood [c]
          + comesLate [c]
          + anyReason [c]
         by
        physonly [s] [mean,'',f5.1] + sexVonly [s] [mean,'',f5.1] + bothV [s][mean,'',f5.1] + eitherV [s][mean,'',f5.1] +
         nwm [c] [count,'',f5.0]
  /categories var=all empty=exclude missing=exclude 
  /slabels position=column visible = no
  /titles title=
                  "FA Table CP.3.1: Violence by Any Perpetrator-  Linkage with Attitudes Towards Wife Beating"			
                  "Percentage of women age 15-19 who have ever experienced different forms of violence by attitudes toward wife beating, " + surveyname 			
.		

new file.


