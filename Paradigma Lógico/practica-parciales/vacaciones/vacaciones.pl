/*
    ==========================================
                    PUNTO 1
    ==========================================

    Sabemos que Dodain se va a Pehuenia, San Martín (de los Andes), Esquel, Sarmiento, Camarones y Playas 
    Doradas. Alf, en cambio, se va a Bariloche, San Martín de los Andes y El Bolsón. Nico se va a Mar del Plata, 
    como siempre. Y Vale se va para Calafate y El Bolsón. 
        ●  Además Martu se va donde vayan Nico y Alf.  
        ●  Juan no sabe si va a ir a Villa Gesell o a Federación 
        ●  Carlos no se va a tomar vacaciones por ahora 
*/

% viaja\2(Persona, Destino).
viaja(dodain, pehuenia).
viaja(dodain, sanMartinDeLosAndes).
viaja(dodain, esquel).
viaja(dodain, sarmiento).
viaja(dodain, camarones).
viaja(dodain, playasDoradas).

viaja(alf, bariloche).
viaja(alf, sanMartinDeLosAndes).
viaja(alf, elBolson).

viaja(nico, marDelPlata).

viaja(vale, calafate).
viaja(vale, elBolson).

viaja(martu, Destino) :- viaja(nico, Destino).
viaja(martu, Destino) :- viaja(alf, Destino).

/*
    Por principio de universo cerrado no modelamos a Juan ni Carlos ya que, para el caso de Carlos
    todo conocimiento que no esté en la base de conocimientos es falso.
    Para el caso de Juan, no podemos modelar la duda o incertidumbre directamente. Si agregáramos 
    hechos para Villa Gesell y Federación, estaríamos afirmando que viaja con certeza a ambos.
*/

/*
    ==========================================
                    PUNTO 2
    ==========================================

    Incorporamos ahora información sobre las atracciones de cada lugar. Las atracciones se dividen en 
        ●  Un parque nacional, donde sabemos su nombre 
        ●  Un cerro, sabemos su nombre y la altura 
        ●  Un cuerpo de agua (cuerpoAgua, río, laguna, arroyo), sabemos si se puede pescar y la temperatura 
           promedio del agua 
        ●  Una playa: tenemos la diferencia promedio de marea baja y alta 
        ●  Una excursión: sabemos su nombre 

    Agregue hechos a la base de conocimientos de ejemplo para dejar en claro cómo modelaría las 
    atracciones. Por ejemplo: Esquel tiene como atracciones un parque nacional (Los Alerces) y dos excursiones 
    (Trochita y Trevelin). Villa Pehuenia tiene como atracciones un cerro (Batea Mahuida de 2.000 m) y dos cuerpos 
    de agua (Moquehue, donde se puede pescar y tiene 14 grados de temperatura promedio y Aluminé, donde se 
    puede pescar y tiene 19 grados de temperatura promedio). 
*/

% atraccion\2 (Lugar, Atraccion) - Atraccion es un functor.
atraccion(esquel, parqueNacional(losAlerces)).
atraccion(esquel, excursion(trochita)).
atraccion(esquel, excursion(trevelin)).
atraccion(pehuenia, cerro(bateaMahuida, 2000)).
atraccion(pehuenia, cuerpoDeAgua(moquehue, puedePescar, 14)).
atraccion(pehuenia, cuerpoDeAgua(alumine, puedePescar, 19)).

/*
    Queremos saber qué vacaciones fueron copadas para una persona. Esto ocurre cuando todos los lugares a 
    visitar tienen por lo menos una atracción copada.  
        ●  un cerro es copado si tiene más de 2000 metros 
        ●  un cuerpoAgua es copado si se puede pescar o la temperatura es mayor a 20 
        ●  una playa es copada si la diferencia de mareas es menor a 5 
        ●  una excursión que tenga más de 7 letras es copado 
        ●  cualquier parque nacional es copado 
    El predicado debe ser inversible. 
*/

tuvoVacionesCopadas(Persona) :-
    viaja(Persona, _),
    forall(viaja(Persona, Destino), hayUnaAtraccionCopada(Destino)).

hayUnaAtraccionCopada(Destino) :-
    atraccion(Destino, Atraccion),
    esAtraccionCopada(Atraccion).

% Un cerro es copado si tiene más de 2000 metros 
esAtraccionCopada(cerro(_, Altura)) :-
    Altura > 2000.

% Un cuerpoAgua es copado si se puede pescar o la temperatura es mayor a 20 
esAtraccionCopada(cuerpoDeAgua(_ ,puedePescar, _)).

esAtraccionCopada(cuerpoDeAgua(_, _, Temperatura)) :-
    Temperatura > 20.

% Una playa es copada si la diferencia de mareas es menor a 5 
esAtraccionCopada(playa(DiferenciaMareas)) :-
    DiferenciaMareas < 5.

% Una excursión que tenga más de 7 letras es copado.
esAtraccionCopada(excursion(Nombre)) :-
    atom_length(Nombre, Longitud),
    Longitud > 7.

% Cualquier parque nacional es copado.
esAtraccionCopada(parqueNacional(_)).

/*
    ==========================================
                    PUNTO 3
    ==========================================

    Cuando dos personas distintas no coinciden en ningún lugar como destino decimos que no se cruzaron. Por 
    ejemplo, Dodain no se cruzó con Nico ni con Vale (sí con Alf en San Martín de los Andes). Vale no se cruzó con 
    Dodain ni con Nico (sí con Alf en El Bolsón). El predicado debe ser completamente inversible. 
*/

noSeCruzaron(Persona, OtraPersona) :-
    viaja(Persona, _),
    viaja(OtraPersona, _),
    Persona \= OtraPersona,
    not(seCruzaron(Persona, OtraPersona)).

seCruzaron(Persona, OtraPersona) :-
    viaja(Persona, Destino),
    viaja(OtraPersona, Destino).

/*
    ==========================================
                    PUNTO 4
    ==========================================

    Incorporamos el costo de vida de cada destino: 
            Destino             | Costo de vida 
        Sarmiento               |   100 
        Esquel                  |   150 
        Pehuenia                |   180 
        San Martín de los Andes |   150 
        Camarones               |   135          
        Playas Doradas          |   170     
        Bariloche               |   140          
        El Calafate             |   240        
        El Bolsón               |   145 
        Mar del Plata           |   140 
    Queremos saber si unas vacaciones fueron gasoleras para una persona. Esto ocurre si todos los destinos son 
    gasoleros, es decir, tienen un costo de vida menor a 160. Alf, Nico y Martu hicieron vacaciones gasoleras. 
    El predicado debe ser inversible. 
*/

% costoVida(Lugar, Costo).
costoVida(sarmiento, 100).
costoVida(esquel, 150).
costoVida(pehuenia, 180).
costoVida(sanMartinDeLosAndes, 150).
costoVida(camarones, 135).
costoVida(playasDoradas, 170).
costoVida(bariloche, 140).
costoVida(elCalafate, 240).
costoVida(elBolson, 145).
costoVida(marDelPlata, 140).

fueronGasoleras(Persona) :-
    viaja(Persona, _),
    forall(viaja(Persona, Destino), sonGasoleros(Destino)).

sonGasoleros(Destino) :-
    costoVida(Destino, Costo),
    Costo < 160.

/*
    ==========================================
                    PUNTO 5
    ==========================================

    Queremos conocer todas las formas de armar el itinerario de un viaje para una persona sin importar el 
    recorrido. Para eso todos los destinos tienen que aparecer en la solución (no pueden quedar destinos sin 
    visitar). 
 
    Por ejemplo, para Alf las opciones son 
    [bariloche, sanMartin, elBolson] 
    [bariloche, elBolson, sanMartin] 
    [sanMartin, bariloche, elBolson] 
    [sanMartin, elBolson, bariloche] 
    [elBolson, bariloche, sanMartin] 
    [elBolson, sanMartin, bariloche] 
 
    (claramente no es lo mismo ir primero a El Bolsón y después a Bariloche que primero a Bariloche y luego a El 
    Bolsón, pero el itinerario tiene que incluir los 3 destinos a los que quiere ir Alf).
*/

itinerario(Persona, Recorrido) :-
    viaja(Persona, _),
    destinosDe(Persona, Destinos),
    permutation(Destinos, Recorrido).

destinosDe(Persona, Destinos) :-
    findall(Destino, viaja(Persona, Destino), Destinos).

/*
    =========================================
    OTRA FORMA
    =========================================
    permutacion([],[]).
    permutacion(Lista, [Elem | OtraLista ]) :-
        eliminar(Elem, Lista, Resto),
        permutacion(Resto, OtraLista).

    eliminar(Elem, [Elem | Resto], Resto).

    eliminar(Elem, [OtroElem | Lista], [OtroElem | Resto]) :-
        eliminar(Elem, Lista, Resto).
*/
