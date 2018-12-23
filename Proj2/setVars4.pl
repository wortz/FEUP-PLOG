nrInvestigadores(2).

%%%%%%%%%%%%%%%DOCENTES%%%%%%%%%%%%%
docente([1]).

%%Docente (1) com limite de 12 horas mensais
docenteMaxHorasMensais(1,15).

%%Docente (1) com total de 90h dedicadas ao projecto
docenteTotalHorasProjecto(1,59).

%%Docente com total de horas dedicadas a actividade (caso em que não existe)
docenteTotalHorasActividade(0,42,1).

%%Docente (1) não trabalha no mes 6
mesFolga(1,4).


%%%%%%%%%%%%%%%CONTRATADOS%%%%%%%%%%%
contratado([2]).

%%Contratado (2) com dedicação de 145 mensais ao proj
contratadoHorasMensais(2,120).

%%Contratado (2) não trabalha no mes 8
mesFolga(2,2).


%%%%%%%%%%%%%%%PROJECTO%%%%%%%%%%%%%%
%%10 - nr de meses que dura o proj
duracaoProjecto(5).

nrActividades(3).

%%Horas que demoram cada actividade
duracaoActividades([127,175,237]).

%%Meses em que estao activas actividades
actividadesMeses([[1,2,3],[3,4,5],[1,2,3,4,5]]).