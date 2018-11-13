startGame(Player1, Player2) :-
    initialBoard(InitialBoard),
    display_game(InitialBoard),
    gameLoop(InitialBoard).

movePiece(Board,NewBoard,Simbol) :-
    choosePiece(Board,Simbol,Row,NumColumn),!,
    ((checkPiece(Board,Row,NumColumn,Simbol,NewBoard) -> movePiece(Board, NewBoard,Simbol));
    replaceRows(Board,Row,NumColumn,0,NewBoard)).

choosePiece(Board,Simbol,Row,NumColumn) :-
    write('Which piece you would like to move?\n'),
    askRow(Row),
    askColumn(Column),
    numberColumn(Column,NumColumn).


gameLoop(Board) :-
    movePiece(Board,NewBoard,1),
    display_game(NewBoard),
    movePiece(NewBoard,RoundBoard,2),
    display_game(RoundBoard),
    gameLoop(RoundBoard).

checkPiece(Board,Row,NumColumn,Simbol,NewBoard) :-
    nth1(Row,Board,List),
    nth1(NumColumn,List,Value),
    write('Value is '),write(Value),nl,
    write('Simbol is '),write(Simbol),nl,
    Value \= Simbol,
    write('bota').

    



replaceColumns([_|T], 1, Value, [Value|T]).
replaceColumns([C|T], Column, Value, [C|TNew]) :-
        Column > 1,
        Column1 is Column - 1,
        replaceColumns(T, Column1, Value, TNew).

replaceRows([L|T], 1, Column,Value, [LNew|T]) :-
        replaceColumns(L, Column, Value, LNew).

replaceRows([L|T], Row, Column, Value, [L|TNew]) :-
        Row > 1,
        Row1 is Row - 1,
        replaceRows(T, Row1, Column, Value, TNew).
