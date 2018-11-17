askOption(Input) :-
    write('> Insert your option '),
    read(Input).

mainMenuInput(1) :-
    startGame('P','P').

mainMenuInput(2) :-
    startGame('P','C').

mainMenuInput(3) :-
    write('\nNot Working Yet...\n\n'),
    start.

mainMenuInput(4) :-
    write('\nNot Working Yet...\n\n'),
    start.

mainMenuInput(5) :-
    printRulesMenu.

mainMenuInput(0) :-
    write('\nThank You, Come Again ....\n\n').

mainMenuInput(_Other) :-
    write('\nERROR: that option does not exist.\n\n'),
    askOption(Input),
    mainMenuInput(Input).

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
