/*
    Punto 1: Punto 1: Pasos al costado  
    Les jockeys son personas que montan el caballo en la carrera: 
    - Valdivieso, que mide 155 cms y pesa 52 kilos. 
    - Leguisamo, que mide 161 cms y pesa 49 kilos. 
    - Lezcano, que mide 149 cms y pesa 50 kilos.
    - Baratucci, que mide 153 cms y pesa 55 kilos.
    - Falero, que mide 157 cms y pesa 52 kilos. 
*/

% jockeys(Nombre, Altura, Peso).
jockey(valdivieso, 155, 52).
jockey(leguisamo, 161, 49).
jockey(lezcano, 149, 50).
jockey(baratucci, 153, 55).
jockey(falero, 157, 52).

/*
    También tenemos a los caballos: Botafogo, Old Man, Enérgica, Mat Boy y Yatasto, entre 
    otros. Cada caballo tiene sus preferencias: 
        ●  a Botafogo le gusta que el jockey pese menos de 52 kilos o que sea Baratucci 
        ●  a Old Man le gusta que el  jockey sea alguna persona de muchas letras (más de 7), 
            existe el predicado atom_length/2 
        ●  a Enérgica le gustan todes los jockeys que no le gusten a Botafogo 
        ●  a Mat Boy le gusta los jockeys que midan más de 170 cms 
        ●  a Yatasto no le gusta ningún jockey
*/

caballo(botafogo).
caballo(oldMan).
caballo(energica).
caballo(matBoy).
caballo(yatasto).

% Botafogo
leGusta(botafogo, Nombre) :-
    jockey(Nombre, _, Peso),
    Peso < 52.

leGusta(botafogo, baratucci).

% Old Man
leGusta(oldMan, Nombre) :-
    jockey(Nombre, _, _),
    atom_length(Nombre, LongitudNombre),
    LongitudNombre > 7.

% Enérgica
leGusta(energica, Nombre) :-
    jockey(Nombre, _, _),
    not(leGusta(botafogo, Nombre)).

% Mat Boy
leGusta(matBoy, Nombre) :-
    jockey(Nombre, Altura, _),
    Altura > 170.

/*
    También sabemos el Stud o la caballeriza al que representa cada jockey 
        ●  Valdivieso y Falero son del stud El Tute 
        ●  Lezcano representa a Las Hormigas 
        ●  Y Baratucci y Leguisamo a El Charabón 
 
    Por otra parte, sabemos que Botafogo ganó el Gran Premio Nacional y el Gran Premio 
    República, Old Man ganó el Gran Premio República y el Campeonato Palermo de Oro y 
    Enérgica y Yatasto no ganaron ningún campeonato. Mat Boy ganó el Gran Premio Criadores. 
 
    Modelar estos hechos en la base de conocimientos e indicar en caso de ser necesario si 
    algún concepto interviene a la hora de hacer dicho diseño justificando su decisión. 
*/

% caballeriza(Nombre, Stub).
caballeriza(valdivieso, elTute).
caballeriza(falero, elTute).
caballeriza(lezcano, lasHormigas).
caballeriza(baratucci, elCharabon).
caballeriza(leguisamo, elCharabon).

% gano(Caballo, Premio).
gano(botafogo, granPremioNacional).
gano(botafogo, granPremioRepublica).
gano(oldMan, granPremioRepublica).
gano(oldMan, palermoDeOro).
gano(matBoy, premioCriadores).

/*
    Punto 2: Para mí, para vos 
    Queremos saber quiénes son los caballos que prefieren a más de un jockey. Ej: Botafogo, 
    Old Man y Enérgica son caballos que cumplen esta condición según la base de 
    conocimiento planteada. El predicado debe ser inversible.
*/

prefiereAMasDeUno(Caballo) :-
    leGusta(Caballo, UnJockey),
    leGusta(Caballo, OtroJockey),
    UnJockey \= OtroJockey.

/*
    NO HACE FALTA GENERAR LISTA AUXILIAR.
    prefiereAMasDeUno(Caballo) :-
        caballo(Caballo),
        jockeyPreferidos(Caballo, Cantidad),
        Cantidad > 1.

    jockeyPreferidos(Caballo, Cantidad) :-
        findall(Nombre, leGusta(Caballo, Nombre), Jockeys),
        length(Jockeys, Cantidad).
*/

/*
    Punto 3: Queremos saber quiénes son los caballos que no prefieren a ningún jockey de una 
    caballeriza. El predicado debe ser inversible. Ej: Botafogo aborrece a El Tute (porque no 
    prefiere a Valdivieso ni a Falero), Old Man aborrece a Las Hormigas y Mat Boy aborrece a 
    todos los studs, entre otros ejemplos.  
*/

stub(Stub) :-
    caballeriza(_, Stub).

aborrece(Caballo, Stub) :-
    caballo(Caballo),
    stub(Stub),
    not((caballeriza(NombreJockey, Stub), leGusta(Caballo, NombreJockey))).

/*
    Punto 4: Piolines 
    Queremos saber quiénes son les jockeys "piolines", que son las personas preferidas por 
    todos los caballos que ganaron un premio importante. El Gran Premio Nacional y el Gran 
    Premio República son premios importantes. 
 
    Por ejemplo, Leguisamo y Baratucci son piolines, no así Lezcano que es preferida por 
    Botafogo pero no por Old Man. El predicado debe ser inversible. 
*/

premioImportante(granPremioNacional).
premioImportante(granPremioRepublica).

esPiolin(NombreJockey) :- 
    jockey(NombreJockey, _, _),
    forall(ganoPremioImportante(Caballo), leGusta(Caballo, NombreJockey)).

ganoPremioImportante(Caballo) :-
    gano(Caballo, Premio),
    premioImportante(Premio).

/*
    Punto 5:
    Existen apuestas 
    ●  a ganador por un caballo => gana si el caballo resulta ganador 
    ●  a segundo por un caballo => gana si el caballo sale primero o segundo 
      exacta => apuesta por dos caballos, y gana si el primer caballo sale primero y el 
    segundo caballo sale segundo 
    ●  imperfecta => apuesta por dos caballos y gana si los caballos terminan primero y 
    segundo sin importar el orden 
 
    Queremos saber, dada una apuesta y el resultado de una carrera de caballos si la apuesta 
    resultó ganadora. No es necesario que el predicado sea inversible. 
*/
apuestaGanadora(ganador(Caballo), [Caballo | _]).

apuestaGanadora(segundoGanador(Caballo), [Caballo | _]).

apuestaGanadora(segundoGanador(Caballo), [_, Caballo | _]).

apuestaGanadora(exacta(Caballo, OtroCaballo), [Caballo, OtroCaballo | _]).

apuestaGanadora(imperfecta(Caballo, OtroCaballo), [Caballo, OtroCaballo | _]).

apuestaGanadora(imperfecta(Caballo, OtroCaballo), [OtroCaballo, Caballo | _]).

/*      
    Punto 6: Los colores 
    Sabiendo que cada caballo tiene un color de crin: 
        ●  Botafogo es tordo (negro) 
        ●  Old Man es alazán (marrón) 
        ●  Enérgica es ratonero (gris y negro) 
        ●  Mat Boy es palomino (marrón y blanco) 
        ●  Yatasto es pinto (blanco y marrón) 
    Queremos saber qué caballos podría comprar una persona que tiene preferencia por 
    caballos de un color específico. Tiene que poder comprar por lo menos un caballo para que 
    la solución sea válida. Ojo: no perder información que se da en el enunciado. 
    Por ejemplo: una persona que quiere comprar caballos marrones podría comprar a Old Man, 
    Mat Boy y Yatasto. O a Old Man y Mat Boy. O a Old Man y Yatasto. O a Old Man. O a Mat 
    Boy y Yatasto. O a Mat Boy. O a Yatasto.x 
*/

color(botafogo, negro).
color(oldMan, marron).
color(energica, gris).
color(energica, negro).
color(matBoy, marron).
color(matBoy, blanco).
color(yatasto, blanco).
color(yatasto, marron).

puedeComprar(Color, Caballos) :-
    caballosDisponibles(Color, TodosLosCaballos),
    subconjunto(TodosLosCaballos, Caballos), 
    Caballos \= [].

caballosDisponibles(Color, TodosLosCaballos) :-
    color(_, Color),
    findall(Caballo, color(Caballo, Color), TodosLosCaballos).

subconjunto([], []).
subconjunto([Caballo | Caballos], [Caballo | RestoCaballos]) :-
    subconjunto(Caballos, RestoCaballos).
subconjunto([_ | Caballos], ListaCaballos) :-
    subconjunto(Caballos, ListaCaballos).