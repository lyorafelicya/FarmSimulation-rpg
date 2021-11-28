/* Modul: Update */

/* Menambah exp farming */
add_farming(E) :-
    retract(exp_farming(Exp)),
    NewExp is Exp + E,
    assertz(exp_farming(NewExp)),
    exp_check,
    exp_farming_check.

/* Menambah exp fishing */
add_fishing(E) :-
    retract(exp_fishing(Exp)),
    NewExp is Exp + E,
    assertz(exp_fishing(NewExp)),
    exp_check,
    exp_fishing_check.

/* Menambah exp ranching */
add_ranching(E) :-
    retract(exp_ranching(Exp)),
    NewExp is Exp + E,
    assertz(exp_ranching(NewExp)),
    exp_check,
    exp_ranching_check.

/* Update level */
exp_check :-
    exp(E),
    exp_batas(EB),
    E >= EB  -> 
    ( retract(level(L)), 
      NewL is L + 1,
      assertz(level(NewL)),
      print_level_up(NewL), !,
      exp_check
    ).
exp_check.

exp_farming_check :-
    exp_farming(EFarm),
    exp_batas_farming(EBFarm),
    EFarm >= EBFarm  -> 
    ( retract(level_farming(L)), 
      NewL is L + 1, 
      assertz(level_farming(NewL)), !,
      exp_farming_check
    ).
exp_farming_check.

exp_fishing_check :-
    exp_fishing(EFish),
    exp_batas_fishing(EBFish),
    EFish >= EBFish  -> 
    ( retract(level_fishing(L)), 
      NewL is L + 1, 
      assertz(level_fishing(NewL)),
      exp_fishing_check
    ).
exp_fishing_check.

exp_ranching_check :-
    exp_ranching(ERanch),
    exp_batas_ranching(EBRanch),
    ERanch >= EBRanch  -> 
    ( retract(level_ranching(L)), 
      NewL is L + 1, 
      assertz(level_ranching(NewL)),
      exp_ranching_check
    ).
exp_ranching_check.



/* Menambah menit */
add_time(M) :-
    retract(time(Min, Day)),
    NewMin is Min + M,
    assertz(time(NewMin, Day)),
    time_check.

/* Update hari */
time_check :-
    time(M, D),
    M >= 1440 -> 
    (
        retract(time(M,D)),
        NewM is M mod 1440, 
        NewD is D + M//1440,
        assertz(time(NewM , NewD)), !,
        check_state
    ).
    
time_check :- check_state.

/* Menunjukkan waktu */
time :- has_not_started_game, !.
time :- has_not_started, !.
time :- has_ended, !.
time :-
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

/* Menambah gold */
add_money(M) :-
    retract(money(Money)),
    NewMoney is Money + M,
    assertz(money(NewMoney)),
    check_state.

/* Mengurangi gold */
sub_money(M) :-
    retract(money(Money)),
    NewMoney is Money - M,
    assertz(money(NewMoney)),
    check_state.



/* Arts */

print_level_up(NewL) :-
    write('    ====================================='),nl,
    write('    ||         L E V E L   U P         ||'),nl,
    write('    ||---------------------------------||'),nl,
    write('    ||  You leveled up to Level '),write(NewL),
    (NewL < 10 ->(write(' !!   ||'));(write(' !!  ||'))),
    nl,
    write('    ====================================='),nl.


/* Teleportation */

teleport(X, Y) :-
    is_available_to_teleport(X, Y) -> 
        ( retract(location(player,_,_)),
          asserta(location(player,X,Y))
        );
    % else
        ( write('   You cannot teleport to there.'), nl,
          write('   You missed your chance from Paimon.'), nl,
          write('   Sad.'),nl,
          fail
        ).
    
is_available_to_teleport(X, Y) :-
    map_size(MapX, MapY),
    X >= 1, X =< MapX, Y >= 1, Y =< MapY,
    \+ location(water, X, Y).


/* Check State */

check_state :-
    ((goal_state -> (print_goal_state));
    (fail_state -> (print_fail_state))), !.
check_state.

goal_state :- 
    money(Money),
    time(M,D),
    Money >= 20000,
    D =< 20.

fail_state :- 
    money(Money),
    time(M,D),
    Money < 20000,
    D > 20.

/* End game */

print_goal_state :-
    nl,
    assertz(game_ended),
    congrats_art,
    nl,
    write('   YOU HAVE COLLECTED 20K GOLD~                                   '),nl,
    write('   YEAY! You\'ve paid your debts~                                 '),nl,
    nl,
    write('   Without further ado, time to reincarnate back to earth ( ^-^)//'),nl,
    write('   Bye byeeee~~                                                   '),nl,
    nl,
    nl,
    credit_art,
    nl.


print_fail_state :-
    assertz(game_ended),
    write('   It\'s the morning of the 21st day. '), nl,
    write('   You wake up just to see Winter Shogun is outside your house.'), nl,
    write('   You think you just need to give him more food, so you open your door.'), nl,
    write('   The Winter Shogun stands tall.'), nl, 
    nl,
    write('   Without any ado, he draws his glacial katana from its sheath.'), nl,
    write('   Your last memory before dying is the blurry vision of the '), nl,
    write('   Winter Shogun slashing his katana through your chest.'), nl,
    nl,
    write('   You are now in the other world with Aqua-sama.'), nl,
    nl,
    game_over_art,
    nl.


/* Check game state */
has_not_started_game :- \+ game_ready, !,
    nl,
    write('    You haven\'t started the game!'), nl,
    write('    Use start_game command first!'), nl, nl.

has_not_started :- \+ game_started, !,
    nl,
    write('    You haven\'t started the game completely!'), nl,
    write('    Use start command first!'), nl, nl.

has_ended :- game_ended, !,
    nl,
    write('    The game has ended.'), nl, nl.