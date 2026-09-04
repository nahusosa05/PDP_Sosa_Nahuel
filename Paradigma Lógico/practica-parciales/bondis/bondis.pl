% Recorridos en GBA: 
recorrido(17, gba(sur), mitre). 
recorrido(24, gba(sur), belgrano). 
recorrido(10, gba(oeste), 404).
recorrido(247, gba(sur), onsari). 
recorrido(60, gba(norte), maipu). 
recorrido(152, gba(norte), olivos). 
 
% Recorridos en CABA: 
recorrido(17, caba, santaFe). 
recorrido(152, caba, santaFe). 
recorrido(10, caba, santaFe). 
recorrido(160, caba, medrano). 
recorrido(24, caba, corrientes). 

/*
    Punto 1: Saber si dos líneas pueden combinarse, que se cumple cuando su recorrido pasa por una 
             misma calle dentro de la misma zona.
*/

% puedenCombinarse(17,152).
% NroBondi1 = 17 || NroBondi2 = 152
% -? true.

puedenCombinarse(NroBondi1, NroBondi2) :-
    recorrido(NroBondi1, Zona, Calle), 
    recorrido(NroBondi2, Zona, Calle).

/*
    Punto 2: Conocer cuál es la jurisdicción de una línea, que puede ser o bien nacional, que se cumple 
    cuando la misma cruza la General Paz, o bien provincial, cuando no la cruza. 
    Cuando la jurisdicción  es  provincial  nos  interesa  conocer  de  qué  provincia  se  trata,  si  es  de 
    buenosAires (cualquier parte de GBA se considera de esta provincia) o si es de caba. 
    
    Se considera que una línea cruza la General Paz cuando parte de su recorrido pasa por una 
    calle de CABA y otra parte por una calle del Gran Buenos Aires (sin importar de qué zona 
    se trate). 
*/

% Generador de líneas
linea(Linea) :-
    recorrido(Linea, _, _).

% Nacional
jurisdiccion(Linea, nacional) :-
    cruzaLaGralPaz(Linea).

% Provincial (buenosAires / caba).
jurisdiccion(Linea, provincial(Provincia)) :-
    linea(Linea),
    not(cruzaLaGralPaz(Linea)),
    provinciaDeLaLinea(Linea, Provincia).

provinciaDeLaLinea(Linea, buenosAires) :-
    recorrido(Linea, gba(_), _).

privinciaDeLaLinea(Linea, caba) :-
    recorrido(Linea, caba, _).

cruzaLaGralPaz(Linea) :-
    recorrido(Linea, caba, _),
    recorrido(Linea, gba(_), _).

/*
    Punto 3: Saber cuál es la calle más transitada de una zona, que es por la que pasen mayor cantidad 
    de líneas. 
*/

% calleMasTransitada(caba, Calle).
% Calle = santaFe.

calleMasTransitada(Zona, Calle) :-
    cantidadLineasDeLaCalle(Zona, Calle, CantidadMax),
    forall(
        cantidadLineasDeLaCalle(Zona, _, OtraCantidad), 
        CantidadMax >= OtraCantidad
    ).

cantidadLineasDeLaCalle(Zona, Calle, Cantidad) :-
    recorrido(_, Zona, Calle),
    findall(Linea, recorrido(Linea, Zona, Calle), ListaNroBondis), 
    length(ListaNroBondis, Cantidad). 

/*
    1. calleMasTransitada(caba, santaFe).
    2. cantidadLineasDeLaCalle(caba, santaFe, CantidadMax).
    3. recorrido(_, caba, santaFe),
    4. findall(Linea, recorrido(Linea, caba, santaFe), ListaNroBondis) || Pedis Linea -> recorrido(Linea, caba, santaFe) -> [17, 152, 10]
    5. length([17,152,10], CantidadMax) || CantidadMax = 3

    forall 1
    cantidadLineasDeLaCalle(caba, medrano, OtraCantidad)
    findall(Linea, recorrido(Linea, caba, medrano), ListaNroBondis) || Pedis Linea -> recorrido(Linea, caba, medrano) -> [160]
    length([160], OtraCantidad) || OtraCantidad = 3

    CantidadMax >= OtraCantidad || 3 >= 1 (TRUE)

    forall 2
    cantidadLineasDeLaCalle(caba, corrientes, OtraCantidad)
    findall(Linea, recorrido(Linea, caba, corrientes), ListaNroBondis) || Pedis Linea -> recorrido(Linea, caba, corrientes) -> [24]
    length([24], OtraCantidad) || OtraCantidad = 3

    CantidadMax >= OtraCantidad || 3 >= 1 (TRUE)
*/

/*
    Punto 4: Saber cuáles son las calles de transbordos en una zona, que son aquellas por las que pasan 
    al menos 3 líneas de colectivos, y todas son de jurisdicción nacional. 
*/

zona(caba).
zona(gba(sur)).
zona(gba(norte)).
zona(gba(oeste)).

transbordos(Zona, Calles) :-
    zona(Zona),
    findall(Calle, (recorrido(_, Zona, Calle), esCalleTransbordo(Zona, Calle)), CallesTransbordo),
    list_to_set(CallesTransbordo, Calles).
    
esCalleTransbordo(Zona, Calle) :-
    cantidadLineasDeLaCalle(Zona, Calle, Cantidad),
    Cantidad >= 3,
    forall(recorrido(Linea, Zona, Calle), jurisdiccion(Linea, nacional)).
    
/*
    Punto 5: Necesitamos  incorporar  a  la  base  de  conocimientos  cuáles  son  los  beneficios  que  las 
    personas tienen asociadas a sus tarjetas registradas en el sistema SUBE. Dichos beneficios 
    pueden ser cualquiera de los siguientes: 
    - Estudiantil: el boleto tiene un costo fijo de $50. 
    - Personal de casas particulares: nos interesará registrar para este beneficio cuál es la  zona  en  la 
            que  se  encuentra  el  domicilio  laboral.  Si  la  línea  que  se  toma  la persona  con este  
            beneficio  pasa  por  dicha  zona,  se  subsidia  el  valor  total  del boleto, por lo que no tiene costo. 
    - Jubilado: el boleto cuesta la mitad de su valor. 
*/