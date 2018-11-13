askOption(Input) :-
    write('> Insert your option '),
    read(Input).

mainMenuInput(1) :-
    startGame('P','P').

mainMenuInput(2) :-
    write('\nNot Working Yet...\n\n'),
    start.

mainMenuInput(3) :-
    write('\nNot Working Yet...\n\n'),
    start.

mainMenuInput(4) :-
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

numberColumn(Column,NumColumn) :-
    char_code('a',Num1), char_code(Column,Num2),
    NumColumn is ( Num1-Num2 + 8),
    NumColumn > 0, NumColumn <9.


numberColumn(_Column,NumColumn) :-
    write('That Column is not valid!\n'),
    askColumn(Input),
    numberColumn(Input,NumColumn).

numberRow(RowInput,Row):-
    (\+ integer(RowInput);
    (RowInput <1;
     RowInput>8),
     write('That Row is not valid!\n'),
     askRow(Input),
     numberRow(Input,Row));
     (RowInput>0,
     RowInput<9).
