:-include('setVars.pl').
:-include('tablePrinter.pl').
:-use_module(library(lists)).
:-use_module(library(clpfd)).



%%
nth1(1,DuracaoActividades,NrHorasAtividade1),
NrHorasAtividade1 #= somaDoc1 + somaCont1

%%como vamos guardar cada valor de 
%%cada investigador para cada mês

%% matrix 3d - acti, invest, meses
%%dimensao actividad - restriçao rigida das horas totais , mes em que nao se trabalha e optimizacao final(flex)
%%restricao 1 ir a todos os inv numa activi e para cada mes restriçao rigida das horas totais  
%%flexiveis - tipo carteiro pergui , para actividade e para invest


