/* Modul: Farming */

:- dynamic(crop_data/4).

is_not_tile(X, Y) :- location(water,X,Y).
is_not_tile(X, Y) :- location(quest,X,Y).
is_not_tile(X, Y) :- location(ranch,X,Y).
is_not_tile(X, Y) :- location(market,X,Y).
is_not_tile(X, Y) :- location(house,X,Y).
is_not_tile(X, Y) :- location(crop,X,Y).

is_tile(X, Y) :- \+ (is_not_tile(X,Y)).

dig :- has_not_started_game, !.
dig :- has_not_started, !.
dig :- has_ended, !.
dig :-
    location(player,X,Y),

    is_tile(X, Y) ->
    (
        assertz(location(digged_tile, X, Y)),
        write('   You successfully digged the tile'), nl,
        tool(shovel, Lvl),
        NewTime is round(30 / (log(10 * Lvl))),
        add_time(NewTime)
    );
    % else
    (
        write('   You cannot dig the tile'), nl
    ).

is_digged(X, Y) :- location(digged_tile, X, Y).
is_seed(X) :- seed(X), search_inv(X).

plant :- has_not_started_game, !.
plant :- has_not_started, !.
plant :- has_ended, !.
plant :- 
    location(player, X, Y),

    is_digged(X, Y) ->
    (   
        count_seed(N),
        N > 0 -> 
        (
            write('   You have:'), nl,
            print_seed,
            write('   What do you want to plant?'), nl,
            write('  >'),read(PlantSeed), nl,

            /* cek input */
            (   is_seed(PlantSeed) ->
                (
                    location(player, X, Y),
                    grow_day(PlantSeed, GrowTime),
                    grow_into(PlantSeed, CropName),
                    tool(shovel, Lvl),
                    NeededTime is round(10 / (Lvl+2)),
                    add_time(NeededTime),
                    time(M,D),
                    Hari is D + GrowTime,
                    delete_inv(PlantSeed),
                    retract(location(digged_tile, X, Y)),
                    assertz(location(crop, X, Y)),
                    assertz(crop_data(CropName, X, Y, Hari)),
                    write('   You planted a '),
                    write(PlantSeed), nl
                );
                % else 
                (
                    write('   You don\'t have it in your inventory!'), nl            
                ) 
            )  

        );
        % else 
        (
            write('   You don\'t have any seed to plant'), nl   
        )
    
    );
    % else
    (
        write('   You cannot plant here, please find a digged tile'), nl
    ).

is_crop(X, Y) :- location(crop, X, Y).

is_harvestable(X,Y) :- 
    time(M,D),
    crop_data(CropName, X, Y, Hari),
    D >= Hari.

harvest :- has_not_started_game, !.
harvest :- has_not_started, !.
harvest :- has_ended, !.
harvest :- 
    location(player, X, Y),

    is_crop(X, Y) -> 
    (
        location(player, X, Y),
        is_harvestable(X, Y) ->
        (
            location(player, X, Y),
            retract(crop_data(CropName, X, Y, Hari)),
            retract(location(crop, X, Y)),
            tool(shovel, Lvl),                      
            NewTime is round(10 / (Lvl+2)),
            add_time(NewTime),
            exp_yield(CropName, Exp),
            mult_farming(M),
            TotalExp is round(Exp * M),
            add_farming(TotalExp),
            insert_inv(CropName),
            write('   You gained '),write(TotalExp),write(' farming exp!'),nl,                        
            write('   Yeay! You harvested 1 x '), 
            write(CropName),
            write('!'), nl, !
        );
        % else
        (
            write('   You can\'t harvest it right now! Be patient yea :\'V')
        )
        
    );
    % else 
    (
        write('   You don\'t have anything to harvest'),nl
    ).