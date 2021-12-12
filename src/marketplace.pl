/* Modul: Marketplace */

market :- has_not_started_game, !.
market :- has_not_started, !.
market :- has_ended, !.
market :-
    location(player, X, Y),
    location(market, X, Y) ->
    (
        write('   Welcome to the market! What do you want to do?'),nl,
        write('   1. buy'), nl,
        write('   2. sell'), nl,
        write('   > '), read(Action), nl,
        ((Action == 'buy' -> buy);
         (Action == 'sell' -> sell)), !
    );
    write('   You are not at the market! Go to the \'M\' tile to use this command.').

buy :- has_not_started_game, !.
buy :- has_not_started, !.
buy :- has_ended, !.  
buy :-
    location(player, X, Y),
    location(market, X, Y) ->
    (
        print_buy, nl,
        write('   What do you want to buy? '), read(Item), nl, !,
        
        (
            seed(Item) ->
            (
                write('   How many do you want to buy? '), read(Amount), nl,
                money(Money), price(Item, PriceEach),
                Money >= (PriceEach * Amount) ->
                (
                    Amount > 0 ->
                    (
                        count_item(N),
                        N + Amount =< 100 ->
                        (
                            ( Price is Amount * PriceEach,
                            sub_money(Price),
                            insert_inv(Item,Amount),
                            write('   You have bought '), write(Amount), write(' '), 
                            write(Item), write('!'), nl
                            )
                        );(write('   Your inventory is full! Purchase cancelled...'), nl)
                        
                    );( write('   The quantity is not valid!'), nl)
                );
                (write('   You don\'t have enough money to buy this item. Go earn more money first!'), nl)
            );

            livestock(Item) ->
            (
                write('   How many do you want to buy? '), read(Amount), nl,
                money(Money), price(Item, PriceEach),
                Money >= (PriceEach * Amount) ->
                (
                    Amount > 0 ->
                    (
                        (Item == 'chicken' -> (add_chicken(Amount));
                        Item == 'sheep' -> (add_sheep(Amount));
                        Item == 'cow' -> (add_cow(Amount))),
                        Price is Amount * PriceEach,
                        sub_money(Price),
                        write('   You have bought '), write(Amount), write(' '), 
                        write(Item), write('!'), nl
                    );
                    (write('   The quantity is not valid!'), nl)
                );
                write('   You don\'t have enough money to buy this item!'), nl
            );
            
            tool(Item, _) ->
            (
                money(Money), price_tool(Item, Price),
                Money >= Price ->
                (
                    price_tool(Item, Price),
                    sub_money(Price),
                    retract(tool(Item, Lvl)),
                    NewLvl is Lvl + 1,
                    assertz(tool(Item, NewLvl)),
                    write('   Your '), write(Item), write(' has been upgraded to level '), write(NewLvl), write('!'),nl
                );
                write('   You don\'t have enough money to buy this item! Go earn more money first!'), nl
            )
        )
    );
    write(   'You can only buy items at the Market!').
       
sell :- has_not_started_game, !.
sell :- has_not_started, !.
sell :- has_ended, !.
sell :-
    location(player, X, Y),
    location(market, X, Y) ->
    (
        count_fish(CFish), count_crop(CCrop), count_product(CProduct),
        ((CFish + CCrop + CProduct) > 0) ->
        (
            write('   Here are the items in your inventory'), nl,
            print_sell, nl,
            write('   What do you want to sell? '), read(InvItem), nl,
            
            /* cek input sesuai */
            search_inv(InvItem) -> 
            (
                write('   How many do you want to sell? '), read(Qty), nl,
                item_quantity(InvItem, InvQty),
                InvQty >= Qty ->
                (
                    Qty > 0 ->
                    ( price(InvItem, PriceEach),
                    GetMoney is Qty * PriceEach,
                    delete_inv(InvItem, Qty),
                    write('   You sold '), write(Qty), write(' '), write(InvItem), write('.'), nl,
                    write('   You received '), write(GetMoney), write(' golds.'), nl,
                    add_money(GetMoney)
                    ); % else
                    ( write('   The quantity is not valid!'), nl)
                );
                % else 
                (
                    write('   You don\'t have enough items in your inventory!'), nl
                )
                
            );
            write('   You don\'t have this item in your inventory!'), nl
        );
        write('   You don\'t have anything to sell!'), nl
    );
    write('   You can only sell your items at the Market!').


/* Print procedures */

print_sell :-
    print_product,
    print_crop,
    print_fish.

print_product :-
    forall(
        product(X), 
        ( search_inv(X) ->
            (
                item_quantity(X, Qty),
                write('     '), write(Qty), write(' '), write(X), nl
            );
            level(_)
        )
    ).

print_crop :-
    forall(
        crop(X), 
        (search_inv(X) ->
            (
                item_quantity(X, Qty),
                write('     '), write(Qty), write(' '), write(X), nl
            );
            level(_)
        )
    ).

print_fish :-
    forall(
        fish(X), 
        (search_inv(X) ->
            (
                item_quantity(X, Qty),
                write('     '), write(Qty), write(' '), write(X), nl
            );
            level(_)
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
        write('     '), 
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
        write('     '), 
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
        write('     '), 
        write(X), 
        write(' [Level '), 
        NextLevel is Lvl+1,
        write(NextLevel),
        write(']'),
        price_shovel(Price),
        write(' ('),
        write(Price),
        write(' g)'),
        nl
    );
    level(_).

print_fishing_rod_price :-
    tool(X,Lvl),
    level_fishing(Y),
    (X == fishing_rod, Lvl < Y) ->
    (
        write('     '), 
        write(X), 
        write(' [Level '), 
        NextLevel is Lvl+1,
        write(NextLevel), 
        write(']'),
        price_fishing_rod(Price),
        write(' ('),
        write(Price),
        write(' g)'), 
        nl
    );
    level(_).
    
price_tool(Tool, Price) :-
    (Tool == shovel -> price_shovel(Price));
    (Tool == fishing_rod -> price_fishing_rod(Price)).

price_shovel(Price) :-
    tool(shovel, L),
    NextLvl is L + 1,
    Price is round(10 * NextLvl * NextLvl * log(NextLvl + 1)).

price_fishing_rod(Price) :-
    tool(fishing_rod, L),
    NextLvl is L + 1,
    Price is round(10 * NextLvl*NextLvl * log(NextLvl + 1)).