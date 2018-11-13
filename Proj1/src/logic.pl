startGame(Player1, Player2) :-
    initialBoard(InitialBoard),
    display_game(InitialBoard),
    gameLoop(InitialBoard).

movePiece(Board,NewBoard,Symbol) :-
    write('Which piece you would like to move?\n'),
    chooseCell(Row,NumColumn),!,
    ((checkCell(Board,Row,NumColumn,Symbol) -> movePiece(Board, NewBoard,Symbol));
    (replaceRows(Board,Row,NumColumn,0,BoardAux),
    chooseDest(BoardAux,NewBoard,Symbol,Row,NumColumn))).

chooseDest(Board,NewBoard,Symbol,Row,NumColumn) :-
    write('To Where?\n'),
    chooseCell(Row1,NumColumn1),!,
    ((checkCell(Board,Row1,NumColumn1,0) -> chooseDest(Board, NewBoard,Symbol));
    replaceRows(Board,Row1,NumColumn1,Symbol,NewBoard)).

chooseCell(Row,NumColumn) :-
    askRow(RowAux),
    numberRow(RowAux,Row),
    askColumn(Column),
    numberColumn(Column,NumColumn).

gameLoop(Board) :-
    movePiece(Board,NewBoard,1),
    display_game(NewBoard),
    movePiece(NewBoard,RoundBoard,2),
    display_game(RoundBoard),
    gameLoop(RoundBoard).

checkCell(Board,Row,NumColumn,Symbol) :-
    nth1(Row,Board,List),
    nth1(NumColumn,List,Value),
    Value \= Symbol.

    



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
