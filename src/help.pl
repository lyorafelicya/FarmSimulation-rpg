/* Modul: Help */

help :- has_not_started_game, !.
help :- has_not_started, !.
help :- has_ended, !.

help :-
    write('    ---------------------(> ^_^)>---------------------(*/w\\*)-------------------'),nl,
    write('    ----------------Don\'t worry, God will help you uWu--------------------------'),nl,
    write('    ----------\\(* v *)/---------------------------------------------------------'),nl,
    write('    ----------------Here are the list of commands that you can use--------------'),nl,
    write('    ----------------But read the condition clearly okay!------------------------'),nl,
    write('    ----------------------------------------------------------------------------'),nl,
    write('    1. start         -> start playing the game                                  '),nl,
    write('    2. status        -> see your status                                         '),nl,
    write('    3. map           -> display map                                             '),nl,
    write('    4. inventory     -> display inventory                                       '),nl,
    write('    5. quest         -> take a new quest                                        '),nl,
    write('    6. time          -> show current time                                       '),nl,
    write('    7.  w            -> move a step to the north                                '),nl,
    write('    8.  a            -> move a step to the west                                 '),nl,
    write('    9.  s            -> move a step to the south                                '),nl,
    write('    10. d            -> move a step to the east                                 '),nl,
    write('    11. ranch        -> enter ranch to harvest livestock\'s products            '),nl,
    write('                        use this command only when in position (R)              '),nl,
    write('    12. fishing      -> do fishing                                              '),nl,
    write('                        use this command only when you are near the pond (o)    '),nl,
    write('    13. dig          -> dig a tile                                              '),nl,
    write('                        use this command only when you are in tile (-)          '),nl,
    write('    14. plant        -> plant a seed                                            '),nl,
    write('                        use this command only when you are in a digged tile (=) '),nl,
    write('    15. harvest      -> harvest a crop                                          '),nl,
    write('                        use this command only when you are above the crop (c)   '),nl,
    write('    16. market       -> enter marketplace (M)                                   '),nl,
    write('                        you can buy/sell things here                            '),nl,
    write('    17. throw_item   -> throw your item(s) from inventory                       '),nl,
    write('    18. quit         -> quit game                                               '),nl,
    write('    ----------------------------------------------------------------------------'),nl, 
    write('    ----------------------------------------------------------------------------'),nl,
    write('    ----------------------------------------------------------------------------'),nl.


start_command :-
    write('              ^  ^                                              '),nl,
    write('     __| |___(*^-^)______________________________________| |__  '),nl,
    write('    (__   _____U_U_______________________________________   __) '),nl,
    write('       | |      *.     .                   .  *.     .   | |    '),nl,
    write('       | |    *  . * .  * IRASSHAIMASE .*  .* . .  *     | |    '),nl,
    write('       | |                                               | |    '),nl,
    write('       | |    start      -> start playing the game       | |    '),nl,
    write('       | |                                               | |    '),nl,
    write('       | |    quit       -> quit the game                | |    '),nl,
    write('       | |                                               | |    '),nl,
    write('     __| |_______________________________________________| |__  '),nl,
    write('    (__   _______________________________________________   __) '),nl, 
    write('       | |                                               | |    '),nl,nl.