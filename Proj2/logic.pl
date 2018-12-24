:-include('setVars.pl').
:-include('tablePrinter.pl').
:-use_module(library(lists)).
:-use_module(library(clpfd)).
:-use_module(library(timeout)).
%%Trata de criar uma lista de tamanho n
set3dMatrixAux([],_).
set3dMatrixAux([H|T],N):-
    length(H,N),
    set3dMatrixAux(T,N).

%%cria uma lista de listas de tamanho n
set3dMatrix([],_).
set3dMatrix([H|T],N):-
    set3dMatrixAux(H,N),
    set3dMatrix(T,N).

dedicacao:-
    nrInvestigadores(NrInvestigadores),
    nrActividades(NrActividades),   
    duracaoProjecto(NMeses),
    length(Matrix,NrActividades),
    set3dMatrixAux(Matrix,NrInvestigadores),
    set3dMatrix(Matrix,NMeses),
    iterAux(Matrix,1),
    iterarfinal(Matrix,1,NrActividades,Dif),
    flattenLists(Matrix,FlattenedMatrix),
    statistics(walltime,_),
    labeling([ff,down,time_out(300000,Flag),minimize(Dif)],FlattenedMatrix),
    statistics(walltime,[_,ElapsedTime|_]),
    fd_statistics,
    write(ElapsedTime),nl,
    printTable(Matrix).




%%INVESTIGATORS
%%itera por todos os investigadores
%%iterAux(Matrix,IndexInvestigador)
%%Matrix- Matrix3d com todos os meses , investigadores e atividades
%%IndexInvestigador- Indice do investigador a ser avaliado
iterAux(Matrix,IndexInvestigador):-
    nrInvestigadores(NrInv),
    iterAux1(Matrix,IndexInvestigador,1,SumTotal),
    restricaoTempoDedicarProjeto(IndexInvestigador,SumTotal),
    ((IndexInvestigador1 is IndexInvestigador+1,
    IndexInvestigador1 =< NrInv,
    iterAux(Matrix,IndexInvestigador1));
    true).


%%MESES
%%itera por todos os meses de trabalho de um investigador
%%iterAux1(Matrix,IndexInvestigador, IndexMes,SumTotal)
%%Matrix- Matrix3d com todos os meses , investigadores e atividades
%%IndexMes- Indice do mes a avaliar
%%IndexInvestigador- Indice do investigador a ser avaliado
%%SumTotal- Soma do tempo total que ele trabalha no projeto
iterAux1(Matrix,IndexInvestigador,IndexMes,SumTotal):-
    duracaoProjecto(Dur),
    iter(Matrix,IndexMes,IndexInvestigador,1,SumMes),  %%SumMes é o total de horas que um investigador trabalha num mes
    ((mesFolga(IndexInvestigador,IndexMes));
    checkInvestigador(IndexInvestigador,SumMes,1)),
    ((IndexMes1 is IndexMes +1,
    IndexMes1=<Dur,
    iterAux1(Matrix,IndexInvestigador,IndexMes1,SumTotal1),
    SumTotal #= SumMes + SumTotal1);
    SumTotal #=SumMes).


%%ACTIVIDADES
%%itera por certo mes de todas as atividades para um investigador
%%iter(Matrix,IndexMes, IndexInvestigador,IndexActivity,SumMes)
%%Matrix- Matrix3d com todos os meses , investigadores e atividades
%%IndexMes- Indice do mes a avaliar
%%IndexInvestigador- Indice do investigador a ser avaliado
%%IndexActivity- Indice da atividade
%%SumMes- Soma do tempo que ele trabalha por mes em todas as atividades
iter([],_,_,_,0).
iter([H|T],IndexMes, IndexInvestigador,IndexActivity,SumMes):-
    nth1(IndexInvestigador,H,CurrentInvest_Activity),       %%encontra meses de investigador na actividade a ser iterada
    nth1(IndexMes,CurrentInvest_Activity,M),
    a(M,IndexActivity,IndexInvestigador,IndexMes),
    IndexActivity1 is IndexActivity+1,
    iter(T,IndexMes, IndexInvestigador,IndexActivity1,SumMes1),
    SumMes #= SumMes1 + M.

%%params
%%Index do invest
%% Funçao pode ser usada para restringir a soma das horas de trabalho
%de um investigador num mes, ou para restringir as horas de um mes numa acti
%%caso boolean =1 a variavel SumMes_ou_MaxMes é SumMes ,caso 2 é MaxMes
checkInvestigador(IndexInvestigador,SumMes_ou_MaxMes,Boolean):-
    (
        docente(X),member(IndexInvestigador,X),
        docenteMaxHorasMensais(IndexInvestigador,HorasMesDocente),
        SumMes_ou_MaxMes in 0..HorasMesDocente
    );
    (
        contratado(Y),member(IndexInvestigador,Y),
        contratadoHorasMensais(IndexInvestigador,HorasMesContratado),
        ((Boolean=1,
        SumMes_ou_MaxMes #= HorasMesContratado);
        SumMes_ou_MaxMes in 0..HorasMesContratado)
    ).

%%Aplica a restricao de tempo que um investigador docente deve aplicar no projeto, caso exista
%%IndexInvestigador- Investigador a ser aplicada a restrição
%%SumTotal- Soma dos tempos onde vai ser aplicada a restrição
restricaoTempoDedicarProjeto(IndexInvestigador,SumTotal):-
    ((docenteTotalHorasProjecto(IndexInvestigador,HorasADedicar),
    SumTotal #=HorasADedicar);
    true).


%params
%% Variavel de Mes actual (a restringir)
%% 
a(M,IndexActivity,IndexInvestigador,IndexMes):- 
    ((
        checkNaoTrabalha(IndexActivity,IndexInvestigador,IndexMes),
        M#=0
      );
    checkInvestigador(IndexInvestigador,M,2)).


%%verifica se não trabalha nesse mes para essa atividade
%%IndexActivity- Indice da atividade a ser avaliada
%%IndexInvestigador- Indice do investigador a ser availado
%%IndexMes- Indice do mes a ser avaliado
checkNaoTrabalha(IndexActivity,IndexInvestigador,IndexMes):-
    (mesFolga(IndexInvestigador,IndexMes);%%ve se indexMes e mes de folga
        (actividadesMeses(ActividadesMeses),
        nth1(IndexActivity,ActividadesMeses,CurrentActivityMeses),
        \+ member(IndexMes,CurrentActivityMeses))).


%%
%%nth1(1,DuracaoActividades,NrHorasAtividade1),
%%NrHorasAtividade1 #= somaDoc1 + somaCont1

%% matrix 3d - acti, invest, meses DONE
%%dimensao actividad - restriçao rigida das horas totais , mes em que nao se trabalha e optimizacao final(flex)
%%restricao 1 ir a todos os inv numa activi e para cada mes restriçao rigida das horas totais  
%%flexiveis - tipo carteiro pergui , para actividade e para invest

retricoes_rigidas1(IndexInvestigador,MatrixH):-
    (
        docente(X),member(IndexInvestigador,X),      
        docenteMaxHorasMensais(IndexInvestigador,HorasMesDocente),
        MatrixH in 0..HorasMesDocente
    );
    (
        contratado(Y),member(IndexInvestigador,Y),
        contratadoHorasMensais(IndexInvestigador,HorasMesContratado),
        MatrixH #= HorasMesContratado
    ).




%%Iterar sobre NrActividades e passar esse valor no param CurrentActivity
iterarfinal(Matrix,IndexActivity,NrAtividades,Dif):-
    nth1(IndexActivity,Matrix,CurrentActivityMatrix),
    iterInvestigadores(CurrentActivityMatrix,SumMeses,DifInv,1,IndexActivity),
    duracaoActividades(X),nth1(IndexActivity,X,HorasNecessarias),
    SumMeses #= HorasNecessarias,
    ((IndexActivity1 is IndexActivity + 1,
    IndexActivity1 =< NrAtividades,
    iterarfinal(Matrix,IndexActivity1,NrAtividades,Dif1),
    Dif #= DifInv+Dif1);
    Dif #= DifInv).


%params
%%indice da actividade a verificar
%%lista de ActividadesMeses da current actividade
%%lista da matrix da current actividade
%%Indice da CurrentActivityMatrix a ser verificado
iterInvestigadores([],0,0,_,_).
iterInvestigadores([H|T],SumMeses,DifInv,IndexInvestigador,IndexActivity):-
    iterSomaInv(H,SomaInv,IndexInvestigador,IndexActivity,1,TemposNaoFolga),
    durAtividade(SomaInv,IndexInvestigador,IndexActivity),
    IndexInvestigador1 is IndexInvestigador +1,
    iterInvestigadores(T,SumMeses1,DifInv1,IndexInvestigador1,IndexActivity),
    maximum(Maxi,TemposNaoFolga),
    minimum(Mini,TemposNaoFolga),
    DifInv#=Maxi-Mini+DifInv1,
    SumMeses #= SomaInv + SumMeses1.

%%itera pelos meses todos de uma atividade para um investigador e retorna a soma de todos os tempo e uma lista com todos os tempos em que ele trabalha
%%iterSomaInv(TemposInvestigador,SomaInv,IndexInvestigador,IndexActivity,IndexMes,TemposNaoFolga)
%%TemposInvestigador- Lista com os meses para uma atividade para um certo investigador
%%SomaInv- Para retornar a soma de todos os tempos
%%IndexInvestigador- Indice do investigador a ser avaliado
%%IndexActivity- Indice da atividade a ser avaliada
%%IndexMes- Indice do mes a ser avaliado , vai sendo incrementado cada vez que avança na lista TemposInvestigador
%%TemposNaoFolga- Lista onde vao estar no fim os tempos todos em que ele trabalha
iterSomaInv([],0,_,_,_,[]).
iterSomaInv([H|T],SomaInv,IndexInvestigador,IndexActivity,IndexMes,TemposNaoFolga):-
    IndexMes1 is IndexMes +1,
    iterSomaInv(T,SomaInv1,IndexInvestigador,IndexActivity,IndexMes1,TemposNaoFolga1),
    ((checkNaoTrabalha(IndexActivity,IndexInvestigador,IndexMes), %%caso nao trabalhe
    append([],TemposNaoFolga1,TemposNaoFolga));   %%nao da append de nada
    append([H],TemposNaoFolga1,TemposNaoFolga)),  %%se nao da appende desse valor
    SomaInv #= H + SomaInv1.



%%torna a lista de listas de listas em uma lista simples para utilização no labeling
flattenLists(List, NewList):-
        flattenList(List, NewListAux),
        flattenList(NewListAux, NewList).

flattenList([], []).
flattenList([H|T], NewList):-
        flattenList(T, Prev),
        pushElementsToList(H, Prev, NewList).

pushElementsToList([], R, R).
pushElementsToList([H|T], Prev, [H|NewList]):-
    pushElementsToList(T, Prev, NewList).



%%verifica se ha tempo para cada atividade(docente)
%%caso haja chama a funcao para aplicar a restricao de horas por atividade
%%Valor com o tempo que trabalha numa atividade
%%Indice do investigador
%%Indice da actividade
%% durAtividade(LinhaTabelaActividade,IndexInvestigador,IndexActivity)   
durAtividade(TempoInvActi,IndexInvestigador,IndexActivity):-
    ((docenteTotalHorasActividade(IndexInvestigador,TempopActividade,IndexActivity),
    TempoInvActi#=TempopActividade);
    true).

