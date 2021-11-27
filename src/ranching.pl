/* Modul: Ranching */

:-include('map.pl').
:-include('update.pl').
:-include('art.pl').
:-include('inventory.pl').

:- dynamic(chicken_list/1).
:- dynamic(cow_list/1).
:- dynamic(sheep_list/1).


:- dynamic(level_ranching/1).
level_ranching(1).

:- dynamic(time/2).
time(360,1).

/*Animal*/
chicken_list([]).
cow_list([]).
sheep_list([]).

count_animal(Animal, U) :-
    ((Animal == chicken  -> chicken_list(L) , length(L,U));
     (Animal == cow      -> cow_list(L)     , length(L,U));
     (Animal == sheep    -> sheep_list(L)   , length(L,U))).


print_ranch :-
    write('Welcome to the Ranch! You have :'),nl,
    count_animal(chicken, CountC),
    count_animal(cow, CountS),
    count_animal(sheep, CountCow),
    write(CountC),write(' chicken'),nl,
    write(CountS),write(' sheep'),nl,
    write(CountCow),write(' cow'),nl,nl,
    write('Which livestock\'s product do you want to collect?'),nl,nl.

/*Add Livestock*/
/*Adding chicken*/
add_chicken(0) :- !.
add_chicken(Add):-
    time(M,Day),
    collect_egg_time(T),
    retract(chicken_list(Current)),
    append(Current , [T] , NewCurrent),
    assertz(chicken_list(NewCurrent)),
    NewAdd is Add - 1,
    add_chicken(NewAdd).

/*Adding cow*/
add_cow(0) :- !.
add_cow(Add):-
    time(M,Day),
    collect_milk_time(T),
    retract(cow_list(Current)),
    append(Current , [T] , NewCurrent),
    assertz(cow_list(NewCurrent)),
    NewAdd is Add - 1,
    add_cow(NewAdd).

/*Adding sheep*/
add_sheep(0) :- !.
add_sheep(Add):-
    time(M,Day),
    collect_wool_time(T),
    retract(sheep_list(Current)),
    append(Current , [T] , NewCurrent),
    assertz(sheep_list(NewCurrent)),
    NewAdd is Add - 1,
    add_sheep(NewAdd).
    

/* Time to Collect */
collect_egg_time(T) :-
    time(M,Day),
    level_ranching(L),
    ((L < 2           -> T is Day + 3);
    ((L >= 2 , L < 5) -> T is Day + 2);
    (L > 4            -> T is Day + 1)).

collect_wool_time(T) :-
    time(M,Day),
    level_ranching(L),
    ((L < 2           -> T is Day + 6);
    ((L >= 2 , L < 4) -> T is Day + 5);
    (L == 4           -> T is Day + 4);
    (L > 4            -> T is Day + 3)).

collect_milk_time(T) :-
    time(M,Day),
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
    time(Min, Day),
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
    time(Min, Day),
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
    time(Min, Day),
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

cek_chicken(L,Day) :-
    count_animal(chicken , Count),
    Count == 0 ->
        (
            write('You haven\'t bought any chicken ~("v")~'),nl,
            write('You can buy chicken at Market.'),nl
        );
        (
            collect_egg(N),
            N == 0 ->
                (
                    write('Your chicken has\'t layed any egg'),nl,
                    write('Please check again later.'),nl
                );
                (
                    write('Wow! some of your chickens have laid an egg!'),nl,
                    write('You got '),write(N),write(' eggs!'),nl,
                    exp_yield(egg,Exp),
                    TotalExp = Exp * N,
                    exp_ranching(TotalExp),
                    write('You gained '),write(TotalExp),write(' ranching exp!'),nl
                )
        ).

cek_sheep(L,Day) :-
    count_animal(sheep , Count),
    Count == 0 ->
        (
            write('You haven\'t bought any sheep ~("v")~'),nl,
            write('You can buy sheep at Market.'),nl
        );
        (
            collect_wool(N),
            N == 0 ->
                (
                    write('Your sheep has\'t produced any wool'),nl,
                    write('Please check again later.'),nl
                );
                (
                    write('Wow! All you sheeps have produced a wool!'),nl,
                    write('You got '),write(N),write(' wools!'),nl,
                    exp_yield(wool,Exp),
                    TotalExp = Exp * N,
                    exp_ranching(TotalExp),
                    write('You gained '),write(TotalExp),write(' ranching exp!'),nl
                )
        ).

cek_cow(L,Day) :-
    count_animal(cow , Count),
    Count == 0 ->
        (
            write('You haven\'t bought any cow ~("v")~'),nl,
            write('You can buy cow at Market.'),nl
        );
        (
            collect_milk(N),
            N == 0 ->
                (
                    write('Your cow has\'t produced any milk'),nl,
                    write('Please check again later.'),nl
                );
                (
                    write('Wow! All you sheeps have produced a wool!'),nl,
                    write('You got '),write(N),write(' bottles full milk!'),nl,
                    exp_yield(milk,Exp),
                    TotalExp = Exp * N,
                    exp_ranching(TotalExp),
                    write('You gained '),write(TotalExp),write(' ranching exp!'),nl
                )
        ).



is_near_ranch(X,Y) :- location(ranch,X,Y).

ranch :-
    location(player,X,Y),
    is_near_ranch(X,Y) ->
    (
        barn_art,
        print_ranch,
        level_ranching(L),
        time(M,Day),
        read(Animal),
        (((Animal == 'chicken') -> cek_chicken(L,Day));
         ((Animal  == 'sheep')  -> cek_sheep(L,Day));
         ((Animal  == 'cow')    -> cek_cow(L,Day)))
    );
    (
        write('You are far from Ranch. Go to Ranch to do ranching.'),nl
    ).