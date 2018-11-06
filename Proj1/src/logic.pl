startGame(Player1, Player2) :-
    initialBoard(InitialBoard),
    display_game(InitialBoard),
    gameLoop.


gameLoop :-
    write('\n Not done \n').