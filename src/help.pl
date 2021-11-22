/* File: help.pl */

/* Sementara gini dulu i think (?) */

help :-
    write('----------------(> ^_^)>-------------(*/w\\*)------------------------'),nl,    
    write('-----------------Don\'t worry we will help you uWu-------------------'),nl,
    write('-----\\(* v *)/------------------------------------------------------'),nl,
    write('------------Here are the list of commands that you can use-----------'),nl,    
    write('------------But read the condition clearly okay!---------------------'),nl,  
    write('---------------------------------------------------------------------'),nl,     
    write('1. start      -> start playing the game                              '),nl,
    write('2. status     -> see your status                                     '),nl,    
    write('3. map        -> display map                                         '),nl,
    write('4. inventory  -> display inventory                                   '),nl,
    write('5. quest      -> show your on-going quest                            '),nl,
    write('6. w          -> move a step to the north                            '),nl,
    write('7. s          -> move a step to the south                            '),nl,
    write('8. d          -> move a step to the east                             '),nl,
    write('9. a          -> move a step to the west                             '),nl,
    write('10. enter     -> enter market/ranch/quest hall/house                 '),nl,
    write('                 use this command only when in position              '),nl,
    write('11. fish      -> fishing                                             '),nl,   
    write('                 use this command only when u are near to the water  '),nl, 
    write('12. farming   -> dig/plant/harvest                                   '),nl,   
    write('                 use this command only when u are in tile            '),nl, 
    write('13. cheat     -> use this command to cheat :V                        '),nl,      
    write('14. quit      -> quit game                                           '),nl, 
    write('---------------------------------------------------------------------'),nl,  
    write('---------------------------------------------------------------------'),nl,
    write('---------------------------------------------------------------------'),nl. 


start_command :-
    write('          ^  ^                                              '),nl,
    write(' __| |___(*^-^)______________________________________| |__  '),nl,
    write('(__   _____U_U_______________________________________   __) '),nl,
    write('   | |      *.     .                   .  *.     .   | |    '),nl,
    write('   | |    *  . * .  * IRASSHAIMASE .*  .* . .  *     | |    '),nl,
    write('   | |                                               | |    '),nl,
    write('   | |   1. start      -> start playing the game     | |    '),nl,                    
    write('   | |   2. status     -> see your status            | |    '),nl,                      
    write('   | |   3. map        -> display map                | |    '),nl,                       
    write('   | |   4. up         -> move a step to the north   | |    '),nl,                        
    write('   | |   5. down       -> move a step to the south   | |    '),nl,                            
    write('   | |   6. right      -> move a step to the east    | |    '),nl,                           
    write('   | |   7. left       -> move a step to the west    | |    '),nl,                        
    write('   | |   8. help       -> ask for a help             | |    '),nl,                          
    write('   | |   9. quit       -> quit the game              | |    '),nl,                        
    write('   | |                                               | |    '),nl,
    write(' __| |_______________________________________________| |__  '),nl, 
    write('(__   _______________________________________________   __) '),nl, 
    write('   | |                                               | |    '),nl,nl.
