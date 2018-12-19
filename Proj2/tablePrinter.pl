%% a chamar com tableHeader(Months, 0)
tableHeader(Months,Months):-
    write('Total'), nl.
tableHeader(Months, Counter):-
    Counter1 is Counter + 1,
    write('M'+Counter+' '),
    tableHeader(Months,Counter1).

printSeparator:-write('___________________________________'), nl.

