NrInvestigadores(2).

%%%%%%%%%%%%%%%DOCENTES%%%%%%%%%%%%%
Docente([1]).

%%Docente (1) com limite de 12 horas mensais
DocenteMaxHorasMensais(1,12).

%%Docente (1) com total de 90h dedicadas ao projecto
DocenteTotalHorasProjecto(1,90).

%%Docente (1) não trabalha no mes 6
MesFolgaDocente(1,6).


%%%%%%%%%%%%%%%CONTRATADOS%%%%%%%%%%%
Contratado([2]).

%%Contratado (2) com dedicação de 145 mensais ao proj
ContratadoHorasMensais(2,145).

%%Contratado (2) não trabalha no mes 8
MesFolgaDocente(2,8).


%%%%%%%%%%%%%%%PROJECTO%%%%%%%%%%%%%%
%%10 - nr de meses que dura o proj
DuracaoProjecto(10).

NrActividades(2).

%%Horas que demoram cada actividade
DuracaoActividades([875,520]).

%%Meses em que estao activas actividades
ActividadesMeses([[1,2,3,4,5,6],[6,7,8,9,10]]).
