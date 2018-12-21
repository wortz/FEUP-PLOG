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
    
    iter(Matrix,1,1,1,Matrix,_),nl,nl,
    write(Matrix). 


iter([],IndexMes,IndexInvestigador,_,Matrix,SumMes):-  %%passar 2 vezes a Matrix?? acho q tem de ser
    duracaoProjecto(Dur),
    nrInvestigadores(NrInv),
    ((
        IndexMes1 is IndexMes +1,
        IndexMes1=<Dur,
        SumMes=0,
        iter(Matrix,IndexMes1,IndexInvestigador,1,Matrix,SumMes1)
    )
    ;(  
        IndexInvestigador1 is IndexInvestigador+1,  %%chega ao fim dos meses, checka outro inv
        (
            IndexInvestigador1 =< NrInv,
            iter(Matrix,1,IndexInvestigador1,1,Matrix,SumMes)
        )
            ;true
    )).
iter([H|T],IndexMes, IndexInvestigador,IndexActivity,Matrix,SumMes):-
    nth1(IndexInvestigador,H,CurrentInvest_Activity),%%encontra meses de investigador na actividade a ser iterada
    nth1(IndexMes,CurrentInvest_Activity,M),
    a(M,IndexActivity,IndexInvestigador,IndexMes),
    IndexActivity1 is IndexActivity+1,
    iter(T,IndexMes, IndexInvestigador,IndexActivity1,Matrix,SumMesAux).
    SumMes #= SumMesAux + M,
    checkInvestigador(IndexInvestigador,SumMes).

%%params
%%Index do invest
%% Funçao pode ser usada para restringir a soma das horas de trabalho
%de um investigador num mes, ou para restringir as horas de um mes numa acti
checkInvestigador(IndexInvestigador,SumMes_ou_MaxMes):-
    (
        docente(X),member(IndexInvestigador,X),      
        docenteMaxHorasMensais(IndexInvestigador,HorasMesDocente),
        SumMes_ou_MaxMes in 0..HorasMesDocente
    );
    (
        contratado(Y),member(IndexInvestigador,Y),
        contratadoHorasMensais(IndexInvestigador,HorasMesContratado),
        SumMes_ou_MaxMes #= HorasMesContratado
    ).





%params
%% Variavel de Mes actual (a restringir)
%% 
a(M,IndexActivity,IndexInvestigador,IndexMes):- 
    (
        (mesFolga(IndexInvestigador,IndexMes);%%ve se indexMes e mes de folga
        (actividadesMeses(ActividadesMeses),
        nth1(IndexActivity,ActividadesMeses,CurrentActivityMeses),
        \+ member(IndexMes,CurrentActivityMeses))),
        M=0
      )
    ;(
        checkInvestigador(IndexInvestigador,M)
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


