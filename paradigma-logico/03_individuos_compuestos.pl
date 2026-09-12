/* ============================================================================
   Clase: 26/06/2026 - Lógico II
   Temas: Functores (Individuos Compuestos), Pattern Matching Estructural, 
          Polimorfismo en Lógico, Listas y Manipulación de Colecciones.
   ============================================================================ */

% -----------------------------------------------------------------------------
% 1. FUNCTORES (INDIVIDUOS COMPUESTOS) Y PATTERN MATCHING
% -----------------------------------------------------------------------------

/*
   ¿Qué es un Functor?
   Un functor es una estructura de datos que permite agrupar varios individuos 
   relacionados bajo un mismo concepto.
   
   ¡IMPORTANTE PARA TEORÍA!
   Un functor NO es un predicado. Un functor no se puede consultar directamente
   en la consola (daría error de predicado no existente); vive siempre DENTRO 
   de un argumento de un predicado.
   
   Sintaxis: nombreFunctor(Atributo1, Atributo2, ...)
*/

% Base de conocimientos de personas con sus ocupaciones (usando Functores):
personaRegistrada(persona(nahuel, estudiante(sistemas, utn))).
personaRegistrada(persona(caro, trabajador(mercadolibre, 2500))).
personaRegistrada(persona(pepe, desempleado)).

/*
   PATTERN MATCHING EN LA CABEZA DE LA REGLA
   Prolog permite matchear la estructura del functor directamente en el 
   encabezado de la regla. Esto nos permite filtrar por tipo de ocupación y 
   desestructurar sus atributos en un solo paso.
*/

% Filtra solo a los estudiantes que pertenecen a la UTN
esEstudianteUTN(Nombre) :-
    personaRegistrada(persona(Nombre, estudiante(_, utn))).

% Filtra solo a los trabajadores y evalúa su sueldo (Asegurando Inversibilidad)
esTrabajadorConBuenSueldo(Nombre) :-
    personaRegistrada(persona(Nombre, trabajador(_, Sueldo))),
    Sueldo > 2000.


% -----------------------------------------------------------------------------
% 2. POLIMORFISMO MEDIANTE FUNCTORES
% -----------------------------------------------------------------------------

/*
   Gracias a los functores, un mismo predicado puede tratar de forma polimórfica 
   distintos tipos de individuos compuestos.
   
   Ejemplo: Calcular los ingresos mensuales de una persona según su ocupación.
*/

ingresosMensuales(persona(Nombre, trabajador(_, Sueldo)), Sueldo) :-
    personaRegistrada(persona(Nombre, trabajador(_, Sueldo))).

ingresosMensuales(persona(Nombre, estudiante(_, _)), 0) :-
    personaRegistrada(persona(Nombre, estudiante(_, _))).

ingresosMensuales(persona(Nombre, desempleado), 0) :-
    personaRegistrada(persona(Nombre, desempleado)).


% -----------------------------------------------------------------------------
% 3. LISTAS Y PATTERN MATCHING ESTRUCTURAL ( Cabeza | Cola )
% -----------------------------------------------------------------------------

/*
   Una Lista es una colección ordenada de elementos delimitada por corchetes [].
   
   Notación Cabeza/Cola: [Cabeza | Cola]
   - Cabeza (Head): El primer elemento de la lista.
   - Cola (Tail): Una LISTA con los elementos restantes (puede ser vacía []).
*/

% Hechos con listas como argumentos
notasParciales(nahuel, [8, 9, 10]).
notasParciales(pepe, [2, 4]).
notasParciales(caro, []).

% Pattern Matching para obtener la primera nota de un alumno
primeraNota(Alumno, Nota) :-
    notasParciales(Alumno, [Nota | _]).   % Matchea la Cabeza de la lista

% Verificar si un alumno rindiós al menos dos exámenes
rindioAlMenosDosExamenes(Alumno) :-
    notasParciales(Alumno, [_, _ | _]).   % Matchea al menos 2 elementos