%% Chooses move to be executed by the bot
%%  1. Board before play
%%  2. Board after play
%%  3. Dificulty level
%%  4. Symbol of yhe current player
choose_move(Board, NewBoard, 1, Symbol):-
    getPiecesList(Board, Symbol,PiecesPositionsList, _,0),
    make_randomMove(Board,Symbol,PiecesPositionsList,NewBoard).

%% Handles the move of the level2 bot.
%%  1.Board.
%%  2.To return the board after the move.
%%  3.Symbol of the player.
choose_move(Board, NewBoard, 2, Symbol):-
    getPiecesList(Board, Symbol,PiecesPositionsList, _,0),
    listAllValidMoves(Board,PiecesPositionsList, AllMovesList),
    recursiveValue(PiecesPositionsList, AllMovesList,0,ValuesList),
    getBestValue(BestValue,ValuesList,0),
    getBestsMoves(AllMovesList,ValuesList,BestsMoves,BestValue,_),
    repeat,
    choose_randomMovesList(BestsMoves,ChosenList,PieceIndex,ChosenLength),
    ChosenLength > 1,!,
    nth1(PieceIndex,PiecesPositionsList,PieceCoords),
    getRowColumn(PieceCoords,Row,NumColumn),
    replaceRows(Board,Row,NumColumn,0,BoardAux),
    random(1,ChosenLength,MoveIndex),
    nth1(MoveIndex,ChosenList,MoveCoords),
    getRowNumColumn(MoveCoords,Row1,NumColumn1),
    replaceRows(BoardAux,Row1,NumColumn1,Symbol,NewBoard).

%% Chooses a random piece to be moved.
%%  1.List with all the best moves.
%%  2.Return the bests moves of the selected piece.
%%  3.Return the piece index.
%%  4.Return the length of the chosen bests moves list.
choose_randomMovesList(BestsMoves,ChosenList,PieceIndex,ChosenLength):-
    random(1,5,PieceIndex),
    nth1(PieceIndex,BestsMoves,ChosenList),
    length(ChosenList,ChosenLength1),
    ChosenLength is ChosenLength1 + 1,!.

%% Lists all valid moves to all 4 pieces of a given player
%%  1. Current Board
%%  2. Positions of the 4 pieces
%%  3. List containing all the valid moves   
listAllValidMoves(Board,PiecesPositionsList,AllMovesList):-
    nth1(1,PiecesPositionsList,PieceCoords1),
    getRowColumn(PieceCoords1, Row1, Column1),
    valid_moves(Board,Row1,Column1,MovesList1),

    nth1(2,PiecesPositionsList,PieceCoords2),
    getRowColumn(PieceCoords2, Row2, Column2),
    valid_moves(Board,Row2,Column2,MovesList2),

    nth1(3,PiecesPositionsList,PieceCoords3),
    getRowColumn(PieceCoords3, Row3, Column3),
    valid_moves(Board,Row3,Column3,MovesList3),

    nth1(4,PiecesPositionsList,PieceCoords4),
    getRowColumn(PieceCoords4, Row4, Column4),
    valid_moves(Board,Row4,Column4,MovesList4),

    append([MovesList1],[MovesList2],AllMovesListAux),
    append(AllMovesListAux,[MovesList3],AllMovesListAux1),
    append(AllMovesListAux1,[MovesList4],AllMovesList).

%% Randomizes a move and executes it 
%%  1. Board
%%  2. Symbol of the player
%%  3. Positions of all the pieces 
%%  4. Board after play
make_randomMove(Board,Symbol,PiecesPositionsList,NewBoard):-
    repeat,
    random(1, 5, PieceIndex),
    nth1(PieceIndex,PiecesPositionsList,PieceCoords),
    getRowColumn(PieceCoords,Row,NumColumn),
    valid_moves(Board,Row,NumColumn,MovesList),
    validPiece(MovesList),!,
    replaceRows(Board,Row,NumColumn,0,BoardAux),
    length(MovesList, L),
    Length is L+1,
    random(1,Length,MoveIndex),
    nth1(MoveIndex,MovesList,MoveCoords),
    getRowNumColumn(MoveCoords,Row1,NumColumn1),
    replaceRows(BoardAux,Row1,NumColumn1,Symbol,NewBoard).

%% Loops around all the pieces move list.
%%  1.List with the positions of the pieces.
%%  2.List with all the moves.
%%  3.Index of the piece.
%%  4.List to be returned with all the values.
recursiveValue(_,[],_,[]).
recursiveValue(PiecesPositionsList, [H|T],Index,ValuesList):-
    Index1 is Index + 1,
    recursiveValueAux(PiecesPositionsList,H,Index1,ValuesListAux),
    recursiveValue(PiecesPositionsList,T,Index1,ValuesList1),
    append([ValuesListAux],ValuesList1,ValuesList).

%% Loops around all the moves of a certain piece and inserts the value to that move.
%%  1.List with the positions of the pieces.
%%  2.List with all the moves of that piece.
%%  3.Index of the piece.
%%  4.List to be returned with all the values of that piece moves.
recursiveValueAux(_,[],_,[]).
recursiveValueAux(PiecesPositionsList,[H|T],Index,ValuesListAux):-
    value(PiecesPositionsList,H,Index,Value),
    recursiveValueAux(PiecesPositionsList,T,Index,ValuesListAux1),
    append([Value],ValuesListAux1,ValuesListAux).


%% Gets the value of a certain move.
%%  1.List with the positions of the pieces.
%%  2.Coordinates of the move.
%%  3.Index of the piece to move.
%%  4.To return the value of that move.
value(PiecesPositionsList,Coords,Index,Value):-
    ((valueWin(PiecesPositionsList,Index,Coords),
    Value is 3);
        ((check_for_triangle(PiecesPositionsList,Coords,Index),
        Value is 2);
            Value is 0)).
    
%% Checks if a certain move can win the game.
%%  1.List with the positions of the pieces.
%%  2.Index of the piece to move.
%%  3.Coordinates of the move.
valueWin(PiecesPositionsList,Index,Coords) :-
    getRowNumColumn(Coords,Row,NumColumn),
    Coords1=[Row,NumColumn],
    replaceColumns(PiecesPositionsList,Index,Coords1,PiecesPositionsListTemp),!,         %% is used only to replace the list with those coords on that index
    game_over(PiecesPositionsListTemp).

%% Gets the list with all the moves that have the best value as value.
%%  1.List with all the moves.
%%  2.List with all the values.
%%  3.List to return all the bests moves.
%%  4.Best value.
%%  5.Auxiliary variable.
getBestsMoves([],[],BestsMoves,_,BestMovesTemp):-
    append([],BestMovesTemp,BestsMoves).
getBestsMoves([HMove|TMove],[HValue|TValue],BestsMoves,BestValue,BestMovesTemp):-
    getBestsMovesOfPiece(HMove,HValue,BestsMovesOfPiece,BestValue,_),
    append(BestMovesTemp,[BestsMovesOfPiece],BestMovesTemp1),
    getBestsMoves(TMove,TValue,BestsMoves,BestValue,BestMovesTemp1).

%% Gets the list with all the moves of a certain piece that have the best value as value.
%%  1.List with all the moves of that piece.
%%  2.List with all the values of that piece s moves.
%%  3.List to return all the bests moves.
%%  4.Best value.
%%  5.Auxiliary variable.
getBestsMovesOfPiece([],[],BestsMovesOfPiece,_,BestsMovesOfPieceTemp):-
    length(BestsMovesOfPieceTemp,_),
    append([],BestsMovesOfPieceTemp,BestsMovesOfPiece).
getBestsMovesOfPiece([HMove|TMove],[HValue|TValue],BestsMovesOfPiece,BestValue,BestsMovesOfPieceTemp):-
    ((HValue=:=BestValue,
    append(BestsMovesOfPieceTemp,[HMove],BestsMovesOfPieceTemp1),
    getBestsMovesOfPiece(TMove,TValue,BestsMovesOfPiece,BestValue,BestsMovesOfPieceTemp1));
    getBestsMovesOfPiece(TMove,TValue,BestsMovesOfPiece,BestValue,BestsMovesOfPieceTemp)).

%% Gets the best value of all the possible moves
%%  1.To return the best value.
%%  2.List with all the values.
%%  3.Auxiliary variable to find the best value.
getBestValue(BestValue,[],BestValueTemp):-
    BestValue is BestValueTemp.
getBestValue(BestValue,[HValue|TValue],BestValueTemp) :-
    ((BestValueTemp=:=3,
    BestValue is BestValueTemp);
        ((getBestValueAux(BestValueAux,HValue,0),
        BestValueAux > BestValueTemp,
        getBestValue(BestValue,TValue,BestValueAux));
            getBestValue(BestValue,TValue,BestValueTemp))).

%% Gets the best value of a certain piece s list of moves
%%  1.To return the best value.
%%  2.List with all the values of that piece moves.
%%  3.Auxiliary variable to find the best value.
getBestValueAux(BestValue,[],BestValueTemp):-
    BestValue is BestValueTemp.
getBestValueAux(BestValue,[H|T],BestValueTemp) :-
    ((H > BestValueTemp,
    getBestValueAux(BestValue,T,H));
        getBestValueAux(BestValue,T,BestValueTemp)).

%% Checks if the moven piece forms a triangle with any combination with 2 of the other pieces
%%  1. Unmoven pieces
%%  2. New position of the piece of index PieceIndex
%%  3. Index of the piece to be moved
check_for_triangle(PiecesPositionsList,Move,PieceIndex):-
   nth1(PieceIndex,PiecesPositionsList,CurrentPiece),    
   delete(PiecesPositionsList,CurrentPiece,PiecesPositionsListTemp), 
   getRowNumColumn(Move,R,NC),
   append([[R,NC]], PiecesPositionsListTemp, PiecesPositionsList_2Bchecked),!,     %% para ficar a move na primeira posição
   recursiveCheck_for_triangle(PiecesPositionsList_2Bchecked, 5).            %% fail se nao forma triangulo,true se sim 
   
%% Checks if the 3 pieces form a rectangule triangle 
%%  1. Coordinates of the pieces
isTriangle(TriCoords):-
   distanceAmong3(1,2,TriCoords,DistanceList,_),!,
   isSquare(DistanceList),                                                  %% ve se é triangulo rectangulo
   isRotated(TriCoords),
   tryAllCombos(TriCoords, 0).

%% Tries all the combinations of the moven piece with the other 3 to check for a triangle
%%  1. All 4 pieces Coordinates
%%  2. Index of the moven piece
recursiveCheck_for_triangle(PiecesPositionsList, PieceIndex):-
   PieceIndex1 is PieceIndex - 1,  
   PieceIndex1 > 1,                                                          %% para eliminar um a um a partir do fim
   nth1(PieceIndex1,PiecesPositionsList ,CurrentPiece),     
   delete(PiecesPositionsList,CurrentPiece,TriCoords),      
   checkSpan(TriCoords,0,0,8,8,RowSpan,ColumnSpan),!,
   (((RowSpan>4; ColumnSpan>4)-> isTriangle(TriCoords);
   recursiveCheck_for_triangle(PiecesPositionsList, PieceIndex1));
   recursiveCheck_for_triangle(PiecesPositionsList, PieceIndex1)         %% não tem span sufiiente ou nao e triangulo, continua
   ).                                                                    %% senão, acaba


tryAllCombosColumns(TriCoords, Column, Row):-
    Column1 is Column +1,
    Column1 <9, 
    append([[Row, Column]], TriCoords, Square_2B),
    (game_over(Square_2B);
    tryAllCombosColumns(TriCoords,Column1,Row)).

tryAllCombos(TriCoords, Row):-
    Row1 is Row +1,
    Row1<9, 
    (tryAllCombosColumns(TriCoords,0, Row1);
    tryAllCombos(TriCoords,Row1)).
    

%% Calculates distances among 3 pieces (all combinations)
%%  1. Current index of the piece to be calculated distance to other pieces
%%  2. Second piece to calculate distance
%%  3. List of all the pieces´ positions
%%  4. List of all distances
%%  5. Auxiliary list
distanceAmong3(PieceIndex,4, PiecesPositionsList,DistanceList,DistanceListAux):-
   (PieceIndex < 4,
   PieceIndex1 is PieceIndex + 1,
   OtherPieceIndex1 is PieceIndex1 + 1,
   distanceAmong3(PieceIndex1,OtherPieceIndex1, PiecesPositionsList,DistanceList,DistanceListAux));
   append([],DistanceListAux,DistanceList).
distanceAmong3(PieceIndex,OtherPieceIndex, PiecesPositionsList,DistanceList,DistanceListAux):-
   OtherPieceIndex < 4,
   OtherPieceIndex1 is OtherPieceIndex +1,
   nth1(PieceIndex,PiecesPositionsList,Coords1),
   nth1(OtherPieceIndex,PiecesPositionsList,Coords2),
   distance(Coords1,Coords2,Distance),
   append(DistanceListAux,[Distance],DistanceListAux1),
   distanceAmong3(PieceIndex,OtherPieceIndex1,PiecesPositionsList,DistanceList,DistanceListAux1).
