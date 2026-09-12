% paquete/3 (NombrePaquete, PesoEnKg, ValorAsegurado)
paquete(heladera, 70, 800).
paquete(microondas, 15, 200).
paquete(televisor, 20, 600).
paquete(sillon, 50, 450).
paquete(computadora, 10, 700).
paquete(mesa, 30, 300).

cargaValida(CapacidadMaxima, MinimoPaquetes, Carga, GananciaTotal) :-
    % 1. Busco todos los paquetes disponibles y quito repetidos
    findall(Nombre, paquete(Nombre, _, _), ListaDePaquetes),
    list_to_set(ListaDePaquetes, PaquetesSinRepetir),

    % 2. Genero subconjuntos y valido tamaño mínimo temprano
    subconjunto(PaquetesSinRepetir, Carga),
    length(Carga, Cantidad),
    Cantidad >= MinimoPaquetes,

    % 3. Calculo y valido peso máximo
    pesoTotal(Carga, PesoTotal),
    CapacidadMaxima >= PesoTotal,

    % 4. Calculo ganancia total
    gananciaTotal(Carga, GananciaTotal).

% Generador de subconjuntos
subconjunto([], []).
subconjunto([Cabeza|Cola], [Cabeza|OtraListaCola]) :-
    subconjunto(Cola, OtraListaCola).
subconjunto([_|Cola], OtraLista) :-
    subconjunto(Cola, OtraLista).

pesoTotal(Carga, PesoTotal) :-
    findall(Peso, (member(Nombre, Carga), paquete(Nombre, Peso, _)), ListaPesos),
    sum_list(ListaPesos, PesoTotal).

gananciaTotal(Carga, GananciaTotal) :-
    findall(Valor, (member(Nombre, Carga), paquete(Nombre, _, Valor)), ListaValores),
    sum_list(ListaValores, GananciaTotal).