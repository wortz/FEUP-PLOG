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
    write(Matrix),
    docente(DocentesList),
    contratado(ContratadosList),

    
    actividadesMeses(ActividadesMeses). 

%%Iterar sobre NrActividades e passar esse valor no param CurrentActivity
iter(Matrix,ActividadesMeses,CurrentActivity):-
    nth1(CurrentActivity,ActividadesMeses,CurrentActivityMeses),   
    nth1(CurrentActivity,Matrix,CurrentActivityMatrix).

%params
%%indice da actividade a verificar
%%lista de ActividadesMeses da current actividade
%%lista da matrix da current actividade
%%Indice da CurrentActivityMatrix a ser verificado
iterInvestigadores(IndexActivity,CurrentActivityMeses,CurrentActivityMatrix,IndexInvestigador):-
    nth1(IndexInvestigador,CurrentActivityMatrix,LinhaTabelaActividade),
    a(LinhaTabelaActividade,CurrentActivityMeses,IndexInvestigador,0).
    


%%LinhaTabelaActividade
%%

a([],_,_,_).
a([H|T],CurrentActivityMeses,IndexInvestigador,Index):-  
    Index1 is Index+1,  
    (
      (
        (mesFolga(IndexInvestigador,Index1);%%ve se index1 e mes de folga
         \+ member(Index1,CurrentActivityMeses)),
        H#=0, a(T,CurrentActivityMeses,CurrentInvMesFolga,Index1) %%mudar para =>
      )
    ; (
        retricoes_rigidas1(IndexInvestigador,H),
        a(T,CurrentActivityMeses,CurrentInvMesFolga,Index1))).


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


