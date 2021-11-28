:- dynamic(location/3).

map_size(28, 12).

/* location(name, x, y) */
location(player, 24, 11).

location(quest, 3, 2).
location(ranch, 10, 3).
location(market, 5, 11).
location(house, 24, 11).

location(water, 24, 1).
location(water, 25, 1).
location(water, 26, 1).
location(water, 27, 1).
location(water, 28, 1).

location(water, 23, 2).
location(water, 24, 2).
location(water, 25, 2).
location(water, 26, 2).
location(water, 27, 2).
location(water, 28, 2).

location(water, 24, 3).
location(water, 25, 3).
location(water, 26, 3).
location(water, 27, 3).
location(water, 28, 3).

location(water, 26, 4).
location(water, 27, 4).
location(water, 28, 4).

location(water, 10, 6).
location(water, 11, 6).
location(water, 12, 6).
location(water, 13, 6).

location(water, 9, 7).
location(water, 10, 7).
location(water, 11, 7).
location(water, 12, 7).
location(water, 13, 7).
location(water, 14, 7).

location(water, 10, 8).
location(water, 11, 8).
location(water, 12, 8).
location(water, 13, 8).

map :- has_not_started_game, !.
map :- has_not_started, !.
map :- has_ended, !.
map :-  
    map_size(X,Y),
    print_hash,
    print_core_map,
    print_hash, !.

print_core_map :- print_core_map(1), !.
print_core_map(N) :- map_size(X,Y), N == Y, print_row(N), !.
print_core_map(N) :-
    print_row(N), 
    NextN is N + 1,
    print_core_map(NextN).

print_hash :- map_size(X,Y), Count is X + 1, print_hash(Count).
print_hash(0) :- write('#'), nl, !.
print_hash(N) :- 
    write('#'),
    NextN is N - 1,
    print_hash(NextN).

print_row(Row) :- write('#'), print_row(1, Row).
print_row(Col, Row) :- map_size(X,Y), Col =:= X + 1, write('#'), nl, !.
print_row(Col, Row) :- 
    (
      \+ location(Place, Col, Row) -> 
        Place = tile;
      % else
        location(Place, Col, Row)
    ), !,
    print_symbol(Place),
    NextCol is Col + 1,
    print_row(NextCol, Row).

print_symbol(player) :- write('P').
print_symbol(quest) :- write('Q').
print_symbol(ranch) :- write('R').
print_symbol(market) :- write('M').
print_symbol(house) :- write('H').
print_symbol(water) :- write('o').
print_symbol(digged_tile) :- write('=').
print_symbol(tile) :- write('-').
print_symbol(crop) :- write('c').


/* MOVE COMMAND */

/* Validity Check */
is_border(X,Y) :- 
    map_size(MapX, MapY),
    BorderX is MapX + 1,
    BorderY is MapY + 1,
    (X == 0 ; X == BorderX; Y == 0; Y == BorderY).

is_water(X,Y) :- location(water, X, Y). 

/*Move : Up*/
w :- has_not_started_game, !.
w :- has_not_started, !.
w :- has_ended, !.
w :-
    location(player, X, Y),
    NewX is X,
    NewY is Y - 1,

    is_border(NewX, NewY) -> 
    (
        write('   You hit the wall. You got head bump.'), nl,
        write('   Daijoubu desu ka? (@ v @)//'), nl 
    );
    % else
    (   
        location(player, X, Y),
        NewX is X,
        NewY is Y - 1,
        is_water(NewX, NewY) ->
        (
            write('   You nearly drowned. Your clothes get soaked.'), nl,
            write('   Daijoubu desu ka? (@ v @)//'), nl 
        );
        % else
        (
            retract(location(player, X, Y)),
            NewX is X,
            NewY is Y - 1,
            asserta(location(player, NewX, NewY))
        )
    ),
    
    add_time(3).

/*Move : Down*/
s :- has_not_started_game, !.
s :- has_not_started, !.
s :- has_ended, !.
s :-
    location(player, X, Y),
    NewX is X,
    NewY is Y + 1,

    is_border(NewX, NewY) -> 
    (
        write('   You hit the wall. You got head bump.'), nl,
        write('   Daijoubu desu ka? (@ v @)//'), nl 
    );
    % else
    (
        location(player, X, Y),
        NewX is X,
        NewY is Y + 1,
        is_water(NewX, NewY) ->
        (
            write('   You nearly drowned. Your clothes get soaked.'), nl,
            write('   Daijoubu desu ka? (@ v @)//'), nl 
        );
        % else
        (
            retract(location(player, X, Y)),
            NewX is X,
            NewY is Y + 1,
            asserta(location(player, NewX, NewY)) 
        )
    ),

    retract(time(M, D)),
    NewM is M + 3,
    assertz(time(NewM, D)),
    time_check.

/*Move : Left*/
a :- has_not_started_game, !.
a :- has_not_started, !.
a :- has_ended, !.
a :-
    location(player, X, Y),
    NewX is X - 1,
    NewY is Y,
    
    is_border(NewX, NewY) -> 
    (
        write('   You hit the wall. You got head bump.'), nl,
        write('   Daijoubu desu ka? (@ v @)//'), nl 
    );
    % else
    (
        location(player, X, Y),
        NewX is X - 1,
        NewY is Y,
        is_water(NewX, NewY) ->
        (
            write('   You nearly drowned. Your clothes get soaked.'), nl,
            write('   Daijoubu desu ka? (@ v @)//'), nl 
        );
        % else
        (
            retract(location(player, X, Y)),
            NewX is X - 1,
            NewY is Y,
            asserta(location(player, NewX, NewY)) 
        )
    ),
    
    retract(time(M, D)),
    NewM is M + 3,
    assertz(time(NewM, D)),
    time_check.

/*Move : Right*/
d :- has_not_started_game, !.
d :- has_not_started, !.
d :- has_ended, !.
d :-
    location(player, X, Y),
    NewX is X + 1,
    NewY is Y,

    is_border(NewX, NewY) -> 
    (
        write('   You hit the wall. You got head bump.'), nl,
        write('   Daijoubu desu ka? (@ v @)//'), nl 
    );
    % else
    (
        location(player, X, Y),
        NewX is X + 1,
        NewY is Y,
        is_water(NewX, NewY) ->
        (
            write('   You nearly drowned. Your clothes get soaked.'), nl,
            write('   Daijoubu desu ka? (@ v @)//'), nl 
        );
        % else
        (
            retract(location(player, X, Y)),
            NewX is X + 1,
            NewY is Y,
            asserta(location(player, NewX, NewY)) 
        )
    ),
    
    retract(time(M, D)),
    NewM is M + 3,
    assertz(time(NewM, D)),
    time_check.
