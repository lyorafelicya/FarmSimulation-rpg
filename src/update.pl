time_check :- 
    time(M, D),
    M >= 1440 -> 
    (
        retract(time(M,D)),
        NewM is M - 1440, 
        NewD is D + 1,
        assertz(time(NewM , NewD))
    ).

exp_check :-
    exp(E), 
    exp_farming(EFarm),
    exp_fishing(EFish),
    exp_ranching(ERanch),
    exp_batas(EB),

    (
        E >= EB -> 
        (
            retract(level(L)),
            NewL is L + 1,
            assertz(level(NewL))
        )
    ),

    (
        EFarm >= EB -> 
        (
            retract(level_farming(L)),
            NewL is L + 1,
            assertz(level_farming(NewL))
        )
    ),

    (
        EFish >= EB -> 
        (
            retract(level_fishing(L)),
            NewL is L + 1,
            assertz(level_fishing(NewL))
        )
    ),
    
    (
        ERanch >= EB -> 
        (
            retract(level_ranching(L)),
            NewL is L + 1,
            assertz(level_ranching(NewL))
        )
    ).

/* APPEND & DELETE BELUM SELESAI
[(apple, 5), (banana, 4), (carrot, 5)]

check_inv(Item , [] , Idx) :- Idx is -1.

check_inv(Item , [(Head,num) | Tail] , Idx) :-
    (
        Item \= Head -> NewIdx is Idx + 1 , check_inv(Item , Tail , NewIdx)
    ).

append_inv(Item) :-
    retract(inv(I)),
    (
        check_inv(Item , I , isFound),
        (isFound = True ->
            
        )
    )

    append(I, [(Item)] , NewI),
    assertz(inv(NewI)).

delete_inv(Item) :-
    retract(inv(I)),
    select(Item, I, NewI),
    assertz(inv(NewI)).
*/

print_inv :-
    inv(I),
    print_head_list(I)

print_head_list([]) :- !.
print_head_list(List) :-
    List = [Head|Tail],
    Head = (Name, Number),
    write(Number),
    write(' x  '),
    write(Name),
    nl,
    print_head_list(Tail).

update_loc(X, Y) :-
    retract(location(player,_,_)),
    asserta(location(player,X,Y)).

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