%% a chamar com tableHeader(Months, 0)

tableHeader(Months, Counter):-
    Counter1 is Counter + 1,
    write('M'),write(Counter1),write('|'),
    ((Counter1=Months,
    write('Total'), nl);
    tableHeader(Months,Counter1))
    .

printSeparator:- nl,write('___________________________________').

print_line([],_,_).
print_line([H|T],Counter, ActividadeMeses):-

    (
        (member(Counter,ActividadeMeses),write(H))
        ;
        (write(' '))
    ),	
	write('|'),
    Counter1 is Counter+1,
	print_line(T,Counter1,ActividadeMeses).

printActivity(_,3,_,_).
printActivity(Matrix,IndexActivity,ActividadesMeses,DurActividades):-
    write('A'),write(IndexActivity),write(' '),
    nth1(IndexActivity,ActividadesMeses,ActividadeMeses),   
    nth1(IndexActivity,Matrix,CurrActLinhas),
    nth1(IndexActivity,DurActividades,DurActividade),
    printInvestigadores(CurrActLinhas,1,ActividadeMeses,DurActividade),
   %% printSeparator,  
    nl, 
    IndexActivity1 is IndexActivity+1,
    printActivity(Matrix,IndexActivity1,ActividadesMeses,DurActividades).

printInvestigadores(_,3,_,_).
printInvestigadores(CurrActLinhas,IndexInvestigador,ActividadeMeses,DurActividade):-
    nth1(IndexInvestigador,CurrActLinhas,CurrentLine),
    %%fazer : se investigador for !=1, imprimir espaços
    (IndexInvestigador\=1, write('   ');true),
    write('I'),write(IndexInvestigador),write(' |'),
    print_line(CurrentLine,1,ActividadeMeses),
    (
        (IndexInvestigador=1,write(' '),write(DurActividade),write(' |'));
        (write('     |'))
    ),
  %%  printSeparator,
    nl,   
    IndexInvestigador1 is IndexInvestigador+1,
    printInvestigadores(CurrActLinhas,IndexInvestigador1,ActividadeMeses,DurActividade).



%%
printTable(Matrix):-
    write('       '),
    duracaoProjecto(D),
    actividadesMeses(ActividadesMeses),
    duracaoActividades(DurActividades),
    tableHeader(D,0),
    printActivity(Matrix,1,ActividadesMeses,DurActividades).


%%Iterar sobre NrActividades e passar esse valor no param IndexActivity
iter(Matrix,ActividadesMeses,IndexActivity):-
    nth1(IndexActivity,ActividadesMeses,IndexActivityMeses),   
    nth1(IndexActivity,Matrix,IndexActivityMatrix).
