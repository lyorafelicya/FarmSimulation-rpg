/* Modul: Quest */

:- dynamic(quest_req/3).
:- dynamic(quest_reward/2).
:- dynamic(quest_basket/1).


/* Introduce Quest */

quest :- has_not_started_game, !.
quest :- has_not_started, !.
quest :- has_ended, !.

quest :- location(player, X, Y), \+ location(quest, X, Y), !,
    write('   You are not at the Quest Hall! Go to the \'Q\' tile to use this command.'),nl.

quest :- nl,
    quest_req(X, Y, Z),
    quest_reward(RewardGold, RewardExp), !,
    write('    --||    --- Emergency Quest ---    ||--    '), nl,
    nl,
    write('     Complete your quest before!'), nl,
    write('     Collect the items below:'), nl,
    write('     Fish    ('), write(X), write(')'), nl,
    write('     Crop    ('), write(Y), write(')'), nl,
    write('     Product ('), write(Z), write(')'), nl,
    write('     *'), nl,
    write('     Reward    : '), write(RewardGold), write(' g and '), write(RewardExp), write(' exp'), nl, 
    write('     Time limit: Before Winter Shogun attacks the village'), nl,
    write('     How-to    : claim_quest '), nl, nl.


quest :- nl,
    level(L),
    Min is L + 3,
    Max is Min + 3,
    random(Min, Max, X),
    random(Min, Max, Y),
    random(Min, Max, Z),
    write('    --||    --- Compulsory Quest ---    ||--    '), nl,
    nl,
    write('     Collect the items below:'), nl,
    write('     Fish    ('), write(X), write(')'), nl,
    write('     Crop    ('), write(Y), write(')'), nl,
    write('     Product ('), write(Z), write(')'), nl,
    RewardGold is (X+Y+Z) * 20,
    RewardExp is (X+Y+Z) * 2 * L,
    write('     *'), nl,
    write('     Reward    : '), write(RewardGold), write(' g and '), write(RewardExp), write(' exp'), nl, 
    write('     Time limit: None (probably)'), nl,
    write('     How-to    : claim_quest '), nl, nl,
    assertz(quest_req(X, Y, Z)),
    assertz(quest_reward(RewardGold, RewardExp)).


/* Claim Quest */

claim_quest :- location(player, X, Y), \+ location(quest, X, Y), !,
    write('   You are not at the Quest Hall! Go to the \'Q\' tile to use this command.'),nl.

claim_quest :- \+ quest_req(_, _, _), !,
    write('   You don\'t have ongoing quest! '), nl.

claim_quest :- nl,
    count_fish(A), count_crop(B), count_product(C),
    quest_req(X,Y,Z),
    A >= X, B >= Y, C >= Z, !,
    assertz(quest_basket([])),
    write('        --||        --- Claim Quest ---        ||--        '), nl,
    nl,
    collect_quest,
    retract(quest_req(X,Y,Z)),
    retract(quest_basket(Basket)),
    retract(quest_reward(RewardGold, RewardExp)),
    write('     The weather is getting colder. From the horizon,'), nl,
    write('     the Winter Shogun is approaching you. He is ready'), nl,
    write('     to decapitate you, but then he sees your bag.'), nl,
    write('     You are not tastier than what you have inside'), nl,
    write('     your bag, so he wants to trade your live for them.'), nl, nl,
    write('     He takes your items as following:'), nl,
    print_list(Basket),

    write('     He drops '), write(RewardExp), write(' exp and '), write(RewardGold), write(' g '),
    write('as he leaves.'), nl, nl,
    add_fishing(RewardExp),
    add_farming(RewardExp),
    add_ranching(RewardExp),
    add_money(RewardGold).


claim_quest :- nl,
     write('        --||        --- Collect Reward ---        ||--        '), nl,
    nl,
    write('     Finish collecting?              But...          '), nl,
    nl,
    write('     It seems you haven\'t collected enough items >"<'), nl, nl.


/* Collect Items */
collect_quest :- 
    take_quest_fish, inv(_),
    take_quest_crop,
    take_quest_product.

/* Collect Fish */
take_quest_fish :- 
    quest_req(X,_,_),
    retract(inv(I)), 
    take_quest_fish(I, X, NewI),
    assertz(inv(NewI)).

take_quest_fish(Inv, 0, NewInv) :- NewInv = Inv, !.

take_quest_fish(Inv, N, NewInv) :-
    quest_req(X,Y,Z),
    Inv = [Head|Tail],
    Head = (Item, Qty),
    fish(Item) ->
        ( min2(N, Qty, TakeQty),
          NewN is N - TakeQty,
          NewQty is Qty - TakeQty, 
          NewHead = (Item, NewQty),
          retract(quest_basket(B)),
          append(B, [(Item, TakeQty)], NewB),
          assertz(quest_basket(NewB)),
          take_quest_fish(Tail, NewN, NewTail),
          (NewQty == 0 -> NewInv = NewTail; NewInv = [NewHead|NewTail])
        );
    % else
        ( quest_req(X,Y,Z),
          Inv = [Head|Tail],
          take_quest_fish(Tail, N, NewTail),
          NewInv = [Head|NewTail]
        ).

/* Collect Crops */
take_quest_crop :- 
    quest_req(_,Y,_),
    retract(inv(I)), 
    take_quest_crop(I, Y, NewI),
    assertz(inv(NewI)).

take_quest_crop(Inv, 0, NewInv) :- NewInv = Inv, !.

take_quest_crop(Inv, N, NewInv) :-
    quest_req(X,Y,Z),
    Inv = [Head|Tail],
    Head = (Item, Qty),
    crop(Item) ->
        ( min2(N, Qty, TakeQty),
          NewN is N - TakeQty,
          NewQty is Qty - TakeQty,
          NewHead = (Item, NewQty),
          retract(quest_basket(B)),
          append(B, [(Item, TakeQty)], NewB),
          assertz(quest_basket(NewB)),
          take_quest_crop(Tail, NewN, NewTail),
          (NewQty == 0 -> NewInv = NewTail; NewInv = [NewHead|NewTail])
        );
    % else
        ( quest_req(X,Y,Z),
          Inv = [Head|Tail],
          take_quest_crop(Tail, N, NewTail),
          NewInv = [Head|NewTail]
        ).

/* Collect Products */
take_quest_product :- 
    quest_req(_,_,Z),
    retract(inv(I)), 
    take_quest_product(I, Z, NewI),
    assertz(inv(NewI)).

take_quest_product(Inv, 0, NewInv) :- NewInv = Inv, !.

take_quest_product(Inv, N, NewInv) :-
    quest_req(X,Y,Z),
    Inv = [Head|Tail],
    Head = (Item, Qty),
    product(Item) ->
        ( min2(N, Qty, TakeQty),
          NewN is N - TakeQty,
          NewQty is Qty - TakeQty,
          NewHead = (Item, NewQty),
          retract(quest_basket(B)),
          append(B, [(Item, TakeQty)], NewB),
          assertz(quest_basket(NewB)),
          take_quest_product(Tail, NewN, NewTail),
          (NewQty == 0 -> NewInv = NewTail; NewInv = [NewHead|NewTail])
        );
    % else
        ( quest_req(X,Y,Z),
          Inv = [Head|Tail],
          take_quest_product(Tail, N, NewTail),
          NewInv = [Head|NewTail]
        ).


/* Support function */
min2(A, B, C) :- 
    A >= B -> C is B ; C is A.