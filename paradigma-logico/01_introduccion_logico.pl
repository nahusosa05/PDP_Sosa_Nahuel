/* ============================================================================
   Clase: 19/06/2026 - Lógico I
   Temas: Base de Conocimientos, Predicados, Aridad, Principio de Universo
          Cerrado, Conjunción (,), Disyunción (múltiples cláusulas), 
          Negación (not/1) e Introducción a la Inversibilidad.
   ============================================================================ */

% -----------------------------------------------------------------------------
% 1. PREDICADOS, HECHOS Y REGLAS
% -----------------------------------------------------------------------------

% Hecho: Afirmación incondicional de la realidad.
% humano/1: El predicado 'humano' tiene aridad 1 (monádico).
humano(socrates).
humano(platon).

% Regla: Afirmación condicional. Posee cabeza y antecedente (separados por :-).
% mortal/1: Una Persona es mortal SI es humano.
% 'Persona' inicia con Mayúscula => Es una Variable.
mortal(Persona) :- 
    humano(Persona).

/*
   Axioma teórico:
   - Base de Conocimientos: Conjunto de predicados (hechos y reglas).
   - Principio de Universo Cerrado (PUC): Todo lo que no esté afirmado 
     o no pueda ser deducido lógicamente a partir de las reglas, SE ASUME FALSO.
*/


% -----------------------------------------------------------------------------
% 2. CONJUNCIÓN LÓGICA ( Y - Representada por la coma ',' )
% -----------------------------------------------------------------------------

% habla/2: Expresa la relación entre una persona y un idioma.
habla(juan, espaniol).
habla(juan, ingles).
habla(juan, italiano).
habla(marcela, espaniol).
habla(hernan, aleman).

% Dos personas se comunican si hablan el MISMO idioma Y son personas distintas.
seComunican(Persona, OtraPersona) :- 
    habla(Persona, Idioma), 
    habla(OtraPersona, Idioma), 
    Persona \= OtraPersona.


% -----------------------------------------------------------------------------
% 3. DISYUNCIÓN LÓGICA ( O - Representada con múltiples cláusulas )
% -----------------------------------------------------------------------------

viveEn(nora, almagro).
viveEn(luis, caballito).
viveEn(ana, lugano).

estaEn(lugano, campus).
estaEn(almagro, medrano).

viajaEnAuto(nora).
viajaEnAuto(matias).

% Una persona llega rápido a un lugar si vive en el barrio del lugar O viaja en auto.
% Buenas prácticas: Se abstrae el "O" en cláusulas separadas para no duplicar código.

llegaRapido(Persona, Lugar) :-
    viveEn(Persona, Barrio),
    estaEn(Barrio, Lugar).

llegaRapido(Persona, Lugar) :-
    viajaEnAuto(Persona),
    estaEn(_, Lugar).  % Usamos variable anónima '_' porque no nos interesa el barrio.


% -----------------------------------------------------------------------------
% 4. NEGACIÓN ( not/1 ) Y PRINCIPIO DE UNIVERSO CERRADO
% -----------------------------------------------------------------------------

curso(julia, fisicaI).
curso(emilio, inglesII).
curso(eli, quimica).
curso(pedro, economia).

aprobo(emilio, inglesII).
aprobo(eli, quimica).

% 'not/1' niega la condición de su argumento.
% ¡OJO! 'not/1' NO genera valores, solo filtra variables previamente ligadas.
desaprobo(Persona, Materia) :-
    curso(Persona, Materia),        % Genera las variables Persona y Materia
    not(aprobo(Persona, Materia)).  % Filtra sobre las variables generadas