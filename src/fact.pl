/* Modul: Fact */
/* Daftar fakta untuk fishing, farming, dan ranching */

/*                     - - - - - DEFINISI FAKTA - - - - -                        */

/*                                   FISHING                                     */
/* ============================================================================= */
/* fish(X)            : X adalah ikan                                            *
 * fishrank(X,Y)      : ikan X memiliki rank Y                                   *
 * price(X,Y)         : X seharga Y                                              * 
 * exp_yield(X,Y)     : berhasil pancing X -> mendapat exp Y                     */

/*                                  FARMING                                      */
/* ============================================================================= */
/* crop(X)            : X adalah crop (hasil panen)                             *
 * seed(X)            : X adalah seed                                            *
 * price(X,Y)         : X seharga Y                                              *
 * exp_yield(X,Y)     : berhasil panen X -> mendapat exp Y                       *
 * grow_day(X,Y)      : seed X butuh Y hari untuk menjadi hasil panen            */

/*                                  RANCHING                                     */
/* ============================================================================= */
/* livestock(X)       : X adalah livestock                                       *
 * price(X,Y)         : X seharga Y                                              *
 * produce(X,Y)       : livestock X menghasilkan product Y                       *
 * exp_yield(X,Y)     : berhasil mengambil product X -> mendapat exp Y           *
 * produce_day(X,Y,Z) : livestock X di level ranching Y membutuhkan waktu Z hari */


/* FISHING */

/* Fish */
fish(dory).
fish(catfish).
fish(anchovy).
fish(sardine).
fish(eel).
fish(archerfish).
fish(sunfish).
fish(flying_fish).
fish(puffer_fish).
fish(salmon).
fish(turtle).
fish(lionfish).
fish(koi).
fish(barracuda).
fish(billfish).
fish(tuna).
fish(stringray).
fish(piranha).
fish(king_crab).
fish(arowana).
fish(shark).

/* Fish Rank */
fishrank(dory,1).
fishrank(catfish,1).
fishrank(anchovy,1).
fishrank(sardine,1).
fishrank(eel,1).
fishrank(archerfish,2).
fishrank(sunfish,2).
fishrank(flying_fish,2).
fishrank(puffer_fish,2).
fishrank(salmon,3).
fishrank(turtle,3).
fishrank(lionfish,3).
fishrank(koi,3).
fishrank(barracuda,3).
fishrank(billfish,4).
fishrank(tuna,4).
fishrank(stringray,4).
fishrank(piranha,4). 
fishrank(king_crab,4).
fishrank(arowana,5).
fishrank(shark,5).

/* FARMING */

/* Plant */
crop(carrot).
crop(corn).
crop(potato).
crop(tomato).
crop(mushroom).
crop(onion).
crop(garlic).
crop(radish).
crop(asparagus).
crop(broccoli).
crop(bell_pepper).
crop(daikon).
crop(cucumber).
crop(cauliflower). 
crop(beetroots).
crop(cabbage).
crop(cilantro).
crop(chili_pepper).
crop(bok_choy).
crop(pumpkin).
crop(melon). 
crop(strawberry).
crop(raspberry).
crop(blueberry).
crop(wasabi).

/*Plants' Seed*/
seed(carrot_seed).
seed(corn_seed).
seed(potato_seed).
seed(tomato_seed).
seed(mushroom_seed).
seed(onion_seed).
seed(garlic_seed).
seed(radish_seed).
seed(asparagus_seed).
seed(broccoli_seed).
seed(bell_pepper_seed).
seed(daikon_seed).
seed(cucumber_seed).
seed(cauliflower_seed). 
seed(beetroots_seed).
seed(cabbage_seed).
seed(cilantro_seed).
seed(chili_pepper_seed).
seed(bok_choy_seed).
seed(pumpkin_seed).
seed(melon_seed). 
seed(strawberry_seed).
seed(raspberry_seed).
seed(blueberry_seed).
seed(wasabi_seed).

/* Plants' Growth */
grow_day(carrot_seed,1).
grow_day(corn_seed,1).
grow_day(potato_seed,1).
grow_day(tomato_seed,1).
grow_day(mushroom_seed,1).
grow_day(onion_seed,1).
grow_day(garlic_seed,1).
grow_day(radish_seed,1).
grow_day(asparagus_seed,2).
grow_day(broccoli_seed,2).
grow_day(bell_pepper_seed,2).
grow_day(daikon_seed,2).
grow_day(cucumber_seed,2).
grow_day(cauliflower_seed,2). 
grow_day(beetroots_seed,2).
grow_day(cabbage_seed,3).
grow_day(cilantro_seed,3).
grow_day(chili_pepper_seed,3).
grow_day(bok_choy_seed,3).
grow_day(pumpkin_seed,5).
grow_day(melon_seed,6).
grow_day(strawberry_seed,9).
grow_day(raspberry_seed,9).
grow_day(blueberry_seed,9).
grow_day(wasabi_seed,14).

/* Seed Grow Into Plant */

grow_into(carrot_seed,carrot).
grow_into(corn_seed,corn).
grow_into(potato_seed,potato).
grow_into(tomato_seed,tomato).
grow_into(mushroom_seed,mushroom).
grow_into(onion_seed,onion).
grow_into(garlic_seed,garlic).
grow_into(radish_seed,radish).
grow_into(asparagus_seed,asparagus).
grow_into(broccoli_seed,broccoli).
grow_into(bell_pepper_seed,bell_pepper).
grow_into(daikon_seed,daikon).
grow_into(cucumber_seed,cucumber).
grow_into(cauliflower_seed,cauliflower). 
grow_into(beetroots_seed,beetroots).
grow_into(cabbage_seed,cabbage).
grow_into(cilantro_seed,cilantro).
grow_into(chili_pepper_seed,chili_pepper).
grow_into(bok_choy_seed,bok_choy).
grow_into(pumpkin_seed,pumpkin).
grow_into(melon_seed,melon).
grow_into(strawberry_seed,strawberry).
grow_into(raspberry_seed,raspberry).
grow_into(blueberry_seed,blueberry).
grow_into(wasabi_seed,wasabi).


/* RANCHING */

/* Livestock */
livestock(chicken).
livestock(cow).
livestock(sheep).

/* Production */
produce(chicken,egg).
produce(cow,milk).
produce(sheep,wool).

/* Product */
product(egg).
product(milk).
product(wool).

/* Produce day */
produce_day(chicken, 1, 3).
produce_day(chicken, 2, 2).
produce_day(chicken, 3, 2).
produce_day(chicken, 4, 2).
produce_day(chicken, 5, 1).
produce_day(cow, 1, 3).
produce_day(cow, 2, 3).
produce_day(cow, 3, 2).
produce_day(cow, 4, 2).
produce_day(cow, 5, 2).
produce_day(sheep, 1, 6).
produce_day(sheep, 2, 5).
produce_day(sheep, 3, 5).
produce_day(sheep, 4, 4).
produce_day(sheep, 5, 3).


/* PRICE */

/*Fish Price*/
price(dory,1).
price(catfish,1).
price(anchovy,2).
price(sardine,2).
price(eel,3).
price(archerfish,10).
price(sunfish,12).
price(flying_fish,18).
price(puffer_fish,24).
price(salmon,100).
price(turtle,120).
price(lionfish,150).
price(koi,180).
price(barracuda,200).
price(billfish,300).
price(tuna,500).
price(stringray,400).
price(piranha,600). 
price(king_crab,1500).
price(arowana,3000).
price(shark,4000).

/*Plants Price*/
price(carrot,2).
price(corn,2).
price(potato,3).
price(tomato,3).
price(mushroom,5).
price(onion,5).
price(garlic,5).
price(radish,8).
price(asparagus,10).
price(broccoli,12).
price(bell_pepper,15).
price(daikon,16).
price(cucumber,14).
price(cauliflower,16). 
price(beetroots,16).
price(cabbage,20).
price(cilantro,25).
price(chili_pepper,25).
price(bok_choy,30).
price(pumpkin,100).
price(melon,250).
price(strawberry,400).
price(raspberry,400).
price(blueberry,400).
price(wasabi,2000).

/* Seeds price */
price(carrot_seed, 1).
price(corn_seed, 1).
price(potato_seed, 1).
price(tomato_seed, 1).
price(mushroom_seed, 1).
price(onion_seed, 2).
price(garlic_seed, 2).
price(radish_seed, 3).
price(asparagus_seed, 5).
price(broccoli_seed, 5).
price(bell_pepper_seed, 5).
price(daikon_seed, 5).
price(cucumber_seed, 5).
price(cauliflower_seed, 5). 
price(beetroots_seed, 5).
price(cabbage_seed, 8).
price(cilantro_seed, 8).
price(chili_pepper_seed, 5).
price(bok_choy_seed, 10).
price(pumpkin_seed, 30).
price(melon_seed, 50). 
price(strawberry_seed, 80).
price(raspberry_seed, 80).
price(blueberry_seed, 80).
price(wasabi_seed, 500).

/* Livestock price */
price(chicken, 100).
price(cow, 3000).
price(sheep, 2000).

/* Product price */
price(egg,30).
price(milk,50).
price(wool,80).



/* EXP YIELD */

/* Exp from Fish */
exp_yield(dory,8).
exp_yield(catfish,8).
exp_yield(anchovy,12).
exp_yield(sardine,16).
exp_yield(eel,20).
exp_yield(archerfish,80).
exp_yield(sunfish,100).
exp_yield(flying_fish,150).
exp_yield(puffer_fish,150).
exp_yield(salmon,300).
exp_yield(turtle,500).
exp_yield(lionfish,550).
exp_yield(koi,600).
exp_yield(barracuda,800).
exp_yield(billfish,1200).
exp_yield(tuna,1800).
exp_yield(stringray,1400).
exp_yield(piranha,2000).
exp_yield(king_crab,2500).
exp_yield(arowana,6000).
exp_yield(shark,10000).

/*Plants' Exp yield*/
exp_yield(carrot,5).
exp_yield(corn,5).
exp_yield(potato,5).
exp_yield(tomato,8).
exp_yield(mushroom,8).
exp_yield(onion,10).
exp_yield(garlic,10).
exp_yield(radish,15).
exp_yield(asparagus,12).
exp_yield(broccoli,12).
exp_yield(bell_pepper,15).
exp_yield(daikon,15).
exp_yield(cucumber,12).
exp_yield(cauliflower,18). 
exp_yield(beetroots,20).
exp_yield(cabbage,20).
exp_yield(cilantro,24).
exp_yield(chili_pepper,30).
exp_yield(bok_choy,24).
exp_yield(pumpkin,50).
exp_yield(melon,100).
exp_yield(strawberry,200).
exp_yield(raspberry,200).
exp_yield(blueberry,200).
exp_yield(wasabi,600).

/* Exp yield */
exp_yield(egg,50).
exp_yield(milk,300).
exp_yield(wool,500).


/*cheat*/

/*lovemoney : gives 1 million coins                     */
/*callgrab  : instantly move avatar to any buildings    */
/*jump      : instantly move avatar to any coordinates  */
/*rewind    : reset Day                                 */

cheat(lovemoney).
cheat(callgrab).
cheat(jump).
cheat(rewind).