% Sócrates es humano
humano(socrates).

% Todos los humanos son mortales
% Predicado   :- (se lee "si") Antecedente
% Las variables inician con mayusculas => Persona
% Es decir que pregunta "Persona es mortal si 'humano(Persona)' "
% el único que verifica es socrates, ya que es el declarado en la base
% de conocimiento.
% Predicado mixto, usa reglas y hechos.
mortal(Persona) :- humano(Persona).

/*
    La afirmación de "Sócrates es humano" es un hecho. 
    En cambio, "Todos los humanos son mortales" es una regla.

    La principal diferencia entre hecho y la regla es que la regla
    tiene un antecedente y el hecho no, el hecho es verdadero siempre 
    (es un axioma).
*/

/*
    La abstracción fundamental del paradigma lógico son los predicados.
    Al conjunto de predicados (hechos y reglas) lo llamamos base de conocimiento.
*/

/*
    Principio de universo cerrado: 
    - El motor asume como falso todo lo que no pueda probar como verdadero.
*/

% CONJUNCIÓN AD
% Dos personas se pueden comunicar si hablan el mismo idioma.
habla(juan, espaniol).
habla(juan, ingles).
habla(juan, italiano).
habla(marcela, espaniol).
habla(hernan, aleman).

seComunican(Persona, OtraPersona):- 
    habla(Persona, Idioma), 
    habla(OtraPersona, Idioma), 
    % distinto en prolog: \=
    Persona \= OtraPersona.

/*
    Si hacemos la consulta 'habla(juan, Cual).'
    Nos va a devolver el primer elemento que encuentre en la base de conocimiento.
    Si apretamos 'n' podemos seguir entre todos los idiomas que encuentre devolviendo:
    ?- habla(juan, Cual).
    Cual = espaniol ;
    Cual = ingles ;
    Cual = italiano.
*/

/*
    Consultas: pueden ser individuales o existenciales.
    ?- seComunican(hernan,_). "¿Hernan se comunica con alguien?" 
    false

    ?- seComunican()
*/

% CONJUNCIÓN OR
% Una persona llega rápido a un lugar si vive en el barrio donde está dicho lugar
% o si viaja en auto.

viveEn(nora, almagro).
viveEn(luis, caballito).
viveEn(ana, lugano).
estaEn(lugano, campus).
estaEn(almagro, medrano).
viajaEnAuto(nora).
viajaEnAuto(matias).

/*
    La disyunción se consigue mediante la definición de varias cláusulas para el 
    mismo predicado.
*/

llegaRapido(Persona, Lugar) :-
    viveEn(Persona, Barrio),
    estaEn(Barrio, Lugar).

llegaRapido(Persona, Lugar) :-
    viajaEnAuto(Persona),
    estaEn(_, Lugar).

% NEGACIÓN NOT
/*
    Para negar el valor de verdad de una consulta utilizamos el predicado 'not/1'.
    Ej: Una persona desaprueba una materia si cursa la misma pero no la aprueba.
*/

curso(julia, fisicaI).
curso(emilio, inglesII).
curso(eli, quimica).
curso(pedro, economia).

aprobo(emilio, inglesII).
aprobo(eli, quimica).

desaprobo(Persona, Materia) :-
    curso(Persona, Materia),
    not(aprobo(Persona, Materia)).


% INVERSIBILIDAD
/*
    Que un predicado sea inversible significa que los argumentos del mismo pueden
    usarse tanto de entrada (como individuo) cómo de salida (con una variable libre).
*/

/*programaEn/2 <- El '/2' marca la cantidad de argumentos */
programaEn(nahu, java).
programaEn(juan, haskell).
programaEn(caro, python).

programaEn(_, c).
/*
    Cualquier cosa que consultemos en: programaEn(_, c).
    Va a dar true ya que el motor no sabe cuantas personas programan en C.

    ?- programaEn(Quien, c).
    true.
*/
persona(nahuel).
persona(juan).
persona(caro).

/*
programaEnInversible (Persona, c) :-
    persona(Persona).
*/

% Otro ejemplo
siguiente(Numero, Siguiente) :-
    numero(Numero),
    Siguiente is Numero + 1.

numero(Numero) :-
    between(1, 10, Numero). % Generador de numeros entre 1 y 10.

% Otro caso
mayor(Mayor, Menor) :- 
    numero(Mayor), % Le doy valor a esas variables
    numero(Menor), 
    Mayor > Menor.

/*
    El predicado not lo que niega es el valor de verdad de una consulta.
    Cómo recibe una consulta en vez de un individuo, es de orden superior.
    Es posible negar consultas individuales o existenciales.
    ?- not(programaEn(nahuel,ruby))
    true.

    ?- not(programaEn(_, cobol))
    false.
*/

% Necesidad de nuevo requerimiento
irremplazable(Persona) :-
    programaEn(Persona, Lenguaje),
    not(programaEn(Alguien, Lenguaje)),
    Alguien \= Persona.

% FORALL/2 para todo
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

tieneTodoParaVeranear(Lugar, Persona):- 
    lugarVeraneo(Lugar), 
    persona(Persona), 
    forall(quiere(Persona, Algo), lugar(Lugar, Algo)).

lugarVeraneo(Lugar) :- lugar(Lugar, _).
persona(Persona) :- quiere(Persona, _).

% ORDEN SUPERIOR Y ALGO DE LISTAS
/*
    predicado que relaciona la materia con el año
    y el predicado nota que relaciona 
*/

