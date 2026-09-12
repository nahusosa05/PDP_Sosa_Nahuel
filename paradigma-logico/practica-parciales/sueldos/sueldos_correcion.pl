/*
    ==========================================
    [ PUNTO 1 ]
    ==========================================
*/

% trabajaEn/2 (Persona, Departamento)
trabajaEn(kyle, ventas).
trabajaEn(trisha, ventas).
trabajaEn(joshua, ventas).
trabajaEn(ian, logistica).
trabajaEn(sherri, logistica).

% puesto/3 (Persona, Trabajo, Sueldo)
puesto(kyle, asalariado(6), 50).
puesto(sherri, asalariado(7), 60).
puesto(gus, asalariado(8), 60).
puesto(ian, jefe([kyle, rob, ginger]), 40).
puesto(trisha, jefe([ian, gus]), 90).
puesto(joshua, independiente(arquitecto), 55).


/*
    ==========================================
    [ PUNTO 2 ]
    ==========================================
*/

% sueldoPromedio/2 (Horas, SueldoPromedio)
sueldoPromedio(6, 45).
sueldoPromedio(7, 60).
sueldoPromedio(8, 80).

% esPaganini/1 (Departamento)
esPaganini(Departamento) :-
    trabajaEn(_, Departamento),
    forall(trabajaEn(Persona, Departamento), ganaBien(Persona)).

% ganaBien/1 (Persona)
ganaBien(Persona) :-
    puesto(Persona, Trabajo, Sueldo),
    cumpleCondicion(Trabajo, Sueldo).

cumpleCondicion(asalariado(Horas), Sueldo) :-
    sueldoPromedio(Horas, Promedio),
    Sueldo > Promedio.

cumpleCondicion(jefe(Subordinados), Sueldo) :-
    length(Subordinados, Cantidad),
    Sueldo > 20 * Cantidad.

cumpleCondicion(independiente(arquitecto), _).

cumpleCondicion(independiente(_), Sueldo) :-
    Sueldo > 70.

/*
    ==========================================
    [ PUNTO 3 ]
    ==========================================
*/

% leGusta/2 (Persona, Departamento)
leGusta(kyle, ventas).
leGusta(kyle, logistica).
leGusta(trisha, ventas).
leGusta(joshua, ventas).
leGusta(sherri, contabilidad).
leGusta(sherri, facturacion).
leGusta(sherri, cobranzas).

% estaEnProblemas/1 (Departamento)
estaEnProblemas(Departamento) :-
    trabajaEn(_, Departamento),
    forall(trabajaEn(Persona, Departamento), not(leGusta(Persona, Departamento))).

/*
    El forall se puede escribir en terminos de la negacion.

    departamento(Departamento) :- trabajaEn(_, Departamento).

    estaEnProblemas(Departamento) :-
        departamento(Departamento),
        not((trabajaEn(Persona, Departamento),leGusta(Persona,Departamento))).
*/

/*
    ==========================================
    [ PUNTO 4 ]
    ==========================================
*/

persona(Persona) :- puesto(Persona, _, _).

% rearmar/3 (Presupuesto, Equipo, Sobrante)
rearmarDepartamento(Presupuesto, Equipo, Sobrante) :-
    equipoValido(Equipo),
    costoEquipo(Equipo, CostoTotal),
    Presupuesto >= CostoTotal,
    Sobrante is Presupuesto - CostoTotal.

%
equipoValido(Equipo) :-
    findall(Persona, persona(Persona), Personas),
    list_to_set(Personas, PersonasUnicas),
    subconjunto(PersonasUnicas, Equipo),
    length(Equipo, Cantidad),
    Cantidad >= 2.

% explosión combinatoria
subconjunto([], []).
subconjunto([X|Xs], [X|Ys]) :- subconjunto(Xs, Ys).
subconjunto([_|Xs], Ys) :- subconjunto(Xs, Ys).

costoEquipo(Equipo, CostoTotal) :-
    findall(Sueldo, (member(Persona, Equipo), puesto(Persona, _, Sueldo)), Sueldos),
    sum_list(Sueldos, CostoTotal).