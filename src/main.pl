/* File: main.pl */
/* Program utama */

:- include('fact.pl').
:- include('map.pl').
:- include('art.pl').
:- include('help.pl').
:- include('update.pl').
:- include('inventory.pl').
:- include('farming.pl').
:- include('fishing.pl').
:- include('ranching.pl').


:- dynamic(level/1).
:- dynamic(job/1).
:- dynamic(money/1).

:- dynamic(level_farming/1).
:- dynamic(exp_farming/1).
:- dynamic(level_fishing/1).
:- dynamic(exp_fishing/1).
:- dynamic(level_ranching/1).
:- dynamic(exp_ranching/1).

:- dynamic(level_shovel/1).
:- dynamic(level_fishing_rod/1).

:- dynamic(mult_farming/1).
:- dynamic(mult_fishing/1).
:- dynamic(mult_ranching/1).


/*DEFAULT PLAYER STATE*/
level(1).
money(0).

mult_farming(1).
level_farming(1).
exp_farming(0).

mult_fishing(1).
level_fishing(1).
exp_fishing(0).

mult_ranching(1).
level_ranching(1).
exp_ranching(0).


/* Experience */
exp(E) :- 
    exp_farming(ExpFarm),
    exp_fishing(ExpFish),
    exp_ranching(ExpRanch),    
    E is ExpFarm + ExpFish + ExpRanch.

exp_batas(Batas)          :- level(L), (Batas is (L**2) * 30).
exp_batas_farming(Batas)  :- level_farming(L), (Batas is (L**2) * 30).
exp_batas_fishing(Batas)  :- level_fishing(L), (Batas is (L**2) * 30).
exp_batas_ranching(Batas) :- level_ranching(L), (Batas is (L**2) * 30).

/* Professions */
profession(farmer).
profession(fisherman).
profession(rancher).

/* Time (m,d) */
/* param ke-1 : menit , param ke-2 : day */
/* menit(0 <= m < 1440) -> dihitung per move (sesuai bobot) */
/* day (1 <= d <= 20) */
:- dynamic(time/2).
time(360,1).


/* Tools */
:- dynamic(tool/2).
tool(shovel, 1).
tool(fishing_rod, 1).


/*Command Line*/

/*
start
status
up
down
left
right
map

enter
    market :
        buy (panggil buy , maka : kluarin list barang)
        sell

    Ranch (ranching) :
        (ambil panen)
    
    Quest Hall :
        Quest
        submit
    
    house :
        sleep
        (bonus : writeDiary, readDiary)

inventory :
    throwItem :
        - mau buang apa
        - mau buang berapa

fishing :
    fish

farming :
    dig
    plant
    harvest

help
cheat
quit
*/

start_game :-
    title_art,
    nl, nl,
    start_command.

start :-
    start_art,
    nl, nl,
    write('Welcome to Kimi no Tubes! You can choose one of three professions below:'), nl,
    jobs_art, nl,
    write('Choose your profession : '), read(P),
    assertz(job(P)),

    /*  ==== STILL ERROR ====
    (
        profession(P) -> 
            assertz(job(P));
        % else
        (   
            repeat,
                write('You must choose a valid profession!'), nl,
                write('Choose your profession : '), read(P1),
            profession(P1), !,
            assertz(job(P1))
        )
    ),
    */

    job(P),
    (
      (
        (P == fisherman) -> 
        (
            retract(mult_fishing(V)), 
            assertz(mult_fishing(1.5)) 
        )
      );

      ( 
        (P == farmer) -> 
        (
            retract(mult_farming(V)), 
            assertz(mult_farming(1.5))
        )
      );
    
      ( 
        (P == rancher) -> 
        (
            retract(mult_ranching(V)), 
            assertz(mult_ranching(1.5))
        )
      )
    ),

    write('Yeayy!! you choose '), write(P), write(' \\(^o^)/'), nl,
    write('Now, time to work! May God of Fortune be with you.'), nl,
    write('                ~ Itterashai ~'), nl.
    


status :-
    location(player,X,Y),
    level(X),
    job(P),
    money(M),
    level_farming(Farm),
    level_fishing(Fish),
    level_ranching(Ranch),
    level_fishing_rod(Rod),
    level_shovel(Shovel),
    Exp(E),
    exp_farming(E_farm),
    exp_fishing(E_fish),
    exp_ranching(E_ranch),
    exp_batas(E_batas),
    exp_batas_farming(E_batas_farm),
    exp_batas_fishing(E_batas_fish),
    exp_batas_ranching(E_batas_ranch),
    write('          ________________________________________________________'),nl.
    write('         /\\                                                      \\'),nl,
    write('     (O)===)><><><><><><><><><><><><><><><><><><><><><><><><><><><)==(O)'),nl,
    write('         \\/''''''''''''''''''''''''''''''''''''''''''''''''''''''/'),nl,
    write('         /                                                        \\'),nl,
    write('        /                                                          \\'),nl,
    write('       /&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&\\'),nl,
    write('      ||                                                             ||'),nl,
    write('          '),show_time,nl,
    write('             LEVEL          :  '),write(X),write('  ('),write(E),write(' / '),write(E_batas),write(')'),nl,
    write('             JOB            :  '),write(P),nl,
    write('             MONEY          :  '),write(M),nl,nl,nl,nl,
    write('      ----------------------------------------------------------------'),nl,nl,
    write('             FARMING LEVEL  : '),write(Farm),write('  ('),write(E_farm),write(' / '),write(E_batas_farm),write(')'),nl,nl,
    write('             FISHING LEVEL  : '),write(Fish),write('  ('),write(E_fish),write(' / '),write(E_batas_fish),write(')'),nl,nl,
    write('             RANCHING LEVEL : '),write(Ranch),write('  ('),write(E_ranch),write(' / '),write(E_batas_ranch),write(')'),nl,nl,nl,
    write('      ----------------------------------------------------------------'),nl,nl,
    write('             EQUIPMENTS'),nl,
    write('      ----------------------------------------------------------------'),nl,nl,
    write('                SHOVEL      : '),write(Shovel),nl,nl,
    write('                FISHING ROD : '),write(Rod),nl,nl,
    write('      ||                                                              ||'),nl,
    write('       \\&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&/'),nl,
    write('        \\                                                           /'),nl,
    write('         \\                                                         /'),nl
    write('         /\\''''''''''''''''''''''''''''''''''''''''''''''''''''''\\'),nl,
    write('     (O)===)><><><><><><><><><><><><><><><><><><><><><><><><><><><)==(O)'),nl,
    write('         \\/______________________________________________________/'),nl.














/* Ingat diubah ! */
% enter :- location(player, X, Y), location(market, X, Y), fungsi, !.


quit :- 
    write('Otsukaresamadeshita~~ mata ne!'), halt.