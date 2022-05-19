* Encoding: UTF-8.
* Further analysis table for Pacific MICS Surveys. Syntax written based on Fiji MICS variable. 

*include "surveyname.sps".
get file = 'ch.sav'.

* Generating age groups.
recode UB2 (0 thru 1 = 1) (2 thru 4 = 2) into ageGr.
variable labels ageGr 'Age'.
value labels ageGr 1 '0-1' 2 '2-4'.

* there is childAge6 that we could use? .
recode cage (lo thru 5 = 1) (6 thru 11 = 2) (12 thru 23 = 3) into ageCat.
variable labels ageCat "Age (in months)".
value labels ageCat 1 "0-5" 2 "6-11" 3 "12-23".

* Auxilary table variables .
recode cage (6, 7, 8 = 1) (9, 10, 11 = 2) (12 thru 17 = 3) (else = 4) into ageCatz.
variable labels ageCatz "Age (in months)".
value labels ageCatz 1 "6-8" 2 "9-11" 3 "12-17" 4 "18-23".
*include "CommonVarsCH.sps".

select if (UF17 = 1).

select if (cage >= 6  and cage <= 23).


*weight by chweight.

*variables per food group

compute grains = any(1, BD8C) .
compute beans = any(1, BD8M) .
compute eggs = any(1, BD8K) .
compute dairyProducts = any(1, BD7E, BD8A) .
compute cheese = any(1, BD8N). 
compute fleshFoods = any(1, BD8I, BD8J, BD8L) .
compute vitaminA = any(1, BD8D, BD8F, BD8G) .
compute other = any(1, BD8H) .

variable labels grains "Cereals [A]".
variable labels beans "Beans [B]".
variable labels eggs "Eggs".
variable labels dairyProducts "Milk/dairy [C]".
variable labels cheese  "Cheese or other food from animal milk [D]".
variable labels  fleshFoods "Meat/fish/poultry [E]".
variable labels vitaminA "Vit A rich fruits [F]".
variable labels other  "Other fruits and vegetables [G]".

* multiplay by 100 to obtain percents .

compute grains = 100*grains.
compute beans = 100* beans.
compute eggs = 100* eggs.
compute dairyProducts = 100* dairyProducts.
compute cheese = 100* cheese. 
compute fleshFoods = 100* fleshFoods.
compute vitaminA = 100* vitaminA.
compute other = 100* other .

compute layer1 = 0.
variable labels layer1 "".
value labels layer1 0 "Percentage of children consuming:".

compute numChildren = 1.
variable labels numChildren "".
value labels numChildren 1 "Number of children".

compute total = 1.
variable labels total "".
value labels total 1 "Total".

/* this is the beggining of recoding of table TC.8.1 in a background variables for nutritional status of children
/***************************************************************************************************************************************************************************************************************/.
compute underweight2sd =9. 
if (wazflag=0 and WAZ2<-2) underweight2sd=1.
if (wazflag=0 and WAZ2>=-2) underweight2sd=2.

variable labels underweight2sd 'Underweight'.
value labels underweight2sd
                     1 'Moderately or severly underweight child'
                     2  'Not a moderately or severly underweight child'
                     9 "DK/missing".    

compute stunted2sd =9. 
if (hazflag=0 and HAZ2<-2) stunted2sd=1.
if (hazflag=0 and HAZ2>=-2) stunted2sd=2.
variable labels stunted2sd 'Stunted'.
value labels stunted2sd
                     1 'Moderately or severly stunted child'
                     2  'Not a moderately or severly stunted child'
                     9 "DK/missing".      

compute wasted2sd =9. 
if (whzflag=0 and WHZ2<-2) wasted2sd=1.
if (whzflag=0 and WHZ2>=-2) wasted2sd=2.
variable labels wasted2sd 'Wasted'.
value labels wasted2sd
                     1 'Moderately or severly wasted child'
                     2  'Not a moderately or severly wasted child'
                     9 "DK/missing".      

compute overweight2sd =9. 
if (whzflag=0 and WHZ2<2) overweight2sd=1.
if (whzflag=0 and WHZ2>=2) overweight2sd=2.
variable labels overweight2sd 'Overweight'.
value labels overweight2sd
                     1 'Moderately or severly overweight child'
                     2  'Not a moderately or severly overweight child'
                     9 "DK/missing".     


/* this is the end of recoding of table TC.8.1 in  background variables
/***************************************************************************************************************************************************************************************************************/.

ctables
  /vlabels variables =  numChildren layer1  total
           display = none
  /table   total [c]
         + underweight2sd [c]
         + stunted2sd [c]
         + wasted2sd [c]
         + overweight2sd [c]
   by
         layer1 [c] > (
             grains [s] [mean '' f5.1]
           + beans [s] [mean '' f5.1]
           + eggs [s] [mean '' f5.1]
           + dairyProducts [s] [mean '' f5.1]
           + cheese [s] [mean '' f5.1]
           + fleshFoods [s] [mean '' f5.1]
           + vitaminA [s] [mean '' f5.1] 
           + other [s] [mean '' f5.1])
         + numChildren [c] [count '' f5.0]
  /categories variables = all empty = exclude missing = exclude
  /slabels visible = no
  /titles title=
    "FA Table HN.1.8: Consumption of food from different food groups -  Linkages with Nutritional status of children "+ 
    "Percentage of children age 6 to 23 months old who have consumed some of the food groups" +
    "as per mother's/caretaker's recollection of 24-hour diet" 
   caption =
        "[A] Cereals include: bread, rice, noodles, porridge, or other foods made from grains"
        "[B] Beans include: beans, peas, lentils or nuts, and any foods made from these"
        "[C] Milk/Dairy include: milk from animals, such as fresh, tinned, or powdered milk yogurt made from animal milk"
        "[D| Cheese includes: cheeses and other food made from animal milk"
        "[E] Meat/fish/poultry include: 1) liver, kidney, heart or other organ meats, also 2) any other meat, such as beef, pork, lamb, goat, chicken, duck or sausages made from these meats and 3) fish or shellfish, either fresh or dried"
        "[F] Vit A rich fruits include: 1) pumpkin, carrots, squash, or sweet potatoes that are yellow or orange inside, 2) also any dark green, leafy vegetables, such as pumpkin leaf, chinese cabbage, broccoli, and 3) ripe mangoes or ripe papayas"
        "[G] Other fruits and vegetables include: any other fruits or vegetables, such as apple, pear, orange, water melon, coconut flesh, grapes, lemon, lime or cucumber".

new file.

