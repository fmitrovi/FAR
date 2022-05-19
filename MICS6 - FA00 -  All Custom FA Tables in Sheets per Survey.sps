* Encoding: UTF-8.
* Add the working directory if needed, e.g. cd "C:\MICS6\SPSS". or remove to use the default directory.

set tnumbers = labels /tvars = labels /ovars = labels.

oms
 /destination viewer = no
 /select all except = tables.
output close *.

* macro to save the output as the sheet in appropriate workbook /* SAM for Samoa, FJI for Fiji, KIR for Kiribati, TUV for Tuvalu and TON for Tonga.
define saveSheet(!positional !tokens(1))
!let !n = !unquote(!1) .
!let !sheet = !quote(!tail(!tail(!n))) .
!if (!substr(!n,1,2)="DQ") !then .
!let !sheet = !1 . 
!ifend .
!if (!substr(!n,1,2)="SE") !then .
!let !sheet = !quote(!substr(!n,4))
!ifend .
output export 
/xlsx documentfile = !quote(!concat("MICS6 Country Further Analysis - 22Feb22 -",!substr(!n,1,!index(!n,".")),"xlsx")) 
sheet=!sheet
operation=MODIFYSHEET
/contents export = visible layers = printsetting modelviews = printsetting.
output close * .
!enddefine .

* Run Section 1 with Child Protection (CP) further analysis tables.
insert file =  'MICS6 - FA01 - CP.1.1.sps' .
saveSheet             'FA01 - CP.1.1' .
insert file =  'MICS6 - FA01 - CP.1.2.sps' .
saveSheet             'FA01 - CP.1.2' .
insert file =  'MICS6 - FA01 - CP.1.3.sps' .
saveSheet             'FA01 - CP.1.3' .
insert file =  'MICS6 - FA01 - CP.1.4.sps' .
saveSheet             'FA01 - CP.1.4' .
insert file =  'MICS6 - FA01 - CP.1.5.sps' .
saveSheet             'FA01 - CP.1.5' .
insert file =  'MICS6 - FA01 - CP.2.1.sps' .
saveSheet             'FA01 - CP.2.1' .
insert file =  'MICS6 - FA01 - CP.3.1.sps' .
saveSheet             'FA01 - CP.3.1' .
insert file =  'MICS6 - FA01 - CP.3.2sps' .
saveSheet             'FA01 - CP.3.2' .
insert file =  'MICS6 - FA01 - CP.3.3.sps' .
saveSheet             'FA01 - CP.3.3' .
insert file =  'MICS6 - FA01 - CP.4.1.sps' .
saveSheet             'FA01 - CP.4.1' .
insert file =  'MICS6 - FA01 - CP.4.2.sps' .
saveSheet             'FA01 - CP.4.2' .
insert file =  'MICS6 - FA01 - CP.4.3.sps' .
saveSheet             'FA01 - CP.4.3' .
insert file =  'MICS6 - FA01 - CP.5.1.sps' .
saveSheet             'FA01 - CP.5.1' .
insert file =  'MICS6 - FA01 - CP.5.2.sps' .
saveSheet             'FA01 - CP.5.2' .
insert file =  'MICS6 - FA01 - CP.6.1.sps' .
saveSheet             'FA01 - CP.6.1' .

* Run Section 2 with Health and Nutrition (NH) further analysis tables.
insert file =  'MICS6 - FA02 - HN.1.1.sps' .
saveSheet             'FA02 - HN.1.1' .
insert file =  'MICS6 - FA02 - HN.1.2.sps' .
saveSheet             'FA02 - HN.1.2' .
insert file =  'MICS6 - FA02 - HN.1.3.sps' .
saveSheet             'FA02 - HN.1.3' .
insert file =  'MICS6 - FA02 - HN.1.4.sps' .
saveSheet             'FA02 - HN.1.4' .
insert file =  'MICS6 - FA02 - HN.1.5.sps' .
saveSheet             'FA02 - HN.1.5' .
insert file =  'MICS6 - FA02 - HN.1.6.sps' .
saveSheet             'FA02 - HN.1.6' .
insert file =  'MICS6 - FA02 - HN.1.7.sps' .
saveSheet             'FA02 - HN.1.7' .
insert file =  'MICS6 - FA02 - HN.1.8.sps' .
saveSheet             'FA02 - HN.1.8' .
insert file =  'MICS6 - FA02 - HN.1.9.sps' .
saveSheet             'FA02 - HN.1.9' .

* Run Section 3 with Education (ED) further analysis tables.
insert file =  'MICS6 - FA03 - ED.1.1.sps' .
saveSheet             'FA03 - ED.1.1' .
insert file =  'MICS6 - FA03 - ED.1.2.sps' .
saveSheet             'FA03 - ED.1.2' .
insert file =  'MICS6 - FA03 - ED.1.3.sps' .
saveSheet             'FA03 - ED.1.3' .
insert file =  'MICS6 - FA03 - ED.1.4.sps' .
saveSheet             'FA03 - ED.1.4' .
insert file =  'MICS6 - FA03 - ED.1.5.sps' .
saveSheet             'FA03 - ED.1.5' .
insert file =  'MICS6 - FA03 - ED.2.1.sps' .
saveSheet             'FA03 - ED.2.1' .
insert file =  'MICS6 - FA03 - ED.2.2.sps' .
saveSheet             'FA03 - ED.2.2' .
insert file =  'MICS6 - FA03 - ED.2.3.sps' .
saveSheet             'FA03 - ED.2.3' .
insert file =  'MICS6 - FA03 - ED.4.1.sps' .
saveSheet             'FA03 - ED.4.1' .
insert file =  'MICS6 - FA03 - ED.5.1.sps' .
saveSheet             'FA03 - ED.5.1' .
insert file =  'MICS6 - FA03 - ED.6.1.sps' .
saveSheet             'FA03 - ED.6.1' .
insert file =  'MICS6 - FA03 - ED.6.2.sps' .
saveSheet             'FA03 - ED.6.2' .
insert file =  'MICS6 - FA03 - ED.7.1.sps' .
saveSheet             'FA03 - ED.7.1' .

* Run Section 4 with Early childhood Development (ECD) further analysis tables.
insert file =  'MICS6 - FA04 - ECD.1.1.sps' .
saveSheet             'FA04 - ECD.1.1' .

* Run Section 5 with WASH (WS) further analysis tables.
insert file =  'MICS6 - FA05 - WS.1.1.sps' .
saveSheet             'FA05 - WS.1.1' .

omsend.

