/*
    ==========================================
    [ PUNTO 1 ]
    ==========================================
*/

% trabajaEn\2 (Persona, Departamento)
trabajaEn(kyle, ventas).
trabajaEn(trisha, ventas).
trabajaEn(joshua, ventas).
trabajaEn(ian, logistica).
trabajaEn(sherri, logistica).

/*
    ERROR 1: Separar en 3 predicados distintos no
    permite usar poliformismo y patter matching.
    Lo ideal es hacer un predicado 'sueldo/2'
    usando functores.
    'sueldo(kyle, asalariado(6, 50)).'
    'sueldo(ian, jefe([kyle, rob, ginger], 40)).'
    'sueldo(joshua, independiente(arquitecto, 55)).'
*/

% asalariado\3 (Persona, Horas, Sueldo)
asalariado(kyle, 6, 50).
asalariado(sherri, 7, 60).
asalariado(gus, 8, 60).
% jefe\3 (Persona, [Persona], Sueldo)
jefe(ian, [kyle,rob,ginger], 40).
jefe(trisha, [ian,gus], 90).
% independiente\ (Persona, Oficio, Sueldo)
independiente(joshua, arquitecto, 55).


/*
    ==========================================
    [ PUNTO 2 ]
    ==========================================
*/

% ganaBien\1 (Departamento)
esPaganini(Departamento) :-
    trabajaEn(Persona, _), % ERROR 2: Es Departamento la variable a ligar, no Persona.
    forall(trabajaEn(Persona, Departamento), ganaBien(Persona)).

/*
    ERROR 3: Al cambiar los 3 predicados anteriores y poner el sueldo 
    como functor, el predicado 'ganaBien/2' cambia totalmente.
    ------------------------------------------------
    ganaBien(Persona) :-
        sueldo(Persona, asalariado(Horas, Sueldo)),
        sueldoPromedio(Horas, Promedio),
        Sueldo > Promedio.
    ------------------------------------------------
*/

% ganaBien\1 (Persona)
ganaBien(Persona) :-
    asalariado(Persona, Horas, Sueldo),
    Sueldo > (Sueldo / Horas). 

ganaBien(Persona) :-
    jefe(Persona, Subordinados, Sueldo),
    length(Subordinados, CantidadSubordinados),
    Sueldo > 20 * CantidadSubordinados.
    
ganaBien(Persona) :-
    independiente(Persona, _, Sueldo),
    Sueldo > 70.

/* 
    Duda: "Gana bien si gana más que el promedio en base a las horas trabajadas."
    ERROR 4: El promedio de sueldo por horas es un dato fijo que da el enunciado.
    Se modela como hechos auxiliares.
    Ej: 'sueldoPromedio(6, 45).'
*/

/*
    ==========================================
    [ PUNTO 3 ]
    ==========================================
*/

% leGusta\2 (Persona, Departamento)
leGusta(kyle, ventas).
leGusta(kyle, logistica).
leGusta(trisha, ventas).
leGusta(joshua, ventas).
leGusta(sherri, contabilidad).
leGusta(sherri, facturacion).
leGusta(sherri, cobranzas).

% estaEnProblemas(Departamento)
estaEnProblemas(Departamento) :-
    trabajaEn(_, Departamento),
    forall(trabajaEn(Persona, Departamento), not(leGusta(Persona, Departamento))).


/*
    ==========================================
    [ PUNTO 4 ]
    ==========================================
*/

/*
Problemas de esta version:
   1. Solo evalúa equipos fijos de exactamente 2 personas (el enunciado pide "por lo menos 2").
   2. 'calcularSueldo/2' recibía el átomo 'kyle' pero macheaba contra 'asalariado(...)'.
   3. No devolvía la lista del equipo armado ni el sobrante del presupuesto (BONUS).
Ver: sueldos_correcion.pl para ver cómo hacerlo.
*/

rearmar(Presupuesto, Departamento) :-
    trabajaEn(Persona, Departamento),
    trabajaEn(OtraPersona, Departamento),
    Persona \= OtraPersona,
    calcularSueldo(Persona, SueldoA),
    calcularSueldo(OtraPersona, SueldoB),
    Presupuesto > SueldoA + SueldoB.

calcularSueldo(asalariado(_,_, Sueldo), Sueldo).
calcularSueldo(jefe(_,_, Sueldo), Sueldo).
calcularSueldo(independiente(_,_, Sueldo), Sueldo).