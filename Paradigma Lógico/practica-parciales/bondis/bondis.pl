% Recorridos en GBA: 
recorrido(17, gba(sur), mitre). 
recorrido(17, gba(sur), calle2).
recorrido(17, gba(sur), calle3).  
recorrido(24, gba(sur), belgrano). 
recorrido(10, gba(oeste), 404).
recorrido(247, gba(sur), onsari). 
recorrido(60, gba(norte), maipu). 
recorrido(152, gba(norte), olivos). 
 
% Recorridos en CABA: 
%recorrido(17, caba, santaFe). 
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

provinciaDeLaLinea(Linea, caba) :-
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
    =======================================
                   Punto 5.a
    =======================================
    Incorporar a la base de conocimientos los beneficios asociados a las 
    tarjetas SUBE de las personas.

    Tipos de beneficios:
    - Estudiantil: costo fijo de $50.
    - Personal de casas particulares: registra la zona del domicilio laboral. 
      Si la línea pasa por dicha zona, se subsidia el valor total ($0).
    - Jubilado: el boleto cuesta la mitad de su valor original.

    Representar la información de los beneficios y beneficiarios.
*/

% tiene(Persona, Beneficio).
% Pepito tiene el beneficio de personal de casas particulares dentro de la zona oeste del GBA.
tiene(pepito, personalDeCasasParticulares(gba(oeste))).

% Juanita tiene el beneficio del boleto estudiantil.
tiene(juanita, estudiantil).

% Tito no tiene ningún beneficio. NO SE CODEA

% Marta tiene beneficio de jubilada y también de personal de casas particulares dentro de caba y en zona sur del GBA.
tiene(marta, jubilada).
tiene(marta, personalDeCasasParticulares(caba)).
tiene(marta, personalDeCasasParticulares(gba(sur))).

/*
    =======================================
                   Punto 5.b
    =======================================
    Saber, para una persona, cuánto le costaría viajar en una línea, considerando que:

    1. Valor normal del boleto (sin considerar beneficios):
       - $500: si la línea es de jurisdicción nacional.
       - $350: si es provincial de CABA.
       - Provincia de Buenos Aires: $25 multiplicado por la cantidad de calles 
         que tiene en su recorrido, más un plus de $50 si pasa por zonas diferentes 
         de la provincia.

    2. Beneficios aplicados:
       - La persona abona el valor correspondiente según sus beneficios.
       - En caso de contar con múltiples beneficios, abona el monto más bajo 
         (los descuentos no son acumulativos).

    Ejemplo:
       Para Marta, el boleto en una línea nacional que pasa por CABA es gratuito ($0) 
       por el beneficio de casas particulares. En cambio, en una línea provincial de 
       Buenos Aires que recorre zona norte y oeste únicamente, abona la mitad del 
       viaje normal: ($50 + $25 * cantidadDeCalles) / 2, por su condición de jubilada.
*/

/*
    El valor normal del boleto (o sea, sin considerar beneficios) es de $500 si la 
    línea es de jurisdicción nacional y de $350 si es provincial de CABA. 
*/

valorNormal(Linea, 500):-
    jurisdiccion(Linea, nacional).

valorNormal(Linea, 350):-
    jurisdiccion(Linea, provincial(caba)).

/*
    En caso de ser de jurisdicción de la provincia de Buenos Aires, cuesta $25 
    multiplicado por la cantidad de calles que tiene en su recorrido mas un plus
    de $50 si pasa por zonas diferentes de la provincia. 
*/

valorNormal(Linea, Valor) :-
    jurisdiccion(Linea, provincial(buenosAires)),
    cantidadCalles(Linea, CantidadCalles), % cantidadCalles(15, CantidadCalles).
    plusZonasDiferentes(Linea, Plus),
    Valor is (25 * CantidadCalles) + Plus.

cantidadCalles(Linea, Cantidad) :-
    findall(Calle, recorrido(Linea, _, Calle), Calles), % 15 [santaFe, medrano, rivadavia, santaFe]
    list_to_set(Calles, CallesSinRepetidos),            % 15 [santaFe, medrano, rivadavia]
    length(CallesSinRepetidos, Cantidad).   % length([santaFe, medrano, rivadavia], 3).
    
pasaPorZonasDiferentes(Linea) :-
    recorrido(Linea, gba(Zona1), _),
    recorrido(Linea, gba(Zona2), _),
    Zona1 \= Zona2.

plusZonasDiferentes(Linea, 50) :-
    pasaPorZonasDiferentes(Linea).

plusZonasDiferentes(Linea, 0) :-
    linea(Linea),
    not(pasaPorZonasDiferentes(Linea)).

/*
    La  persona  debería abonar el valor que corresponda dependiendo de los 
    beneficios  que  tenga.  En  caso  de tener más de un beneficio, el monto a 
    abonar debería ser el más bajo (los descuentos no son acumulativos). 
*/

% Si tiene beneficio SUBE.
calcularCosto(Persona, Linea, Costo) :-
    tiene(Persona, Beneficio),
    valorNormal(Linea, ValorNormal),
    valorConBeneficio(Beneficio, Linea, ValorNormal, Costo).

% No tiene beneficio SUBE.
calcularCosto(Persona, Linea, ValorNormal) :-
    persona(Persona),
    valorNormal(Linea, ValorNormal).

persona(tito).
persona(pepito).
persona(marta).
persona(juanita).

valorConBeneficio(estudiantil, _, _, 50).

valorConBeneficio(jubilada, _, ValorNormal, Costo) :-
    Costo is ValorNormal / 2.

valorConBeneficio(personalDeCasasParticulares(ZonaLaboral), Linea, _, 0) :-
    recorrido(Linea, ZonaLaboral, _).

cuantoPaga(Persona, Linea, MontoMinimo) :-
    calcularCosto(Persona, Linea, MontoMinimo),
    forall(
      calcularCosto(Persona, Linea, OtrosMontos),
      MontoMinimo =< OtrosMontos  
    ).
    