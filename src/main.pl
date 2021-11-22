/* File: main.pl */
/* Program utama */


:- include('fact.pl').
:- include('map.pl').
:- include('art.pl').
:- include('help.pl').
:- include('update.pl').


:- dynamic(level/1).
:- dynamic(job/1).
:- dynamic(gold/1).

:- dynamic(level_farming/1).
:- dynamic(exp_farming/1).
:- dynamic(level_fishing/1).
:- dynamic(exp_fishing/1).
:- dynamic(level_ranching/1).
:- dynamic(exp_ranching/1).

:- dynamic(time/2).
/*param ke-1 : menit , param ke-2 : day*/

:- dynamic(level_shovel/1).
:- dynamic(level_fishing_rod/1).

:- dynamic(mult_farming/1).
:- dynamic(mult_fishing/1).
:- dynamic(mult_ranching/1).


/*DEFAULT STATE*/
level(1).
gold(0).

mult_farming(1).
level_farming(1).
exp_farming(0).

mult_fishing(1).
level_fishing(1).
exp_fishing(0).

mult_ranching(1).
level_ranching(1).
exp_ranching(0).

/*Inventory*/
inv([]).


/* Experience */
exp(E) :- 
    E is exp_farming + exp_fishing + exp_ranching.

exp_batas(Gauge) :-
    level(L), (Gauge is (L**2) * 30).

/*Professions*/
profession(farmer).
profession(fisherman).
profession(rancher).

/*Time*/
/*time (0 <= t < 1440) -> dihitung per move (sesuai bobot)*/
/*day (1 <= d <= 20)*/
time(360,1).


/*Item's level*/
level_shovel(1).
level_fishing_rod(1).


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

show_time :-
    time(M,D),
    Minute is mod(M , 60),
    Hour is M // 60,
    Day is D,
    write('Today is Day '),write(Day),write(', '),
    (
        Hour < 10 -> 
            write('0'),
            write(Hour), 
            write(':'), 
            (
                Minute < 10 ->
                    write('0'),
                    write(Minute), 
                    write('.'),nl; 
                % else
                    write(Minute),
                    write('.'),nl
            );
        % else
            write(Hour),
            write(':'),
            (
                Minute < 10 -> 
                    write('0'),
                    write(Minute), 
                    write('.'),nl;
                % else 
                    write(Minute),
                    write('.'),nl
            )
    ).

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
    write('~ Itterashai ~'), nl.
    


/* Ingat diubah ! */
% enter :- location(player, X, Y), location(market, X, Y), fungsi, !.


quit :- 
    write('Otsukaresamadeshita~~ mata ne!'), halt.