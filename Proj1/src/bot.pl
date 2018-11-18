%% Chooses move to be executed by the bot
%%  1. Board before play
%%  2. Board after play
%%  3. Dificulty level
%%  4. Symbol of yhe current player
choose_move(Board, NewBoard, 1, Symbol):-
    getPiecesList(Board, Symbol,PiecesPositionsList, _,0),
    make_randomMove(Board,Symbol,PiecesPositionsList,NewBoard).

choose_move(Board, NewBoard, 2, Symbol):-
    getPiecesList(Board, Symbol,PiecesPositionsList, _,0),
    listAllValidMoves(Board,PiecesPositionsList, AllMovesList).

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

    append(MovesList1,MovesList2,AllMovesListAux),
    append(AllMovesListAux,MovesList3,AllMovesListAux1),
    append(AllMovesListAux1,MovesList4,AllMovesList).

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
