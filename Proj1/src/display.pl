:-include('boards.pl').

printLetters:-write(' | H | G | F | E | D | C | B | A | '), nl.

printSeparator:-write('___________________________________'), nl.

display_game(Board):-
	printLetters, 
	printSeparator,
	print_tab(Board,['1','2','3','4','5','6','7','8']),
	printLetters,
	nl.

print_tab([],[]).
print_tab([L|T],[NL|NT]):-
	write(NL),
	write('|'),
	print_line(L),
	write(NL),
	nl,
	printSeparator,
	print_tab(T,NT).
	
print_line([]).
print_line([C|L]):-
	write(' '),
	print_cell(C),
	write(' |'),
	print_line(L).
	
print_cell(C):-
	traduz(C,V),
	write(V).
	
traduz(0,' ').
traduz(1,'R').
traduz(2,'W').



