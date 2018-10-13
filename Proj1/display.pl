intialBoard(
[0,0,0,0,0],
[0,0,0,0,0,0],
[0,0,0,0,0,0,0],
[0,0,0,0,0,0,0,0],
[0,0,0,0,0,0,0,0,0],
[0,0,0,0,0,0,0,0],
[0,0,0,0,0,0,0],
[0,0,0,0,0,0],
[0,0,0,0,0])



print_tab([]).
print_tab[L|T]:-
	print_line(L),
	nl,
	print_tab(T).
	
print_line([]).
print_line([C|L]):-
	print_cell(C),
	print_line(L).
	
print_cell(C):-
	traduz(C,V),
	write(V).
	
traduz(0,' ').
traduz(1,'X').
traduz(2,'O').

