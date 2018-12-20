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
%%lista de ActividadesMeses da current actividade
%%lista da matrix da current actividade
%%Indice da CurrentActivityMatrix a ser verificado
iterInvestigadores(CurrentActivityMeses,CurrentActivityMatrix,CurrentInvestigator):-
    nth1(CurrentInvestigator,CurrentActivityMatrix,LinhaTabelaActividade),
    mesFolga(CurrentInvestigator,CurrentInvMesFolga).


%%LinhaTabelaActividade
%%

a([],_,_,_).
a([H|T],CurrentActivityMeses,CurrentInvMesFolga,Index):-  
    Index1 is Index+1,  
    (
      (
        (Index1 = CurrentInvMesFolga;
         \+ member(Index1,CurrentActivityMeses)),
        H#=0, a(T,CurrentActivityMeses,CurrentInvMesFolga,Index1)
      )
    ; a(T,CurrentActivityMeses,CurrentInvMesFolga,Index1)).



        

        



%%
%%nth1(1,DuracaoActividades,NrHorasAtividade1),
%%NrHorasAtividade1 #= somaDoc1 + somaCont1

%% matrix 3d - acti, invest, meses DONE
%%dimensao actividad - restriçao rigida das horas totais , mes em que nao se trabalha e optimizacao final(flex)
%%restricao 1 ir a todos os inv numa activi e para cada mes restriçao rigida das horas totais  
%%flexiveis - tipo carteiro pergui , para actividade e para invest


