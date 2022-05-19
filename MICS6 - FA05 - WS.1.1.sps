* Encoding: UTF-8.
* Further analysis table for Pacific MICS Surveys.


include "surveyname.sps".

get file = 'hh.sav'.

sort cases by HH1 HH2 .

save outfile = 'tmp.sav'
  /keep HH1 HH2 ST2$1 ST2$2 ST2$3 ST2$4 ST2$5 ST3$1 ST3$2 ST3$3 ST3$4 ST3$5.

* Open women dataset.
get file = 'wm.sav'.

sort cases by HH1 HH2.

match files
  /file = "wm.sav"
  /table = "tmp.sav"
  /by HH1 HH2.
save outfile 'wm_wght.sav'.

get file = 'wm_wght.sav'.
include "CommonVarsWM.sps".

* Select completed interviews.
select if (WM17 = 1).

* Select women who reported menstruating in the last 12 months.
select if (not(sysmis(UN16))).

* Weight the data by the women weight.
weight by wmweight.

* Generate numWomen variable.
compute numWomen = 1.
variable labels numWomen "".
value labels numWomen 1 "Number of women who reported menstruating in the last 12 months".

compute amaterialre=0.
if UN19=1  amaterialre=100.
variable labels amaterialre "Reusable".

compute amaterialnonre=0.
if UN19=2  amaterialnonre=100.
variable labels amaterialnonre "Not reusable".

compute amaterialDKmissing=0.
if UN19>=8  amaterialDKmissing=100.
variable labels amaterialDKmissing "DK whether reusable/Missing".

compute materialother=0.
if UN18=2  materialother=100.
variable labels materialother "Other/No materials".

compute materialDK=0.
if UN18>=8  materialDK=100.
variable labels materialDK "DK/Missing".

compute appropriatematerial=0.
if UN18=1  appropriatematerial=100.
variable labels appropriatematerial "Percentage of women using appropriate materials for menstrual management during last menstruation".

compute privateplace=0.
if UN17=1  privateplace=100.
variable labels privateplace "Percentage of women with a private place to wash and change while at home".

compute totalprct=100.
variable labels totalprct "Total".

compute materialprivateplace=0.
if (privateplace=100 and UN18=1) materialprivateplace=100.
variable labels materialprivateplace "Percentage of women using appropriate menstrual hygiene materials with a private place to wash and change while at home [1]".

variable labels disability "Functional difficulties (age 18-49 years)".

compute layer0 = 0.
variable labels layer0 "".
value labels layer0 0 "Percent distribution of women by use of materials during last menstruation".

compute layer1 = 0.
variable labels layer1 "".
value labels layer1 0 "Appropriate materials [A]".

compute total = 1.
variable labels total "".
value labels total 1 "Total".


/* this is the beggining of recoding of table EQ.2.7 in a background variables for assistance with social transfer programs
/***************************************************************************************************************************************************************************************************************/.
compute awareEAP=9.
if (ST2$1=1 or ST2$2=1 or ST2$3=1 or ST2$4=1 or ST2$5=1) awareEAP=1.
if not(ST2$1=1 or ST2$2=1 or ST2$3=1 or ST2$4=1 or ST2$5=1) awareEAP=2.
variable labels awareEAP "Household awareness of economic assistance programmes".
value labels awareEAP 1 "Household aware of economic assistance programmes" 2 "Household not aware of economic assistance programmes" 9 "DK/Missing".

compute receivedEAP=9.
if (awareEAP=1 and (ST3$1=1 or ST3$2=1 or ST3$3=1 or ST3$4=1 or ST3$5=1)) receivedEAP=1.
if (not(awareEAP=1 and (ST3$1=1 or ST3$2=1 or ST3$3=1 or ST3$4=1 or ST3$5=1))) receivedEAP=2.
variable labels receivedEAP "Household awareness and receipency of assistance/ external economic support".
value labels receivedEAP 1 "Household aware and received assistance/ external economic support" 2 "Household not aware and received assistance/ external economic support" 9 "DK/Missing".

/* this is the end of recoding of table EQ.2.7 in  background variables
/***************************************************************************************************************************************************************************************************************/.


* Ctables command in English.
ctables
  /vlabels variables =  numWomen layer0 layer1 total
         display = none
  /table   total [c]
        + awareEAP [c]
        + receivedEAP 
      by
        layer0 [c] > ( layer1 [c] > (amaterialre [s] [mean '' f5.1] + amaterialnonre [s] [mean '' f5.1]  + amaterialDKmissing [s] [mean '' f5.1])   + materialother [s] [mean '' f5.1]  + materialDK [s] [mean '' f5.1]+ totalprct [s] [mean '' f5.1] )
         + appropriatematerial [s] [mean '' f5.1]+ privateplace [s] [mean '' f5.1]+ materialprivateplace [s] [mean '' f5.1]
         + numWomen[c][count '' f5.0]
  /categories variables=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title=
     "FA Table WS.1.1: Menstrual hygiene management - Linkages with Social Transfers Coverage"
     "Percent distribution of women age 15-49 years by use of materials during last menstruation, percentage using appropriate materials, percentage with a private place to wash and change while at home " +
     "and percentage of women using appropriate menstrual hygiene materials with a private place to wash and change while at home,  "
     + surveyname
   caption =
        "[1] MICS indicator WS.12 - Menstrual hygiene management"
        "[A] Appropriate materials include sanitary pads, tampons or cloth".									
								

new file.
erase file = 'wm_wght.sav'.
erase file = 'tmp.sav'.
