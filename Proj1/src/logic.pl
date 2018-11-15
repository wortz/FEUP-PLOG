startGame(Player1, Player2) :-
    initialBoard(InitialBoard),
    display_game(InitialBoard),
    gameLoop(InitialBoard).

movePiece(Board,NewBoard,Symbol) :-
    repeat,
    write('Which piece you would like to move?\n'),
    chooseCell(Row,NumColumn),
    checkCell(Board,Row,NumColumn,Symbol),!,
    replaceRows(Board,Row,NumColumn,0,BoardAux),
    chooseDest(BoardAux,NewBoard,Symbol,Row,NumColumn).

chooseDest(Board,NewBoard,Symbol,Row,NumColumn) :-
    listValidMoves(Board,Row,NumColumn,MovesList),
    repeat,
    write('To Where?\n'),
    chooseCell(Row1,NumColumn1),
    checkValidMove(MovesList,Row1,NumColumn1),!,
    replaceRows(Board,Row1,NumColumn1,Symbol,NewBoard).

chooseCell(Row,NumColumn) :-
    askRow(RowAux),
    numberRow(RowAux,Row),
    askColumn(Column),
    numberColumn(Column,NumColumn),!.

gameLoop(Board) :-
    movePiece(Board,NewBoard,1),
    display_game(NewBoard),
    checkWin([[3,8],[1,6],[3,4],[5,6]]),
    movePiece(NewBoard,RoundBoard,2),
    display_game(RoundBoard),
    gameLoop(RoundBoard).

checkCell(Board,Row,NumColumn,Symbol) :-
    nth1(Row,Board,List),
    nth1(NumColumn,List,Value),!,
    Value =:= Symbol.

listValidMoves(Board,Row,NumColumn,MovesList):-
    listColumnDown(Board,MovesList1,Row,NumColumn,TempMovesList),
    listColumnUp(Board,MovesList2,Row,NumColumn,TempMovesList1),
    listRowRight(Board,MovesList3,Row,NumColumn,TempMovesList2),
    listRowLeft(Board,MovesList4,Row,NumColumn,TempMovesList3),
    append(MovesList1,MovesList2,MovesListAux),
    append(MovesListAux,MovesList3,MovesListAux1),
    append(MovesListAux1,MovesList4,MovesList),
    write('You can move the piece to : \n'),
    print_list(MovesList).

listColumnDown(Board,FinalList,Row,NumColumn,ListTemp) :-
    Row1 is Row + 1,
    ((Row1 < 9 ,  checkCell(Board,Row1,NumColumn,0))
    -> (
        numberColumn(Column,NumColumn),
        append(ListTemp,[[Row1,Column]],ListAux),
        listColumnDown(Board,FinalList,Row1,NumColumn,ListAux));
    append([],ListTemp,FinalList)).

listColumnUp(Board,FinalList,Row,NumColumn,ListTemp) :-
    Row1 is Row - 1,
    ((Row1 > 0 ,  checkCell(Board,Row1,NumColumn,0))
    -> (
        numberColumn(Column,NumColumn),
        append(ListTemp,[[Row1,Column]],ListAux),
        listColumnUp(Board,FinalList,Row1,NumColumn,ListAux));
    append([],ListTemp,FinalList)).

listRowRight(Board,FinalList,Row,NumColumn,ListTemp) :-
    NumColumn1 is NumColumn + 1,
    ((NumColumn1 < 9 ,  checkCell(Board,Row,NumColumn1,0))
    -> (
        numberColumn(Column,NumColumn1),
        append(ListTemp,[[Row,Column]],ListAux),
        listRowRight(Board,FinalList,Row,NumColumn1,ListAux));
    append([],ListTemp,FinalList)).


listRowLeft(Board,FinalList,Row,NumColumn,ListTemp) :-
    NumColumn1 is NumColumn - 1,
    ((NumColumn1 > 0 ,  checkCell(Board,Row,NumColumn1,0))
    -> (
        numberColumn(Column,NumColumn1),
        append(ListTemp,[[Row,Column]],ListAux),
        listRowLeft(Board,FinalList,Row,NumColumn1,ListAux));
    append([],ListTemp,FinalList)).


checkValidMove(MovesList,Row2b,NumColumn2b):-
    numberColumn(Column2b,NumColumn2b),
    append([],[Row2b,Column2b],Move),!,
    member(Move,MovesList).


checkWin(PiecesPositionsList):-
    checkSpan(PiecesPositionsList,0,0,8,8,RowSpan,ColumnSpan),
    (!,RowSpan>4,
    ColumnSpan>4,
    distanceBetween2(1,2,PiecesPositionsList,DistanceList,ListTemp),
   
    samsort(DistanceList,Sorted),

    print_listAux(Sorted)).
    

    
distanceBetween2(PieceIndex,5, PiecesPositionsList,DistanceList,DistanceListAux):-
    (PieceIndex < 4,
    PieceIndex1 is PieceIndex + 1,
    OtherPieceIndex1 is PieceIndex1 + 1,
    distanceBetween2(PieceIndex1,OtherPieceIndex1, PiecesPositionsList,DistanceList,DistanceListAux));
    append([],DistanceListAux,DistanceList).

distanceBetween2(PieceIndex,OtherPieceIndex, PiecesPositionsList,DistanceList,DistanceListAux):-
    OtherPieceIndex < 5,
    OtherPieceIndex1 is OtherPieceIndex +1,
    nth1(PieceIndex,PiecesPositionsList,Coords1),
    nth1(OtherPieceIndex,PiecesPositionsList,Coords2),
    distance(Coords1,Coords2,Distance),
    append(DistanceListAux,[Distance],DistanceListAux1),
    distanceBetween2(PieceIndex,OtherPieceIndex1,PiecesPositionsList,DistanceList,DistanceListAux1).

checkSpan([],BiggestRow,BiggestColumn,SmallestRow,SmallestColumn, RowSpan, ColumnSpan):-
    RowSpan is (BiggestRow-SmallestRow+1),
    ColumnSpan is (BiggestColumn-SmallestColumn+1),
    write('Rowspan '), write(RowSpan),nl,
    write('ColumnSpan '), write(ColumnSpan),nl,
    write('BiggestRow '), write(BiggestRow),nl,
    write('BiggestColumn '), write(BiggestColumn),nl.
checkSpan([H|T], BiggestRow,BiggestColumn,SmallestRow,SmallestColumn,RowSpan, ColumnSpan):-
    nth1(1,H,Row),
    nth1(2,H,Column),

    (((Row < SmallestRow,
    SmallestRow1 is Row);
    SmallestRow1 is SmallestRow),

    ((Column<SmallestColumn,
    SmallestColumn1 is Column);
    SmallestColumn1 is SmallestColumn),

    ((Column>BiggestColumn,
    BiggestColumn1 is Column);
    BiggestColumn1 is BiggestColumn),

    ((Row > BiggestRow,
    BiggestRow1 is Row);
    BiggestRow1 is BiggestRow)),

    checkSpan(T, BiggestRow1,BiggestColumn1,SmallestRow1,SmallestColumn1,RowSpan, ColumnSpan).
  
distance([H1|T1], [H2|T2], Distance):-
    Row is (H2-H1)^2,
    NumColumn is (T2-T1)^2,
    Distance is sqrt(Row + NumColumn).  

isSquare(DistanceList):-
    samsort(DistanceList,Sorted).



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



%% TODO: mudar para unicode
%% TODO:falta verificar se e quadrado e se esta rodado checkWin
%% TODO: disclaimers e infos
%% TODO: bots...............................................