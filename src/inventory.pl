/* Modul: Inventory */

:- dynamic(inv/1).
inv([(shovel, 1), (fishing_rod, 1)]).

max_inv(100).


/* Command umum */
inventory :- has_not_started_game, !.
inventory :- has_not_started, !.
inventory :- has_ended, !.
inventory :- print_inv, !.

throw_item :- has_not_started_game, !.
throw_item :- has_not_started, !.
throw_item :- has_ended, !.
throw_item :- write('  Format of use: throw_item(Item) or throw_item(Item, Qty).'), nl, !.

throw_item(Item) :- has_not_started_game, !.
throw_item(Item) :- has_not_started, !.
throw_item(Item) :- has_ended, !.
throw_item(Item) :- delete_inv(Item), !.

throw_item(Item, Qty) :- has_not_started_game, !.
throw_item(Item, Qty) :- has_not_started, !.
throw_item(Item, Qty) :- has_ended, !.
throw_item(Item, Qty) :- delete_inv(Item, Qty), !.

summon_item :- has_not_started_game, !.
summon_item :- has_not_started, !.
summon_item :- has_ended, !.
summon_item :- write('  Format of use: summon_item(Item) or summon_item(Item, Qty).'), nl, !.

summon_item(Item) :- has_not_started_game, !.
summon_item(Item) :- has_not_started, !.
summon_item(Item) :- has_ended, !.
summon_item(Item) :- insert_inv(Item), !.

summon_item(Item, Qty) :- has_not_started_game, !.
summon_item(Item, Qty) :- has_not_started, !.
summon_item(Item, Qty) :- has_ended, !.
summon_item(Item, Qty) :- insert_inv(Item, Qty), !.

/* Search Item */

search_inv(Item) :- 
    inv(I),
    search_item_process(I, Item).

search_item_process(Inv, Item) :-
    Inv = [Head|Tail],
    Head = (HeadItem, HeadQty),
    HeadItem == Item -> 
        !;
    % else
        ( Inv = [Head|Tail],
          search_item_process(Tail, Item)).

/* Check item quantity */

item_quantity(Item, Qty) :-
    inv(I),
    item_quantity_process(I, Item, Qty).

item_quantity_process(Inv, Item, Qty) :-
    Inv = [Head|Tail],
    Head = (HeadItem, HeadQty),
    HeadItem == Item -> 
        Qty is HeadQty, !;
    % else
        ( Inv = [Head|Tail],
          item_quantity_process(Tail, Item, Qty)).


/* Insert Item ke dalam inventory */

insert_inv(Item) :- insert_inv(Item, 1).

insert_inv(Item, Qty) :-
    count_item(N),
    max_inv(Max),
    (N + Qty) > Max, !,
    write('Your inventory is full!'), nl,
    QtyValid is Max - N,
    QtyInvalid is Qty - QtyValid,
    insert_inv(Item, QtyValid),
    write('Failed to get '), write(QtyInvalid), write(' x '), write(Item), nl, nl.


insert_inv(Item, Qty) :- 
    retract(inv(I)),
    insert_item_process(I, Item, Qty, NewI),
    assertz(inv(NewI)).

insert_item_process([], Item, Qty, [(Item, Qty)]) :- !.
insert_item_process(Inv, Item, 0, Inv) :- !.

insert_item_process(Inv, Item, Qty, NewInv) :-
    Inv = [Head|Tail],
    Head = (HeadItem, HeadQty),
    HeadItem == Item -> 
        ( Inv = [Head|Tail],
          Head = (HeadItem, HeadQty),
          NewQty is HeadQty + Qty,
          NewHead = (HeadItem, NewQty),
          NewInv = [NewHead|Tail], !
        );
    % else
        ( Inv = [Head|Tail],
          Head = (HeadItem, HeadQty),
          insert_item_process(Tail, Item, Qty, NextInv),
          NewInv = [Head|NextInv], !
        ).


/* Delete Item dari inventory */

delete_inv(Item) :- delete_inv(Item, 1).

delete_inv(Item, Qty) :- 
    retract(inv(I)),
    delete_item_process(I, Item, Qty, NewI),
    assertz(inv(NewI)).

delete_item_process([], Item, Qty, []) :- 
    write('   Item not found!'), nl, !.

delete_item_process(I, fishing_rod, Qty, I) :-
    write('   You cannot throw away your fishing rod!'), nl, !.

delete_item_process(I, shovel, Qty, I) :-
    write('   You cannot throw away your shovel!'), nl, !.

delete_item_process(Inv, Item, Qty, NewInv) :-
    Inv = [Head|Tail],
    Head = (HeadItem, HeadQty),
    HeadItem == Item -> 
        ( Inv = [Head|Tail],
          Head = (HeadItem, HeadQty),
          NewQty is HeadQty - Qty,
          NewQty < 0 -> 
            (write('   You don\'t have enough items!'), nl, NewInv = Inv);
          % else
            ( Inv = [Head|Tail],
              Head = (HeadItem, HeadQty),
              NewQty is HeadQty - Qty,
              NewQty > 0 ->
              ( Inv = [Head|Tail],
                Head = (HeadItem, HeadQty),
                NewQty is HeadQty - Qty,
                NewHead = (HeadItem, NewQty),
                NewInv = [NewHead|Tail]
              );
              ( Inv = [Head|Tail],
                NewInv = Tail
              )
            )
        );
    % else
        ( Inv = [Head|Tail],
          Head = (HeadItem, HeadQty),
          delete_item_process(Tail, Item, Qty, NextInv),
          NewInv = [Head|NextInv]
        ).


/* Print daftar item dalam inventory */
print_inv :-
    inv(I),
    nl,
    write('   Here is your inventory!'), nl,
    print_list(I).

print_list([]) :- !.
print_list(List) :-
    List = [Head|Tail],
    Head = (Item, Qty),
    write('      '),
    write(Qty),
    write(' x '),
    write(Item),
    nl,
    print_list(Tail).


/* Print daftar seed dalam inventory */
print_seed :-
    inv(I),
    print_seed(I).

print_seed([]) :- !.
print_seed(List) :-
    List = [Head|Tail],
    Head = (Item, Qty),
    seed(Item) ->
        ( List = [Head|Tail],
          Head = (Item, Qty),
          write('   '),
          write(Item),
          write('   x '),
          write(Qty),
          nl,
          print_seed(Tail)
        );
    % else
        ( List = [Head|Tail],
          print_seed(Tail)
        ).


/* Menghitung jumlah item dalam inventory */
count_item(N) :- 
    inv(I),
    count_item_process(I,N).

count_item_process([], 0) :- !.

count_item_process(Inv, N) :-
    Inv = [Head|Tail],
    Head = (Item, Qty),
    count_item_process(Tail, NextN),
    N is Qty + NextN.


/* Menghitung jumlah fish dalam inventory */
count_fish(N) :- 
    inv(I),
    count_fish_process(I,N).

count_fish_process([], 0) :- !.

count_fish_process(Inv, N) :-
    Inv = [Head|Tail],
    Head = (Item, Qty),
    fish(Item) -> 
        ( Inv = [Head|Tail],
          Head = (Item, Qty), 
          count_fish_process(Tail, NextN),
          N is Qty + NextN );
    % else
        ( Inv = [Head|Tail],
          Head = (Item, Qty),
          count_fish_process(Tail, NextN),
          N is NextN ).


/* Menghitung jumlah crop dalam inventory */
count_crop(N) :- 
    inv(I),
    count_crop_process(I,N).

count_crop_process([], 0) :- !.

count_crop_process(Inv, N) :-
    Inv = [Head|Tail],
    Head = (Item, Qty),
    crop(Item) -> 
        ( Inv = [Head|Tail],
          Head = (Item, Qty), 
          count_crop_process(Tail, NextN),
          N is Qty + NextN );
    % else
        ( Inv = [Head|Tail],
          Head = (Item, Qty),
          count_crop_process(Tail, NextN),
          N is NextN ).

/* Menghitung jumlah seed dalam inventory */
count_seed(N) :- 
    inv(I),
    count_seed_process(I,N).

count_seed_process([], 0) :- !.

count_seed_process(Inv, N) :-
    Inv = [Head|Tail],
    Head = (Item, Qty),
    seed(Item) -> 
        ( Inv = [Head|Tail],
          Head = (Item, Qty), 
          count_seed_process(Tail, NextN),
          N is Qty + NextN );
    % else
        ( Inv = [Head|Tail],
          Head = (Item, Qty),
          count_seed_process(Tail, NextN),
          N is NextN ).

/* Menghitung jumlah product dalam inventory */
count_product(N) :- 
    inv(I),
    count_product_process(I,N).

count_product_process([], 0) :- !.

count_product_process(Inv, N) :-
    Inv = [Head|Tail],
    Head = (Item, Qty),
    product(Item) -> 
        ( Inv = [Head|Tail],
          Head = (Item, Qty), 
          count_product_process(Tail, NextN),
          N is Qty + NextN );
    % else
        ( Inv = [Head|Tail],
          Head = (Item, Qty),
          count_product_process(Tail, NextN),
          N is NextN ).