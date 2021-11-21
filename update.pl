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


append_inv(X) :-
    retract(inv(I)),
    append(I, [X] , List),
    assertz(inv(List)).

/*coming soon : delete_inv*/

