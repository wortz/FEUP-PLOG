startGame(Player1, Player2) :-
    initialBoard(InitialBoard),
    display_game(InitialBoard),
    gameLoop(InitialBoard).

movePiece(Board,NewBoard,Simbol) :-
    write('Which piece you would like to move?\n'),
    askRow(Row),
    askColumn(Column),
    numberColumn(Column,NumColumn),
    replaceRows(Board,Row,NumColumn,0,AuxBoard),
    write('To where?\n'),
    askRow(Row1),
    askColumn(Column1),
    numberColumn(Column1,NumColumn1),
    replaceRows(AuxBoard,Row1,NumColumn1,Simbol,NewBoard).


gameLoop(Board) :-
    movePiece(Board,NewBoard,1),
    display_game(NewBoard),
    movePiece(NewBoard,RoundBoard,2),
    display_game(RoundBoard)
    gameLoop(RoundBoard).



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
