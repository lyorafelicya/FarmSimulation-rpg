/* Modul: Ranching */

:- dynamic(chicken_list/1).
:- dynamic(cow_list/1).
:- dynamic(sheep_list/1).
:- dynamic(harvest_number/1).

/*Animal*/
chicken_list([]).
cow_list([]).
sheep_list([]).

count_animal(Animal, U) :-
    ((Animal == chicken  -> chicken_list(L) , length(L,U));
     (Animal == cow      -> cow_list(L)     , length(L,U));
     (Animal == sheep    -> sheep_list(L)   , length(L,U))).


print_ranch :-
    write('   Welcome to the Ranch! You have :'),nl,
    count_animal(chicken, CountC),
    count_animal(sheep  , CountS),
    count_animal(cow  , CountCow),
    write('  '),write(CountC)   ,write(' chicken'),nl,
    write('  '),write(CountS)   ,write(' sheep')  ,nl,
    write('  '),write(CountCow) ,write(' cow')    ,nl,nl,
    write('   Which livestock\'s product do you want to collect?'),nl,nl.

/*Add Livestock*/
/*Adding chicken*/
add_chicken(0) :- !.
add_chicken(Add):-
    collect_egg_time(T),
    retract(chicken_list(Current)),
    append(Current , [T] , NewCurrent),
    assertz(chicken_list(NewCurrent)),
    NewAdd is Add - 1,
    add_chicken(NewAdd).

/*Adding cow*/
add_cow(0) :- !.
add_cow(Add):-
    collect_milk_time(T),
    retract(cow_list(Current)),
    append(Current , [T] , NewCurrent),
    assertz(cow_list(NewCurrent)),
    NewAdd is Add - 1,
    add_cow(NewAdd).

/*Adding sheep*/
add_sheep(0) :- !.
add_sheep(Add):-
    collect_wool_time(T),
    retract(sheep_list(Current)),
    append(Current , [T] , NewCurrent),
    assertz(sheep_list(NewCurrent)),
    NewAdd is Add - 1,
    add_sheep(NewAdd).
    

/* Time to Collect */
collect_egg_time(T) :-
    time(_,Day),
    level_ranching(L),
    ((L < 2           -> T is Day + 3);
    ((L >= 2 , L < 5) -> T is Day + 2);
    (L > 4            -> T is Day + 1)).

collect_wool_time(T) :-
    time(_,Day),
    level_ranching(L),
    ((L < 2           -> T is Day + 6);
    ((L >= 2 , L < 4) -> T is Day + 5);
    (L == 4           -> T is Day + 4);
    (L > 4            -> T is Day + 3)).

collect_milk_time(T) :-
    time(_,Day),
    level_ranching(L),
    (L < 3 -> (T is Day + 3) ; (T is Day + 2)).


/* Collect egg */
collect_egg(N) :- 
    retract(chicken_list(L)),
    collect_egg_process(L, N, NewL),
    assertz(chicken_list(NewL)).

collect_egg_process([], 0, []) :- !.

collect_egg_process(List, N, NewL) :- 
    List = [Head|Tail],
    time(_, Day),
    Head =< Day -> 
        ( List = [Head|Tail],
          collect_egg_time(T),
          NewHead is T,
          collect_egg_process(Tail, NewN, NewTail),
          NewL = [NewHead|NewTail],
          N is NewN + 1  
        );
    % else
        ( List = [Head|Tail],
          collect_egg_process(Tail, N, NewTail),
          NewL = [Head|NewTail]
        ).

/* Collect wool */
collect_wool(N) :- 
    retract(sheep_list(L)),
    collect_wool_process(L, N, NewL),
    assertz(sheep_list(NewL)).

collect_wool_process([], 0, []) :- !.

collect_wool_process(List, N, NewL) :- 
    List = [Head|Tail],
    time(_, Day),
    Head =< Day -> 
        ( List = [Head|Tail],
          collect_wool_time(T),
          NewHead is T,
          collect_wool_process(Tail, NewN, NewTail),
          NewL = [NewHead|NewTail],
          N is NewN + 1  
        );
    % else
        ( List = [Head|Tail],
          collect_wool_process(Tail, N, NewTail),
          NewL = [Head|NewTail]
        ).

/* Collect milk */
collect_milk(N) :- 
    retract(cow_list(L)),
    collect_milk_process(L, N, NewL),
    assertz(cow_list(NewL)).

collect_milk_process([], 0, []) :- !.

collect_milk_process(List, N, NewL) :- 
    List = [Head|Tail],
    time(_, Day),
    Head =< Day -> 
        ( List = [Head|Tail],
          collect_milk_time(T),
          NewHead is T,
          collect_milk_process(Tail, NewN, NewTail),
          NewL = [NewHead|NewTail],
          N is NewN + 1  
        );
    % else
        ( List = [Head|Tail],
          collect_milk_process(Tail, N, NewTail),
          NewL = [Head|NewTail]
        ).
    

/*ERROR : BIKIN FUNGSI KHUSUS PRINT BANYAK EGG atau MILK atau WOOL YANG DITERIMA*/
/* Cause: If Then Else problem */

cek_chicken:-
    count_animal(chicken , Count),
    Count == 0 ->
        (
            write('   You haven\'t bought any chicken ~("v")~'),nl,
            write('   You can buy chicken at Market.'),nl
        );
        (
            collect_egg(N), !,
            assertz(harvest_number(N)),
            N == 0 ->
                (
                    retract(harvest_number(N)),
                    write('   Your chicken has\'t laid any egg'),nl,
                    write('   Please check again later.'),nl
                );
                (
                    retract(harvest_number(N)),
                    write('   Wow! some of your chickens have laid an egg!'),nl,
                    write('   You got '),write(N),write(' eggs!'),nl,
                    exp_yield(egg,Exp),
                    mult_ranching(Multi),
                    TotalExp is round(Exp * N * Multi),
                    add_ranching(TotalExp),
                    write('   You gained '),write(TotalExp),write(' ranching exp!'),nl,
                    insert_inv(egg, N)
                )
        ).

cek_sheep:-
    count_animal(sheep , Count),
    Count == 0 ->
        (
            write('   You haven\'t bought any sheep ~("v")~'),nl,
            write('   You can buy sheep at Market.'),nl
        );
        (
            collect_wool(N) , !, 
            assertz(harvest_number(N)),
            N == 0 ->
                (
                    retract(harvest_number(N)),
                    write('   Your sheep has\'t produced any wool'),nl,
                    write('   Please check again later.'),nl
                );
                (
                    retract(harvest_number(N)),
                    write('   Wow! All you sheeps have produced a wool!'),nl,
                    write('   You got '), write(N), write(' wools!'), nl,
                    exp_yield(wool,Exp),
                    mult_ranching(Multi),
                    TotalExp is round(Exp * N * Multi),
                    add_ranching(TotalExp),
                    write('   You gained '), write(TotalExp), write(' ranching exp!'), nl,
                    insert_inv(wool, N)
                )
        ).

cek_cow:-
    count_animal(cow , Count),
    Count == 0 ->
        (
            write('   You haven\'t bought any cow ~("v")~'),nl,
            write('   You can buy cow at Market.'),nl
        );
        (
            collect_milk(N), !,
            assertz(harvest_number(N)),
            N == 0 ->
                (
                    retract(harvest_number(N)),
                    write('   Your cow has\'t produced any milk'),nl,
                    write('   Please check again later.'),nl
                );
                (
                    retract(harvest_number(N)),
                    write('   Wow! All you sheeps have produced a wool!'),nl,
                    write('   You got '),write(N),write(' bottles full milk!'),nl,
                    exp_yield(milk,Exp),
                    mult_ranching(Multi),
                    TotalExp is round(Exp * N * Multi),
                    add_ranching(TotalExp),
                    write('   You gained '),write(TotalExp),write(' ranching exp!'),nl,
                    insert_inv(milk, N)
                )
        ).


is_near_ranch(X,Y) :- location(ranch,X,Y).

ranch :- has_not_started_game, !.
ranch :- has_not_started, !.
ranch :- has_ended, !.
ranch :-
    location(player,X,Y),
    is_near_ranch(X,Y) ->
    (
        barn_art,
        print_ranch,
        write('  >'),read(Animal),
        (((Animal == 'chicken') -> cek_chicken);
         ((Animal  == 'sheep')  -> cek_sheep);
         ((Animal  == 'cow')    -> cek_cow))
    );
    (
        write('   You are not at the Ranch! Go to the \'R\' tile to use this command.'),nl
    ).