/* Modul: Fishing */

fishList([dory,catfish,anchovy,sardine,eel], 1).
fishList([archerfish,sunfish,flying_fish,puffer_fish], 2).
fishList([salmon,turtle,lionfish,koi,barracuda], 3).
fishList([billfish,tuna,stringray,piranha,king_crab], 4).
fishList([arowana,shark], 5).


repeatFish(1 , [Head | _ ] , Head).
repeatFish(Num , [Head | Tail] , Fish) :-
    NewNum is Num-1,
    repeatFish(NewNum , Tail , Res),
    Fish = Res.

getFish(1,Fish) :-
    fishList(List,1),
    random(1,5,Num),
    repeatFish(Num,List,Res),
    Fish = Res.

getFish(2,Fish) :-
    fishList(List,2),
    random(1,4,Num),
    repeatFish(Num,List,Res),
    Fish = Res.

getFish(3,Fish) :-
    fishList(List,3),
    random(1,5,Num),
    repeatFish(Num,List,Res),
    Fish = Res.

getFish(4,Fish) :-
    fishList(List,4),
    random(1,4,Num),
    repeatFish(Num,List,Res),
    Fish = Res.

getFish(5,Fish) :-
    fishList(List,5),
    random(1,2,Num),
    repeatFish(Num,List,Res),
    Fish = Res.


randomFish(1,Fish) :- !,
    getFish(1,Fish).

randomFish(2,Fish) :- !,
    random(1,11,Chance),
    (((Chance >= 1 , Chance < 6) -> getFish(1,Fish));
    ((Chance >= 6 , Chance < 11) -> getFish(2,Fish))).

randomFish(3,Fish) :- !,
    random(1,11,Chance),
    (((Chance >= 1 , Chance < 4) -> getFish(1,Fish));
    ((Chance >= 4 , Chance < 8) -> getFish(2,Fish));
    ((Chance >= 8 , Chance < 11) -> getFish(3,Fish))).

randomFish(4,Fish) :- !,
    random(1,11,Chance),
    (((Chance >= 1 , Chance < 3) -> getFish(1,Fish));
    ((Chance >= 3 , Chance < 6) -> getFish(2,Fish));
    ((Chance >= 6 , Chance < 8) -> getFish(3,Fish));
    ((Chance >= 8 , Chance < 11) -> getFish(4,Fish))).

randomFish(5,Fish) :- Level >= 5, !,
    random(1,11,Chance),
    (((Chance >= 1 , Chance < 2) -> getFish(1,Fish));
    ((Chance >= 2 , Chance < 5) -> getFish(2,Fish));
    ((Chance >= 5 , Chance < 7) -> getFish(3,Fish));
    ((Chance >= 7 , Chance < 8) -> getFish(4,Fish));
    ((Chance >= 8 , Chance < 11) -> getFish(5,Fish))).

isNearWater(X,Y) :- NewX is X+1 , location(water, NewX,Y).
isNearWater(X,Y) :- NewX is X-1 , location(water, NewX,Y).
isNearWater(X,Y) :- NewY is Y+1 , location(water, X,NewY).
isNearWater(X,Y) :- NewY is Y-1 , location(water, X,NewY).


fishing :- has_not_started_game, !.
fishing :- has_not_started, !.
fishing :- has_ended, !.
fishing :-
    location(player,X,Y),
    isNearWater(X,Y) ->
    (
        tool(fishing_rod, Level),
        randomFish(Level,Fish),
        insert_inv(Fish),
        write('   Wow! You caught '),write(Fish),write(' fish.'),nl,
        exp_yield(Fish,Exp),
        mult_fishing(M),
        TotalExp is round(M * Exp),
        write('   You gained '),write(Exp),write(' fishing exp!'),nl,
        nl,
        add_fishing(TotalExp), !,
        Minute is round(200 / (log(Level + 2) + 1)),
        add_time(Minute)
    );
    (
        write('   You are far from any pond. Find a pond for fishing.'),nl, nl
    ).