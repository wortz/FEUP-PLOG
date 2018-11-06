start :-
    printMainMenu,
    askOption,
    read(Input),
    mainMenuInput(Input).

askOption :-
write('> Insert your option ').

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
    askOption,
    read(Input),
    mainMenuInput(Input).

printMainMenu :-
    nl,nl,
    write(' __________________________________________________________________________________ '),nl,
    write('|                                                                                  |'),nl,
    write('|                                                                                  |'),nl,
    write('| _______  __   __  _______  ______    _______  _______  _______  _______  _______ |'),nl,
    write('||       ||  | |  ||   _   ||    _ |  |       ||       ||       ||       ||       ||'),nl,
    write('||   _   ||  | |  ||  |_|  ||   | ||  |_     _||    ___||_     _||_     _||   _   ||'),nl,
    write('||  | |  ||  |_|  ||       ||   |_||_   |   |  |   |___   |   |    |   |  |  | |  ||'),nl,
    write('||  |_|  ||       ||       ||    __  |  |   |  |    ___|  |   |    |   |  |  |_|  ||'),nl,
    write('||      | |       ||   _   ||   |  | |  |   |  |   |___   |   |    |   |  |       ||'),nl,
    write('||____||_||_______||__| |__||___|  |_|  |___|  |_______|  |___|    |___|  |_______||'),nl,
    write('|                                                                                  |'),nl,
    write('|                            Joao Pedro Bandeira Fidalgo                           |'),nl,
    write('|                            Francisco Ademar Freitas Friande                      |'),nl,
    write('|                                                                                  |'),nl,
    write('|                                                                                  |'),nl,
    write('|                            1. Player vs Player                                   |'),nl,
    write('|                                                                                  |'),nl,
    write('|                            2. Player vs CPU                                      |'),nl,
    write('|                                                                                  |'),nl,
	write('|                            3. CPU vs CPU                                         |'),nl,
    write('|                                                                                  |'),nl,
    write('|                            4. Rules                                              |'),nl,
    write('|                                                                                  |'),nl,
    write('|                            0. Exit                                               |'),nl,
    write('|                                                                                  |'),nl,
    write('|                                                                                  |'),nl,
    write(' __________________________________________________________________________________ '),nl,nl,nl.

printRulesMenu :-
    nl,nl,
    write(' _________________________________________________________________________ '),nl,
    write('|                                                                         |'),nl,
    write('|                                                                         |'),nl,
    write('|  1.As pecas devem formar um quadrado rodado em relacao ao tabuleiro.    |'),nl,
    write('|  2.A caixa delimitada pelas pecas tera de ser maior que 5x5.            |'),nl,
    write('|  3.As pecas apenas se movem na horizontal ou vertical.                  |'),nl,
    write('|  4.Podem mover cada peca quantas casas forem possiveis nessas direcoes. |'),nl,
    write('|  5.Nao se pode passar por cima das outras pecas(inimigas ou suas).      |'),nl,
    write('|  6.As coordenadas vao ser pedidas, primeiro a letra depois o numero.    |'),nl,
    write('|  7.Primeiro insere as coordenadas da peca que quer mover.               |'),nl,
    write('|  8.Depois as coordenadas da casa para onde a peca pode ir.              |'),nl,
    write('|  9.No caso de inserir coordenadas erradas ou invalidas volta ao ponto 7.|'),nl,
    write('|                                                                         |'),nl,
    write('|                                                                         |'),nl,
    write('|                                BOM JOGO                                 |'),nl,
    write('|              Escreva qualquer coisa para voltar o menu principal.       |'),nl,
    write('|                                                                         |'),nl,
    write('|                                                                         |'),nl,
    write(' _________________________________________________________________________ '),nl,nl,nl,
    read(Input),
    start.