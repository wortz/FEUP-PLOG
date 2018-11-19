askOption(Input) :-
    write('> Insert your option '),
    read(Input).

mainMenuInput(1) :-
    startGame('P','P').

mainMenuInput(2) :-
    choose_level('P','C').

mainMenuInput(3) :-
    choose_level('C','P').

mainMenuInput(4) :-
    choose_level('C','C').

mainMenuInput(5) :-
    printRulesMenu.

mainMenuInput(0) :-
    write('\nThank You, Come Again ....\n\n').

mainMenuInput(_Other) :-
    write('\nERROR: that option does not exist.\n\n'),
    askOption(Input),
    mainMenuInput(Input).

choose_level(Player1,Player2):-
    write('\n\n1-Level 1 PC\n2-Level 2 PC\n\n'),
    askOption(Input),
    choose_levelInput(Input,Player1,Player2).

choose_levelInput(1,Player1,Player2) :-
    startGame(Player1,Player2,1).

choose_levelInput(2,Player1,Player2) :-
    startGame(Player1,Player2,2).

choose_levelInput(_,Player1,Player2) :-
    write('\nERROR: that option does not exist.\n\n'),
    choose_level(Player1,Player2).

askRow(Row) :-
    write(' what row (NUMBER):\n'),
    read(Row).

askColumn(Column) :-
    write(' what column (Letter):\n'),
    read(Column).

numberColumn('h',1).
numberColumn('g',2).
numberColumn('f',3).
numberColumn('e',4).
numberColumn('d',5).
numberColumn('c',6).
numberColumn('b',7).
numberColumn('a',8).

numberColumn(_Column,NumColumn) :-
    write('That Column is not valid!\n'),
    askColumn(Input),
    numberColumn(Input,NumColumn).

numberRow(RowInput,Row):-
    ((\+ integer(RowInput);
    (RowInput <1;
     RowInput>8)),
     write('That Row is not valid!\n'),
     askRow(Input),
     numberRow(Input,Row));
     Row is RowInput.
