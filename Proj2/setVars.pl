nrInvestigadores(2).

%%%%%%%%%%%%%%%DOCENTES%%%%%%%%%%%%%
docente([1]).

%%Docente (1) com limite de 12 horas mensais
docenteMaxHorasMensais(1,12).

%%Docente (1) com total de 90h dedicadas ao projecto
docenteTotalHorasProjecto(1,90).

%%Docente com total de horas dedicadas a actividade (caso em que não existe)
docenteTotalHorasActividade(0,42,1).

%%Docente (1) não trabalha no mes 6
mesFolga(1,6).


%%%%%%%%%%%%%%%CONTRATADOS%%%%%%%%%%%
contratado([2]).

%%Contratado (2) com dedicação de 145 mensais ao proj
contratadoHorasMensais(2,145).

%%Contratado (2) não trabalha no mes 8
mesFolga(2,8).


%%%%%%%%%%%%%%%PROJECTO%%%%%%%%%%%%%%
%%10 - nr de meses que dura o proj
duracaoProjecto(10).

nrActividades(2).

%%Horas que demoram cada actividade
duracaoActividades([875,520]).

%%Meses em que estao activas actividades
actividadesMeses([[1,2,3,4,5,6],[6,7,8,9,10]]).

%%DUVIDA COMO FAZER MAXIMIZE DE TODOS OS VALORES