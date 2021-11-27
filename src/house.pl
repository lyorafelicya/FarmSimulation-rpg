/* Modul: House */

:- include('map.pl').
:- include('update.pl').

:- dynamic(time/2).
time(230, 2).

house :-
    location(player, X, Y),
    location(house, X, Y) ->
    (
        write('You have arrived at your house!'), nl,
        write('Here are the activities that you can do :'), nl,
        write('1. sleep'), nl,
        /* tambahin bonus kalo mau */
        write('What do you want to do?'), read(Opt),
        Opt == 'sleep' ->
        (
            time(M,D),
            (M>0, M<360) ->
            (   
                retract(time(M,D)),
                NewM is 480,
                assertz(time(NewM,D)),
                write('You woke up late.'), nl
            );
            % else 
            (
                retract(time(M,D)),
                NewM is 360,
                NewD is D+1,
                assertz(time(NewM,NewD)),
                write('You slept well.'), nl
            )
            
        )
    );
    % else 
    (
        write('You are not at your house! Go to the \'H\' tile to use this command.')
    ).