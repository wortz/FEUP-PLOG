:-include('setVars.pl').
:-include('tablePrinter.pl').
:-use_module(library(lists)).
:-use_module(library(clpfd)).
%%uma
set3dMatrixAux([],_).
set3dMatrixAux([H|T],N):-
    length(H,N),
    set3dMatrixAux(T,N).

%%duas
set3dMatrix([],_).
set3dMatrix([H|T],N):-
    set3dMatrixAux(H,N),
    set3dMatrix(T,N).

func:-
    nrInvestigadores(NrInvestigadores),
    nrActividades(NrActividades),   
    duracaoProjecto(NMeses),
    length(Matrix,NrActividades),
    set3dMatrixAux(Matrix,NrInvestigadores),
    set3dMatrix(Matrix,NMeses),
    docente(DocentesList),
    contratado(ContratadosList),

    
    actividadesMeses(ActividadesMeses),
    
    iterAux(Matrix,1),
    iterarfinal(Matrix,1,NrActividades),
    flattenLists(Matrix,FlattenedMatrix),
   
    labeling([],FlattenedMatrix),
    nl,nl,

    write(FlattenedMatrix).




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
    checkInvestigador(IndexInvestigador,SumMes,1),
    ((IndexMes1 is IndexMes +1,
    IndexMes1=<Dur,
    iterAux1(Matrix,IndexInvestigador,IndexMes1,SumTotal1),
    SumTotal #= SumMes + SumTotal1);
    true).


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
    nth1(IndexInvestigador,H,CurrentInvest_Activity),%%encontra meses de investigador na actividade a ser iterada
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


restricaoTempoDedicarProjeto(IndexInvestigador,SumTotal):-
    ((docenteTotalHorasProjecto(IndexInvestigador,HorasADedicar),
    SumTotal #=HorasADedicar);
    true).


%params
%% Variavel de Mes actual (a restringir)
%% 
a(M,IndexActivity,IndexInvestigador,IndexMes):- 
    (
        (mesFolga(IndexInvestigador,IndexMes);%%ve se indexMes e mes de folga
        (actividadesMeses(ActividadesMeses),
        nth1(IndexActivity,ActividadesMeses,CurrentActivityMeses),
        \+ member(IndexMes,CurrentActivityMeses))),
        M#=0
      )
    ;(
        checkInvestigador(IndexInvestigador,M,2)
    ).



%%verifica se ha tempo para cada atividade(docente)
%%caso haja chama a funcao para aplicar a restricao de horas por atividade
%%Linha com as variaveis para cada mes para uma actividade
%%Indice do investigador
%%Indice da actividade
%% durAtividade(LinhaTabelaActividade,IndexInvestigador,IndexActivity)   
durAtividade(LinhaTabelaActividade,IndexInvestigador,IndexActivity):-
    %%TempopActividade é o valor que um investigador deve dedicar a uma atividade 
    domain(LinhaTabelaActividade,1,30),
    docenteTotalHorasActividade(IndexInvestigador,TempopActividade,IndexActivity),
    restricaoTotalHorasActividade(LinhaTabelaActividade,Sum),
    Sum #=TempopActividade,
    maximum(Maxi,LinhaTabelaActividade),
    minimum(Mini,LinhaTabelaActividade),
    Diferenca#=Maxi-Mini,
    labeling([minimize(Diferenca)],LinhaTabelaActividade),
    write(LinhaTabelaActividade).


%%itera pela lista de um investigador para uma atividade e aplica a restricao de horas por actividade
restricaoTotalHorasActividade([],0).
restricaoTotalHorasActividade([H|T],Sum):-
    restricaoTotalHorasActividade(T,Sum1),
    Sum #= H + Sum1.

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
iterarfinal(Matrix,IndexActivity,NrAtividades):-
    nth1(IndexActivity,Matrix,CurrentActivityMatrix),
    iterInvestigadores(CurrentActivityMatrix,SumMeses),
    duracaoActividades(X),nth1(IndexActivity,X,HorasNecessarias),
    SumMeses #= HorasNecessarias,
    ((IndexActivity1 is IndexActivity + 1,
    IndexActivity1 =< NrAtividades,
    iterarfinal(Matrix,IndexActivity1,NrAtividades));
    true).


%params
%%indice da actividade a verificar
%%lista de ActividadesMeses da current actividade
%%lista da matrix da current actividade
%%Indice da CurrentActivityMatrix a ser verificado
iterInvestigadores([],0).
iterInvestigadores([H|T],SumMeses):-
    iterSomaInv(H,SomaInv),
    iterInvestigadores(T,SumMeses1),
    SumMeses #= SomaInv + SumMeses1.


iterSomaInv([],0).
iterSomaInv([H|T],SomaInv):-
    iterSomaInv(T,SomaInv1),
    SomaInv #= H + SomaInv1.




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