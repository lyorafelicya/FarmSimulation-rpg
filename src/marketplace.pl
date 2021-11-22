/* File: marketplace.pl */
/* belum selesai */
/*
:- include('fact.pl').
:- include('update.pl').

:- dynamic(seed/1).
:- dynamic(price/2).

market :-
    write('Welcome to the market! What do you want to do?'),nl,
    write('1. Buy'), nl,
    write('2. Sell'), nl,
    write('> '), read(Action), nl,
    (Action == 'buy' -> buy);
     Action == 'sell' -> sell).
    
buy :-
    write('What do you want to buy? '),
    read(Item), nl,
    write('How many do you want to buy? '),
    read(Amount),nl,
    item == seed(Item) ;product(Item) ->
    (
        Money >= price(Item,X) ->
        (
            retract(Money),
            NewMoney is Money - price(Item,X),
            assert(NewMoney),
            append_inv(Item),
                
        );
        write('You don\'t have enough money to buy this item!'),
    ).
       

sell :-
    write('Here are the items in your inventory'), nl,
    print_inv,
    write('What do you want to sell? '), read(InvItem), nl,
    write('How many do you want to sell? '), read(Amount), nl.


print_buy :-

print_seed :- 
    seed(X),
    write(X),
    write(' ').

print_price :- 
    seed(X),
    Seedname is X, 
    price(Seedname, Price),
    write('('),
    write(Price),
    write(' golds)').

*/

