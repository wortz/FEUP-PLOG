tableHeader(0,_):-
    write('Total'), nl.
tableHeader(Months, Counter):-
    write('M'+Counter+' '),
    Counter1 is Counter + 1,
    Months1 is Months+1, 
    tableHeader(Months1,Counter1).

printSeparator:-write('___________________________________'), nl.

