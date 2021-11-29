/* Modul: House */

:- dynamic(have_meet_paimon/0).

house :- has_not_started_game, !.
house :- has_not_started, !.
house :- has_ended, !.

house :-
    location(player, X, Y),
    location(house, X, Y) ->
    (
        write('   You have arrived at your house!'), nl,
        write('   Here are the activities that you can do :'), nl,
        write('   1. sleep'), nl,
        write('   What do you want to do?'), nl,
        write('   >> '), read(Opt),
        Opt == sleep ->
        (
            time(M,D),
            (M > 0, M < 360) ->
            (   
                retract(time(M,D)),
                NewM is 480,
                assertz(time(NewM,D)),
                write('   You woke up late.'), nl, 
                time
            );
            % else 
            (
                retract(time(M,D)),
                NewM is 360,
                NewD is D+1,
                assertz(time(NewM,NewD)),
                chance_meet_fairy,
                write('   You slept well.'), nl, 
                time
            )
            
        )
    );
    % else 
    (
        write('   You are not at your house! Go to the \'H\' tile to use this command.')
    ).

chance_meet_fairy :-
    random(0,10,Chance),
    Chance < 1 -> meet_fairy.

meet_fairy:- \+ have_meet_paimon,
    nl,nl,
    paimon_art,
    write('    hey...hey....HEYYYYYY !'),nl,nl,
    write('                                         who are you ?! Where am I ?!'),nl,
    write('    fufufu , Behold~                                                 '),nl,
    write('    The Greatest Celestial Being , PAIMON ~(^ - ^)~'                  ),nl,
    write('                                                                  ...'),nl,
    write('    ...                                                              '),nl,
    write('                                                                  ...'),nl,
    write('    ..., Beho-                                                       '),nl,
    write('                                               YES,YES!! where am I ?'),nl,
    write('    In you dream :3'                                                  ),nl,
    write('                                                             um, Yes?'),nl,
    write('    Yes~ since you have met me ,                                     '),nl,
    write('    I\'ll give you a chance,                                         '),nl,
    write('    a chance to go anywhere~                                         '),nl,
    write('                                                     Then, get me to-'),nl,
    write('    except Earth :3                                                  '),nl,
    write('                                                                  ...'),nl,
    write('    *smug*                                                           '),nl,
    write('                                                                  ...'),nl,
    write('    So, do you have any place                                        '),nl,
    write('    you want to go?                                                  '),nl,
    write('                                                                  ...'),nl,
    write('    Where do you want to move to ?                                   '),nl,
    write('    Say your x-coordinate.                                           '),nl, 
    write('                                                                  '), read(Absis),
    write('    Say your y-coordinate.                                           '),nl,
    write('                                                                  '), read(Ordinat),
    write('    fufufu , so you want to move                                     '),nl,
    write('    to ('),write(Absis),write(','),write(Ordinat),write(') ?         '),nl,
    write('                                                                  ...'),nl,
    write('    ...                                                              '),nl,
    write('    Okay, Bye~                                                       '),nl,nl,nl,
    teleport(Absis,Ordinat),
    assertz(have_meet_paimon), !.


meet_fairy :- have_meet_paimon,
    nl,nl,
    write('    Hi again!!                                                       '),nl,
    write('                                                                  ...'),nl,
    write('    ...                                                              '),nl,
    write('                                                                  ...'),nl,
    write('    So, wi-                                                          '),nl,
    write('                                                      Yes, Lemme move'),nl,
    write('    fufufu, so quick-witted~                                         '),nl,
    write('    sasuga, kimi :3                                                  '),nl,
    write('    Where do you want to move to ?                                   '),nl,
    write('    Say your x-coordinate.                                           '),nl, 
    write('                                                                   '), read(Absis),
    write('    Say your y-coordinate.                                           '),nl,
    write('                                                                   '), read(Ordinat),
    write('    fufufu , so you want to move                                     '),nl,
    write('    to ('),write(Absis),write(','),write(Ordinat),write(') ?         '),nl,
    write('                                                                  ...'),nl,
    write('    ...                                                              '),nl,
    write('    Okay, Bye~                                                       '),nl,nl,nl,
    teleport(Absis,Ordinat).