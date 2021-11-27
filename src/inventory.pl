/* Modul: Inventory */

:- dynamic(inv/1).
inv([(bok_choy,10), (milk,100), (sardine, 20), (bok_choy_seed, 100)]).

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
    retract(inv(I)),
    insert_item_process(I, Item, Qty, NewI),
    assertz(inv(NewI)).

insert_item_process([], Item, Qty, [(Item, Qty)]) :- !.

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
          NewInv = [Head|NextInv]
        ).


/* Delete Item dari inventory */

delete_inv(Item) :- delete_inv(Item, 1).

delete_inv(Item, Qty) :- 
    retract(inv(I)),
    delete_item_process(I, Item, Qty, NewI),
    assertz(inv(NewI)).

delete_item_process([], Item, Qty, []) :- 
    write('Item not found!'), nl, !.

delete_item_process(Inv, Item, Qty, NewInv) :-
    Inv = [Head|Tail],
    Head = (HeadItem, HeadQty),
    HeadItem == Item -> 
        ( Inv = [Head|Tail],
          Head = (HeadItem, HeadQty),
          NewQty is HeadQty - Qty,
          NewHead = (HeadItem, NewQty),
          NewInv = [NewHead|Tail], !
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
    print_list(I).

print_list([]) :- !.
print_list(List) :-
    List = [Head|Tail],
    Head = (Item, Qty),
    write('  '),
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
