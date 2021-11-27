/* Modul: Marketplace */

:- include('map.pl').
:- include('fact.pl').
:- include('update.pl').
:- include('inventory.pl').

:- dynamic(tool/2).
tool(shovel, 1).
tool(fishing_rod, 1).

:- dynamic(money/1).
money(1000).

:- dynamic(level_shovel/1).
:- dynamic(level_fishing_rod/1).

level_shovel(1).
level_fishing_rod(1).

:- dynamic(level/1).
:- dynamic(job/1).

:- dynamic(level_farming/1).
:- dynamic(exp_farming/1).
:- dynamic(level_fishing/1).
:- dynamic(exp_fishing/1).
:- dynamic(level_ranching/1).
:- dynamic(exp_ranching/1).

:- dynamic(mult_farming/1).
:- dynamic(mult_fishing/1).
:- dynamic(mult_ranching/1).


/*DEFAULT PLAYER STATE*/
level(1).

mult_farming(1).
level_farming(1).
exp_farming(0).

mult_fishing(1).
level_fishing(1).
exp_fishing(0).

mult_ranching(1).
level_ranching(1).
exp_ranching(0).

market :-
    location(player, X, Y),
    location(market, X, Y) ->
    (
        write('Welcome to the market! What do you want to do?'),nl,
        write('1. Buy'), nl,
        write('2. Sell'), nl,
        write('> '), read(Action), nl,
        ((Action == 'buy' -> buy);
         (Action == 'sell' -> sell))
    );
    write('You are not at the market! Go to the \'M\' tile to use this command.').
    
buy :-
    print_buy,
    write('What do you want to buy? '), read(Item), nl,
    
    (
        seed(Item) ->
        (
            write('How many do you want to buy? '), read(Amount), nl,
            money(Money), price(Item,X),
            Money >= (X * Amount) ->
            (
                retract(money(Money)),
                NewMoney is Money - (Amount*X),
                assertz(money(NewMoney)),
                insert_inv(Item,Amount),
                write('You have bought '), write(Amount),write(' '), write(Item), write('!')
            );
            write('You don\'t have enough money to buy this item!'), nl
        );

        livestock(Item) ->
        (
            write('How many do you want to buy? '), read(Amount), nl,
            money(Money), price(Item,X),
            Money >= (X * Amount) ->
            (
                Item == 'chicken' -> add_chicken(Amount);
                Item == 'sheep' -> add_sheep(Amount);
                Item == 'cow' -> (add_cow(Amount)),
                retract(money(Money)),
                NewMoney is Money - (Amount*X),
                assertz(money(NewMoney)),
                write('You have bought '), write(Amount), write(Item), write('!')
            );
            write('You don\'t have enough money to buy this item!'), nl
        );
        
        tool(Item, _) ->
        (
            money(Money), price(Item,X),
            Money >= (Amount * X) ->
            (
                price_tool(Item, Price),
                retract(money(Money)),
                NewMoney is Money - Price,
                assertz(money(NewMoney)),
                retract(tool(Item, Lvl)),
                NewLvl is Lvl + 1,
                assertz(tool(Item, NewLvl)),
                write('Your '), write(Item), write('has been upgraded to level '), write(NewLvl), write('!'),nl
            );
            write('You don\'t have enough money to buy this item!'), nl
        )
    ).
       

sell :-
    write('Here are the items in your inventory'), nl,
    print_sell,
    write('What do you want to sell? '), read(InvItem), nl,
    
    /* cek input sesuai */
    search_inv(InvItem) -> 
    (
        write('How many do you want to sell? '), read(Qty), nl,
        item_quantity(InvItem, InvQty),
        InvQty >= Qty ->
        (
            price(InvItem,X),
            GetMoney is Qty * X,
            retract(money(Money)),
            NewMoney is Money + GetMoney,
            assertz(money(NewMoney)),
            delete_inv(InvItem,Qty),
            write('You sold '), write(Qty), write(InvItem), write('.'), nl,
            write('You received '), write(GetMoney), write(' golds.'), nl
        );
        % else 
        (
            write('You don\'t have enough items in your inventory!'), nl
        )
        
    );
    write('You don\'t have this item in your inventory!'), nl.

print_sell :-
    print_product,
    print_crop,
    print_fish.

print_product :-
    forall(
        product(X), 
        ( search_inv(X) ->
          (
            count_product(Qty),
            write(Qty), write(' '), write(X), nl);
            level(L)
        )
    ).

print_crop :-
    forall(
        crop(X), 
        (search_inv(X) ->
            (
            count_crop(Qty),
            write(Qty), write(' '), write(X), nl);
            level(L)
        )
    ).

print_fish :-
    forall(
        fish(X), 
        (search_inv(X) ->
            (
            count_crop(Qty),
            write(Qty), write(' '), write(X), nl);
            level(L)
        )
    ).


print_buy :- 
    print_tool_price,
    print_seed_price,
    print_livestock_price.

print_seed_price :- 
    forall(
        seed(X),
        (price(X, Price),
        write(X),
        write(' '),
        write('('),
        write(Price),
        write(' g)'), nl)
    ).

print_livestock_price :-
    forall(
        livestock(X),
        (price(X, Price),
        write(X),
        write(' '),
        write('('),
        write(Price),
        write(' g)'), nl)
    ).

print_tool_price :-
    print_shovel_price,
    print_fishing_rod_price.
    

print_shovel_price :-
    tool(X,Lvl),
    level_farming(Y),
    (X == shovel, Lvl < Y) ->
    (
        write(X), 
        write(' level '), 
        NextLevel is Lvl+1,
        write(NextLevel),
        price_tool(X,Price),
        price_shovel(Price),
        write(' ('),
        write(Price),
        write(' g)'),
        nl
    );
    level(L).

print_fishing_rod_price :-
    tool(X,Lvl),
    level_fishing(Y),
    (X == fishing_rod, Lvl < Y) ->
    (
        write(X), 
        write(' level '), 
        NextLevel is Lvl+1,
        write(NextLevel), 
        price_tool(X,Price),
        price_fishing_rod(Price),
        write(' ('),
        write(Price),
        write(' g)'), 
        nl
    );
    level(L).
    
price_tool(Tool, Price) :-
    (Tool == shovel -> price_shovel(Price));
    (Tool == fishing_rod -> price_fishing_rod(Price)).

price_shovel(Price) :-
    level_shovel(L),
    NextLvl is L + 1,
    Price is round(10 * NextLvl * NextLvl * log(NextLvl + 1)).

price_fishing_rod(Price) :-
    level_fishing_rod(L),
    NextLvl is L + 1,
    Price is round(10 * NextLvl*NextLvl * log(NextLvl + 1)).