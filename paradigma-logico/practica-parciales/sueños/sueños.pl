/*
    ========================
            PUNTO 1
    ========================
*/

% Gabriel cree en camapnita, el Mago de Oz y Cavenaghi.
cree(gabriel, campanita).
cree(gabriel, elMagoDeOz).
cree(gabriel, cavenaghi).

% Juan cree en el Conejo de Pasuca.
cree(juan, conejoPascua).

% Macarena cree en los Reyes Magos, el Mago Carpia y Campanita.
cree(macarena, reyesMagos).
cree(macarena, magoCapria).
cree(macarena, campanita).

% Diego no cree en nadie. (No de codea nada)

/*
    Nota: Usar listas en el predicado cree\2 es innecesario ya que si las usamos es necesario
    hacer un predicado auxiliar para verificar una consulta sencilla cómo 'cree(gabriel, Quien).'.
    Prolog lo hace por defecto, entonces mejor no complicarse la vida.
*/

/*
    Definimos los sueños cómo functores. Hay 3 tipos de sueños:
        - Ser un cantante y vender una cierta cantidad de "discos" (= bajadas).
            cantante(Discos que desea vender)

        - Ser un futbolista y jugar en algún equipo.
            futbolista(Equipo que desea jugar)

        - Ganar la lotería apostando una serie de números.
            ganarLoteria([Numeros con los que desea ganar])
*/

% "[Persona] quiere [Sueño]." 
% quiere(Persona, Sueño)

% Gabriel quiere ganar la lotería apostando al 5 y al 9, y también quere ser un futbolista de Arsenal.
quiere(gabriel, ganarLoteria([5,9])). 
quiere(gabriel, futbolista(arsenal)).

% Juan quere ser un cantante que venda 100.000 discos.
quiere(juan, cantante(100000)).

% Macarena no quiere ganar la lotería, si ser cantante estilo "Eruca sativa" y vender 10.000 discos.
% - Lo que tenemos que tomar directamente es el sueño de Macarena: "Macarena quiere ser cantante que venda 10.000 discos"
quiere(macarena, cantante(10000)).

/*
    Punto 1.a: Indicar qué conceptos entraron en juego para cada punto.

    Los conceptos del paradigma lógico que entraron en esta parte son el Principio de Universo Cerrado, los functores, 
    los predicados y los individuos simples y compuestos.
*/

/*
    ========================
            PUNTO 2
    ========================
*/

/*
    Queremos saber si [una persona es ambiciosa], esto ocurre cuando la suma de dificultades de los sueños es mayor a 20.
    La dificultad de cada sueño se calcula cómo:
        - 6 para ser cantante que vende más de 500000 o 4 en caso contrario.
        - Ganar la lotería implica una dificultad de 10 multiplicado por la cantidad de los números apostados.
        - Lograr ser un futbolista tiene una dificultad de 3 en equipo chico o 16 en caso contrario. Arsenal y
        Aldosivi son equipos chicos.

    El predicado debe ser inversible.

    Ejemplo: "Gabriel es ambicioso, porque quiere ganar a la lotería con 2 números (20 dificultad) y quiere ser 
                futbolista de Arsenal (3 difucltad), lo que su dificultad total es 23 y es mayor que 20."

    Nota: Lo que está marcado con [] definimos lo que se quiere saber o poder consultar con la regla creada. Dicho de otra
    manera, definimos los "parámetros de la función", por más que esté mal dicho.
*/

% Para no generar repetidos en las consultas por el predicado quiere\2, creo el predicado persona para poder ligarlas y que
% esAmbiciosa\1 sea completamente inversible.
persona(gabriel).
persona(macarena).
persona(juan).

esAmbiciosa(Persona) :-
    persona(Persona),
    sumaTotalDificultades(Persona, Total),
    Total > 20.

sumaTotalDificultades(Persona, Total) :-
    findall(Dificultad, dificultad(Persona, Dificultad) , ListaDificultades),
    sumlist(ListaDificultades, Total).

dificultad(Persona, Dificultad) :-
    quiere(Persona, Suenio),
    calcularDificultad(Suenio, Dificultad).

% Calculo de dificultad de los que quieren ser cantantes
calcularDificultad(cantante(Discos), 6) :-
    Discos > 500000.

calcularDificultad(cantante(Discos), 4) :-
    Discos =< 500000.

% Calculo de dificultad de los que quieren ganar la lotería
calcularDificultad(ganarLoteria(Numeros), Total) :-
    length(Numeros, CantidadNumeros),
    Total is 10 * CantidadNumeros.

% Calculo de dificultad de los que quieren ser futbolistas
calcularDificultad(futbolista(Equipo), 3) :-
    equipoChico(Equipo).

calcularDificultad(futbolista(Equipo), 16) :-
    not(equipoChico(Equipo)).

% Defino equipos chicos.
equipoChico(arsenal).
equipoChico(aldosivi).

/*
    ========================
            PUNTO 3
    ========================
*/

/*
    Queremos saber si [un personaje tiene qímica con una persona]. Esto se da:
        - Si la persona cree en el persona y:
            (*) Para camapanita, la persona debe tener al menos un sueño de dificultad menor a 5.
            (*) Para el resto, todos los sueños deben ser puros (ser futbolista o cantante de menos 
            de 200000 discos) y la persona no debe ser ambiciosa.

    No se puede utilizar findall en este punto. El predicado debe ser inversible.
*/

tieneQuimica(Personaje, Persona) :-
    cree(Persona, Personaje),
    cumpleCondicion(Persona, Personaje).

cumpleCondicion(Persona, campanita) :-
    dificultad(Persona, Dificultad),
    Dificultad < 5.

cumpleCondicion(Persona, Personaje) :-
    Personaje \= campanita,
    tieneSueniosPuros(Persona),
    not(esAmbiciosa(Persona)).

tieneSueniosPuros(Persona) :-
    forall(quiere(Persona, Suenio), esPuro(Suenio)).

esPuro(futbolista(_)).
esPuro(cantante(Discos)) :- Discos < 200000.

/*
    ========================
            PUNTO 4
    ========================
*/

/*
    Necesitamos definir [si un personaje puede alegrar a una persona], esto ocurre:
        - Si una persona tiene algún sueño.
        - Si el personaje tiene química con la persona.
        - El personaje no está enfermo o algún personaje de backup no está enfermo. Un personaje de
        backup es un amigo directo o indirecto del personaje principal.
*/

puedeAlegrar(Personaje, Persona) :-
    quiere(Persona, _),
    tieneQuimica(Personaje, Persona),
    cumpleCondicionAlegrar(Personaje).

cumpleCondicionAlegrar(Personaje) :-
    not(estaEnfermo(Personaje)).

cumpleCondicionAlegrar(Personaje) :-
    backup(Personaje, Backup),
    cumpleCondicionAlegrar(Backup).

% Capanita, los Reyes Magos y el Conejo de Pascua están enfermos.
estaEnfermo(campanita).
estaEnfermo(reyesMagos).
estaEnfermo(conejoPascuas).

backup(Personaje, Backup) :-
    amigo(Personaje, Backup).

backup(Personaje, Backup) :-
    amigo(Personaje, OtroPersonaje),
    backup(OtroPersonaje, Backup).

amigo(campanita, reyesMagos).
amigo(campanita, conejoPascuas).
amigo(conejoPascuas, cavenaghi).

