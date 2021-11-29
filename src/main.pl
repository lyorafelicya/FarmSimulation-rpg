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
:- include('marketplace.pl').
:- include('quest.pl'). 
:- include('house.pl').

:- dynamic(game_ready/0).
:- dynamic(game_started/0).
:- dynamic(game_ended/0).

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

mult_farming(1.0).
level_farming(1).
exp_farming(0).

mult_fishing(1.0).
level_fishing(1).
exp_fishing(0).

mult_ranching(1.0).
level_ranching(1).
exp_ranching(0).


/* Experience */
exp(E) :- 
    exp_farming(ExpFarm),
    exp_fishing(ExpFish),
    exp_ranching(ExpRanch),    
    E is ExpFarm + ExpFish + ExpRanch.

exp_batas(Batas)          :- level(L), NextL is L + 1, Batas is round(NextL * NextL * log(NextL) * 30).
exp_batas_farming(Batas)  :- level_farming(L), NextL is L + 1, Batas is round(NextL * NextL * log(NextL) * 30).
exp_batas_fishing(Batas)  :- level_fishing(L), NextL is L + 1, Batas is round(NextL * NextL * log(NextL) * 30).
exp_batas_ranching(Batas) :- level_ranching(L), NextL is L + 1, Batas is round(NextL * NextL * log(NextL) * 30).

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

/* Start Game */
start_game :- has_ended, !.

start_game :- game_started, !, 
    nl,
    write('    The game is on!'), nl,
    write('    Now go play and have fun (before Winter Shogun comes)!'), nl, nl.

start_game :- game_ready, !, 
    nl,
    write('    You have started the game!'), nl,
    write('    Now it\'s time to start!'), nl, nl.

start_game :-
    assertz(game_ready),
    title_art,
    nl, nl,
    start_command.

/* Start */

start :- \+ game_ready, !,
    nl,
    write('    You haven\'t started the game!'), nl,
    write('    Use start_game command first!'), nl, nl.

start :- has_ended, !.

start :- game_started, !, 
    nl,
    write('    The game is on!'), nl,
    write('    Now go play and have fun (before Winter Shogun comes)!'), nl, nl.

start :-
    assertz(game_started), nl,
    opening_story, nl,
    start_art,
    nl, nl,
    write('    Welcome to Kimi no Tubes! You can choose one of three professions below:'), nl,nl,
    jobs_art, nl,
    write('    Choose your profession : '), read(P),
    assertz(job(P)),

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

    write('     Yeayy!! you choose '), write(P), write(' \\(^o^)/     '), nl, 
    nl,
    write('     Now, time to work! May God of Fortune be with you.    '), nl,
    nl,
    write('                     ~ Itterashai ~                        '), nl, 
    nl,
    write('  P.S. If you need help , feel free to call the Gods by typing \'help\' :D'),nl,nl.


/* Status */

status :- has_not_started_game, !.
status :- has_not_started, !.
status :- has_ended, !.
status :-
    location(player,X,Y),
    level(L),
    job(P),
    money(M),
    level_farming(Farm),
    level_fishing(Fish),
    level_ranching(Ranch),
    tool(fishing_rod, Rod),
    tool(shovel, Shovel),
    exp(E),
    exp_farming(E_farm),
    exp_fishing(E_fish),
    exp_ranching(E_ranch),
    exp_batas(E_batas),
    exp_batas_farming(E_batas_farm),
    exp_batas_fishing(E_batas_fish),
    exp_batas_ranching(E_batas_ranch),
    write('          ________________________________________________________'),nl,
    write('         /\\                                                      \\'),nl,
    write('     (O)===)><><><><><><><><><><><><><><><><><><><><><><><><><><><)==(O)'),nl,
    write('         \\/\'\'\'\'\'\'\'\'\'\'\'\'\'\'\'\'\'\'\'\'\'\'\'\'\'\'\'\'\'\'\'\'\'\'\'\'\'\'\'\'\'\'\'\'\'\'\'\'\'\'\'\'\'\'/'),nl,
    write('         /                                                        \\'),nl,
    write('       /                                                            \\'),nl,
    write('     /&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&\\'),nl,
    write('    ||                                                                ||'),nl,
    write('          '),time,
    write('                                            Player\'s Location : ('),write(X),write(','),write(Y),write(')'),nl,
    nl,
    write('             LEVEL          :  '),write(L),write('  ('),write(E),write(' / '),write(E_batas),write(')'),nl,
    nl,
    write('             JOB            :  '),write(P),nl,
    nl,
    write('             MONEY          :  '),write(M),write(' Gold'),nl,
    nl,
    write('      ----------------------------------------------------------------'),nl,
    nl,
    write('             FARMING LEVEL  : '),write(Farm) ,write('  ('),write(E_farm) ,write(' / '),write(E_batas_farm) ,write(')'),nl,
    nl,
    write('             FISHING LEVEL  : '),write(Fish) ,write('  ('),write(E_fish) ,write(' / '),write(E_batas_fish) ,write(')'),nl,
    nl,
    write('             RANCHING LEVEL : '),write(Ranch),write('  ('),write(E_ranch),write(' / '),write(E_batas_ranch),write(')'),nl,
    nl,
    nl,
    write('      ________________________________________________________________'),nl,
    nl,
    write('             EQUIPMENTS'),nl,
    nl,
    write('                SHOVEL      : '),write(Shovel),nl,
    nl,
    write('                FISHING ROD : '),write(Rod),nl,
    nl,
    write('    ||                                                                 ||'),nl,
    write('     \\&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&/'),nl,
    write('       \\                                                            /'),nl,
    write('         \\                                                        /'),nl,
    write('         /\\\'\'\'\'\'\'\'\'\'\'\'\'\'\'\'\'\'\'\'\'\'\'\'\'\'\'\'\'\'\'\'\'\'\'\'\'\'\'\'\'\'\'\'\'\'\'\'\'\'\'\'\'\'\'\\'),nl,
    write('     (O)===)><><><><><><><><><><><><><><><><><><><><><><><><><><><)==(O)'),nl,
    write('         \\/______________________________________________________/'),nl.


/* Quit */

quit :- has_not_started_game, !.
quit :-
    write('   Are you sure you want to quit :( ? (yes / no)'),nl,
    write(' >> '),read(Answer),
    Answer == yes ->
    (
        write('   Otsukaresamadeshita~~ mata ne!'), halt
    );
    (
        write('   I know you are kidding :D'),nl,
        write('   hehehe (^-^)/*'),nl
    ).