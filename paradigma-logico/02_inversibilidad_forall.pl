/* ============================================================================
   Clase: 26/06/2026 - Lógico II
   Temas: Inversibilidad, Generadores de Dominio, Predicado de Orden Superior
          forall/2, Pattern Matching con Functores (Estructuras de datos).
   ============================================================================ */

% -----------------------------------------------------------------------------
% 1. GENERACIÓN E INVERSIBILIDAD CON OPERADORES ARITMÉTICOS Y NEGACIÓN
% --------------------------------------------------------------------------------------------------------------------------------------------------------

% Denifición de Dominio
persona(nahuel).
persona(juan).
persona(caro).

numero(Numero) :-
    between(1, 10, Numero). % Genera números del 1 al 10

% Los operadores aritméticos (is, >, <) y la negación (not) NO SON INVERSIBLES por sí solos.
% Necesitan que las variables lleguen LIGADAS (unificadas con un valor previo).

siguiente(Numero, Siguiente) :-
    numero(Numero),             % Ligo la variable Numero
    Siguiente is Numero + 1.    % Evalúo si Siguiente es Numero + 1

mayor(Mayor, Menor) :-
    numero(Mayor),      % Ligo Mayor a numeros del 1 al 10.
    numero(Menor),      % Ligo Menor a numeros del 1 al 10.
    Mayor > Menor.      % Evalúo condición relacional.

programaEn(nahuel, java).
programaEn(juan, haskell).
programaEn(caro, python).

irremplazable(Persona) :-
    persona(Persona),
    programaEn(Persona, Lenguaje),
    not(programaEn(Alguien, Lenguaje)), 
    Alguien \= Persona.

% -----------------------------------------------------------------------------
% 2. PREDICADO DE ORDEN SUPERIOR: forall/2
% -----------------------------------------------------------------------------

/*
   Sintaxis: forall(CondicionAntecedente, CondicionConsecuente)
   Significado: "Para TODO elemento que cumpla el Antecedente, TAMBIÉN se debe 
                 cumplir el Consecuente."

   Mecánica de Evaluación del forall:
   forall(A, B) es equivalentemente lógico a:  not( A , not(B) )
   "No existe ningún A para el cual NO se cumpla B".
*/

quiere(juan, playa).
quiere(juan, wifi).
quiere(juan, teatro).

quiere(ana, sierra).
quiere(ana, playa).

lugar(mardel, playa).
lugar(mardel, wifi).
lugar(mardel, teatro).
lugar(mardel, casino).

lugar(tandil, sierra).
lugar(tandil, teatro).

% Un lugar tiene todo para veranear para una persona si TODOS los deseos de esa persona
% se encuentran disponibles en ese lugar.

lugarVeraneo(Lugar) :- lugar(Lugar, _).
personaVeraneante(Persona) :- quiere(Persona, _).

tieneTodoParaVeranear(Lugar, Persona) :-
    lugarVeraneo(Lugar),
    personaVeraneante(Persona),
    forall(quiere(Persona, Algo), lugar(Lugar, Algo)).

/*
   ¿Cómo funciona la Inversibilidad con forall/2?
   - Si no ponemos los generadores 'lugarVeraneo(Lugar)' y 'personaVeraneante(Persona)',
     y consultamos `?- tieneTodoParaVeranear(Lugar, Persona).`, 'forall/2' NO sabrá
     qué combinaciones de Lugar y Persona debe probar.
   - REGLA DE ORO: Las variables principales que entran al 'forall/2' DEBEN llegar 
     LIGADAS desde afuera del forall.
*/

% Si agregamos una persona veraneante y ningún quiere(felipe, ...):
personaVeraneante(felipe).

/*
    Al realiar la consulta:
        ?- tieneTodoParaVeranear(tandil, felipe).
        true.

    Por el concepto de verdad vacua: El forall(A, B) evalúa "para todo A se cumple B". 
    Si no existe ningún A (el antecedente es vacío), no hay ningún deseo que Tandil pueda 
    "incumplir". Por lo tanto, el forall se considera verdadero por defecto.
*/