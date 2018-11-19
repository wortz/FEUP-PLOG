:-include('boards.pl').
%% Initiates game board and enters the loop.
%%  1. Type of player 1
%%  2. Type of player 2
startGame(Player1,Player2,Level) :-
    initialBoard(InitialBoard),
    display_game(InitialBoard),
    gameLoop(InitialBoard,Player1,Player2,Level).

%% Handles the game loop
%%  1. Current game board
%%  2. Type of player 1
%%  3. Type of player 2
gameLoop(Board,Player1,Player2,Level) :-
    write('Red Player turn.\n'),
    move(Board,NewBoard,1,Player1,Level),
    getPiecesList(NewBoard,1,PiecesPositionsList1,_,0),
    display_game(NewBoard),
    ((game_over(PiecesPositionsList1),
    print_win('RED'));
    (write('White Player turn.\n'),
    move(NewBoard,RoundBoard,2,Player2,Level),
    getPiecesList(RoundBoard,2,PiecesPositionsList2,_,0),
    display_game(RoundBoard),
    ((game_over(PiecesPositionsList2),
    print_win('WHITE'));
    gameLoop(RoundBoard,Player1,Player2,Level)))).

%% Moves a player´s piece.          
%%  1. Current game board state 
%%  2. Board after piece is picked
%%  3. Symbol representing player
%%  4. Type of player 
%%  5. Dificulty level
move(Board,NewBoard,Symbol,'C',Level) :-
    choose_move(Board,NewBoard,Level,Symbol),
    nl.
move(Board,NewBoard,Symbol,'P',_) :-
    repeat,
    write('Which piece you would like to move?\n'),
    chooseCell(Row,NumColumn),
    ((checkCell(Board,Row,NumColumn,Symbol),
    valid_moves(Board,Row,NumColumn,MovesList),
    validPiece(MovesList));
    (write('Not a valid piece or with no moves! Choose again.\n\n'),
    fail)),!,
    replaceRows(Board,Row,NumColumn,0,BoardAux),
    chooseDest(BoardAux,NewBoard,Symbol,MovesList),!.

%% Checks if the piece has valid moves.
%%  1. List of the valid moves
validPiece(MovesList) :-
    length(MovesList,Size),!,
    Size>0.

%% Lists and chooses piece destination and updates game board.
%%  1. Game board
%%  2. Updated game board
%%  3. Symbol representing a player
%%  4. List of the valid moves
chooseDest(Board,NewBoard,Symbol,MovesList) :-
    write('You can move the piece to : \n'),
    print_list(MovesList),
    repeat,
    write('To Where?\n'),
    chooseCell(Row1,NumColumn1),
    ((checkValidMove(MovesList,Row1,NumColumn1));
    (write('Not a valid move for that piece! Choose again.\n\n'),
    fail)),!,
    replaceRows(Board,Row1,NumColumn1,Symbol,NewBoard).

%% Handles user input.
%%  1. Row number chosen
%%  2. Column number of column chosen
chooseCell(Row,NumColumn) :-
    askRow(RowAux),
    numberRow(RowAux,Row),
    askColumn(Column),
    numberColumn(Column,NumColumn),!.

%% Checks if [Row,NumColumn] cell in Board is Symbol.
%%  1. Current game board
%%  2. Row to be checked
%%  3. Column Number to be checked
%%  4. Symbol to be checked for
checkCell(Board,Row,NumColumn,Symbol) :-
    nth1(Row,Board,List),
    nth1(NumColumn,List,Value),!,
    Value =:= Symbol.

%% Finds all player´s pieces.
%%  1. List to be checked (board)
%%  2. Symbol that represents player
%%  3. Pieces´ positions list 
%%  4. Auxiliary pieces´ positions list
%%  5. Current Row being checked
getPiecesList([],_,PiecesPositionsList,PiecesPositionsListAux,_) :-
    append([],PiecesPositionsListAux,PiecesPositionsList).
getPiecesList([H|T],Symbol,PiecesPositionsList,PiecesPositionsListAux,Row) :-
    Row1 is Row + 1,
    length(PiecesPositionsListAux,Counter),
    ((Row1 < 9,
    Counter<4,
    getPiecesListAux(H, Row1, 0,Symbol,PiecesPositionsListTemp,_,Counter),
    append(PiecesPositionsListAux,PiecesPositionsListTemp,PiecesPositionsListAux1),
    getPiecesList(T,Symbol,PiecesPositionsList,PiecesPositionsListAux1,Row1));    
    getPiecesList([],Symbol,PiecesPositionsList,PiecesPositionsListAux,Row1)).

%% Finds all player´s pieces in a given row.
%%  1. List to be checked (board´s row)
%%  2. Current Row being checked
%%  3. Current Column number being checked
%%  4. Symbol that represents player
%%  5. Pieces´ positions list 
%%  6. Auxiliary pieces´ positions list
%%  7. Number of pieces found
getPiecesListAux([], _, _, _,PiecesPositionsListAux,PiecesPositionsListTemp,_):-
    append([],PiecesPositionsListTemp,PiecesPositionsListAux).
getPiecesListAux([H|T], Row, Column, Symbol,PiecesPositionsListAux,PiecesPositionsListTemp,Counter):-
    Column1 is Column+1,
    ((Counter < 4,
    ((H =:= Symbol,
    Counter1 is Counter + 1,
    append(PiecesPositionsListTemp,[[Row,Column1]],PiecesPositionsListTemp1),
    getPiecesListAux(T, Row, Column1, Symbol,PiecesPositionsListAux, PiecesPositionsListTemp1,Counter1));
    getPiecesListAux(T, Row, Column1, Symbol,PiecesPositionsListAux,PiecesPositionsListTemp,Counter)));
    getPiecesListAux([],Row,Column1,Symbol,PiecesPositionsListAux,PiecesPositionsListTemp,Counter)).

%% Lists valid moves of a given piece.
%%  1. Current game board
%%  2. Row of the piece 
%%  3. Number of the column of the piece
%%  4. List of the valid moves
valid_moves(Board,Row,NumColumn,MovesList):-
    listColumnDown(Board,MovesList1,Row,NumColumn,_TempMovesList),
    listColumnUp(Board,MovesList2,Row,NumColumn,_TempMovesList1),
    listRowRight(Board,MovesList3,Row,NumColumn,_TempMovesList2),
    listRowLeft(Board,MovesList4,Row,NumColumn,_TempMovesList3),
    append(MovesList1,MovesList2,MovesListAux),
    append(MovesListAux,MovesList3,MovesListAux1),
    append(MovesListAux1,MovesList4,MovesList),!.

%% List valid moves of a given piece in a downwards direction.
%%  1. Current game board 
%%  2. List of the valid moves
%%  3. Row of the piece
%%  4. Number of the column of the piece
%%  5. Auxiliary list
listColumnDown(Board,FinalList,Row,NumColumn,ListTemp) :-
    Row1 is Row + 1,
    ((Row1 < 9,
    checkCell(Board,Row1,NumColumn,0),
    numberColumn(Column,NumColumn),
    append(ListTemp,[[Row1,Column]],ListAux),
    listColumnDown(Board,FinalList,Row1,NumColumn,ListAux));
    append([],ListTemp,FinalList)).

%% Equivalent to listColumnDown, but in a upwards direction.
listColumnUp(Board,FinalList,Row,NumColumn,ListTemp) :-
    Row1 is Row - 1,
    ((Row1 > 0, 
    checkCell(Board,Row1,NumColumn,0),
    numberColumn(Column,NumColumn),
    append(ListTemp,[[Row1,Column]],ListAux),
    listColumnUp(Board,FinalList,Row1,NumColumn,ListAux));
    append([],ListTemp,FinalList)).

%% Equivalent to listColumnDown, but in a rightwards.
listRowRight(Board,FinalList,Row,NumColumn,ListTemp) :-
    NumColumn1 is NumColumn + 1,
    ((NumColumn1 < 9,
    checkCell(Board,Row,NumColumn1,0),
    numberColumn(Column,NumColumn1),
    append(ListTemp,[[Row,Column]],ListAux),
    listRowRight(Board,FinalList,Row,NumColumn1,ListAux));
    append([],ListTemp,FinalList)).

%% Equivalent to listColumnDown, but in a leftwards.
listRowLeft(Board,FinalList,Row,NumColumn,ListTemp) :-
    NumColumn1 is NumColumn - 1,
    ((NumColumn1 > 0,
    checkCell(Board,Row,NumColumn1,0),
    numberColumn(Column,NumColumn1),
    append(ListTemp,[[Row,Column]],ListAux),
    listRowLeft(Board,FinalList,Row,NumColumn1,ListAux));
    append([],ListTemp,FinalList)).

%% Checks if it´s a valid move.
%%  1. List of legal moves
%%  2. Row of the pretended move
%%  3. Column of the pretended move
checkValidMove(MovesList,Row2b,NumColumn2b):-
    numberColumn(Column2b,NumColumn2b),
    append([],[Row2b,Column2b],Move),!,
    member(Move,MovesList).

%% Checks if the winning condition is fulfilled
%%  1. List of the positions of a player´s pieces
game_over(PiecesPositionsList):-
    checkSpan(PiecesPositionsList,0,0,8,8,RowSpan,ColumnSpan),!,
    (RowSpan>4,
    ColumnSpan>4,
    distanceBetween2(1,2,PiecesPositionsList,DistanceList,_),!,
    (isSquare(DistanceList),
    isRotated(PiecesPositionsList))
   ).
    
%% Calculates all absolute distances between all different pieces of a given player
%%  1. Current index of the piece to be calculated distance to other pieces
%%  2. Second piece to calculate distance
%%  3. List of all the pieces´ positions
%%  4. List of all distances
%%  5. Auxiliary list
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

%% Calculates how far apart the pieces are 
%%  1. List of all the player´s pieces
%%  2. Largest row number of all pieces´ position
%%  3. Largest column number of all pieces´ position
%%  4. Smallest row number of all pieces´ position
%%  5. Smallest column number of all pieces´ position
%%  6. Span of rows (M-m)
%%  7. Span of columns (M-m)
checkSpan([],BiggestRow,BiggestColumn,SmallestRow,SmallestColumn, RowSpan, ColumnSpan):-
    RowSpan is (BiggestRow-SmallestRow+1),
    ColumnSpan is (BiggestColumn-SmallestColumn+1).
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

%% Calculates absolute distance between two pieces
%%  1. 1st piece
%%  2. 2nd piece
%%  3. Distance
distance([H1|T1], [H2|T2], Distance):-
    Row is (H2-H1)^2,
    NumColumn is (T2-T1)^2,
    Distance is sqrt(Row + NumColumn).  

%% Checks if the pieces form a square among themselves
%%  1. List of all distances of all the pieces combinations 
isSquare(DistanceList):-
    sort(DistanceList,Sorted),
    length(Sorted, Length),
    Length =:= 2,
    checkDiagonal(Sorted).

%% Checks if the diagonal has the right length
%%  1. Cathet
%%  2. Hypothenuse
checkDiagonal([H|T]):-
    Hipotenusa is (H^2 +H^2),
    HipotenusaGoal is (T^2),
    Erro is abs(Hipotenusa-HipotenusaGoal),
    Erro < 0.00000000001.

%% Checks if the square formed by the pieces is rotated
%%  1. Pieces positions
isRotated([H|T]):-
    nth1(1,H,Row),
    nth1(2,H,Column),
    \+ (member([_,Column],T),
    member([Row,_],T)).

%% Goes through a whole row and replaces the cell with Value.
%%  1. Row
%%  2. Current column
%%  3. Value to be replaced
%%  4. New Row of the new board
replaceColumns([_|T], 1, Value, [Value|T]).
replaceColumns([C|T], Column, Value, [C|TNew]) :-
        Column > 1,
        Column1 is Column - 1,
        replaceColumns(T, Column1, Value, TNew).

%% Finds wanted row
%%  1. Board 
%%  2. Row Counter
%%  3. Column
%%  4. Value to be replaced
%%  5. New Board 
replaceRows([L|T], 1, Column,Value, [LNew|T]) :-
        replaceColumns(L, Column, Value, LNew).
replaceRows([L|T], Row, Column, Value, [L|TNew]) :-
        Row > 1,
        Row1 is Row - 1,
        replaceRows(T, Row1, Column, Value, TNew).

%% Unifies variables to get Row and Column 
%%  1. Coordinates
%%  2. Row
%%  3. Column
getRowColumn([H|T],H,T1):-
    T1 is T.

%% Unifies variables to get Row and Column number
%%  1. Coordinates
%%  2. Row
%%  3. Column
getRowNumColumn([H|T],H,T1):-
    nth1(1,T,T2),
    numberColumn(T2,T1).