/* Modul: Update */

/* Menambah exp farming */
add_farming(E) :-
    retract(exp_farming(Exp)),
    NewExp is Exp + E,
    assertz(exp_farming(NewExp)),
    exp_check.

/* Menambah exp fishing */
add_fishing(E) :-
    retract(exp_fishing(Exp)),
    NewExp is Exp + E,
    assertz(exp_fishing(NewExp)),
    exp_check.

/* Menambah exp ranching */
add_ranching(E) :-
    retract(exp_ranching(Exp)),
    NewExp is Exp + E,
    assertz(exp_ranching(NewExp)),
    exp_check.

/* Menambah menit */
add_time(M) :-
    retract(time(Min, Day)),
    NewMin is Min + M,
    assertz(time(NewMin, Day)),
    time_check.

/* Update hari */
time_check :- 
    time(M, D),
    ( M >= 1440 -> 
      (
        retract(time(M,D)),
        NewM is M - 1440, 
        NewD is D + 1,
        assertz(time(NewM , NewD))
      );
      time(M,D)
    ).

/* Menunjukkan waktu */
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

/* Update level */
exp_check :-
    exp(E), 
    exp_farming(EFarm),
    exp_fishing(EFish),
    exp_ranching(ERanch),
    exp_batas(EB),
    ( (      E >= EB -> (retract(level(L)), NewL is L + 1, assertz(level(NewL))));
      (  EFarm >= EB -> (retract(level_farming(L)), NewL is L + 1, assertz(level_farming(NewL))) ; exp(E));
      (  EFish >= EB -> (retract(level_fishing(L)), NewL is L + 1, assertz(level_fishing(NewL))) ; exp(E));
      ( ERanch >= EB -> (retract(level_ranching(L)), NewL is L + 1, assertz(level_ranching(NewL))) ; exp(E)) 
    ).


/* Teleportation */

update_loc(X, Y) :-
    retract(location(player,_,_)),
    asserta(location(player,X,Y)).

/* Check State */

/* diselipin di awal setiap command cuy */

goal_state :- 
    money(Money),
    time(M,D),
    Money >= 20000,
    TotalTime is M + D*1440,
    TotalTime =< 365*1440.

fail_state :- \+ (goal_state).

print_goal_state :- !.
print_fail_state :- !.


/*
cheat :-
    cheat(CheatCode), write(CheatCode), nl, fail.

effect_cheat(CheatCode) :-
    (
        CheatCode == lovemoney ->
            gold is 10000
    ),
    (
        CheatCode == callgrab ->
            print_building,
            write('Where do you want to go?'), nl,
            write('>>> '), read(Building)
        
    ).


print_building :-
    write('Market'), nl,
    write('Ranch'), nl,
    write('Quest Hall'), nl,
    write('House'), nl.

*/