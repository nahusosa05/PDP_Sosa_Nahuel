/* ============================================================================
   Clase: 03/07/2026 - Lógico III
   Temas: Recursividad sobre Grafos/Estructuras, Caso Base y Caso Inductivo,
          Garantía de Inversibilidad, Explosión Combinatoria (EC) y Prevención
          de Bucles Infinitos.
   ============================================================================ */

% -----------------------------------------------------------------------------
% 1. RECURSIVIDAD EN LÓGICO: CASO BASE Y CASO INDUCTIVO
% -----------------------------------------------------------------------------

/*
   A diferencia de la programación imperativa o funcional, en Lógico la 
   recursividad se expresa definiendo MÚLTIPLES CLÁUSULAS (Disyunción) para un 
   mismo predicado.

   Estructura obligatoria:
   1. Caso Base: Incondicional (Hecho) o regla simple que detiene el árbol de búsqueda.
   2. Caso Inductivo: Regla que realiza un paso y se llama a sí misma con un subproblema.
*/

% Grafo de conexiones directas entre ciudades
conectado(buenosAires, rosario).
conectado(rosario, cordoba).
conectado(cordoba, tucuman).
conectado(tucuman, salta).

% Predicado recursivo: esLlegable/2
% Determina si se puede viajar desde Origen hasta Destino pasando por N ciudades.

% CASO BASE: Hay una conexión directa entre Origen y Destino.
esLlegable(Origen, Destino) :-
    conectado(Origen, Destino).

% CASO INDUCTIVO: Puedo llegar de Origen a Destino si existe una ciudad Intermedia
% conectada con Origen, y desde esa Intermedia puedo llegar a Destino.
esLlegable(Origen, Destino) :-
    conectado(Origen, Intermedia),      % Paso de avance (Liga Intermedia)
    esLlegable(Intermedia, Destino).    % Llamada recursiva


% -----------------------------------------------------------------------------
% 2. INVERSIBILIDAD EN PREDICADOS RECURSIVOS
% -----------------------------------------------------------------------------

/*
   Para que un predicado recursivo sea totalmente inversible y admita consultas 
   existenciales (ej: `?- esLlegable(buenosAires, Donde).` o `?- esLlegable(X, Y).`), 
   el paso de avance (el hecho o predicado generador) DEBE ir ANTES de la 
   llamada recursiva.

   Si ponemos la llamada recursiva primero, Prolog caerá en un bucle infinito 
   (Stack Overflow) al consultar con variables libres.
*/


% -----------------------------------------------------------------------------
% 3. EXPLOSIÓN COMBINATORIA (EC)
% -----------------------------------------------------------------------------

/*
   ¿Qué es la Explosión Combinatoria?
   Es un problema de rendimiento algorítmico que ocurre cuando el motor de Prolog
   debe evaluar un espacio de soluciones que crece de forma EXPONENCIAL (O(2^N) o peor)
   debido a combinaciones de reglas recursivas o disyunciones mal acotadas.

   Causas comunes de Explosión Combinatoria:
   1. Falta de generadores de dominio que acoten el universo antes de permutar.
   2. Grafos con ciclos sin control de visitados (ej: A conectado con B, y B con A).
   3. Múltiples llamadas recursivas dentro de la misma regla (ej: Fibonacci ingenuo).
*/

% Ejemplo de Generación y Permutación riesgosa (Posible EC si el dominio crece):
combinacionPosible(X, Y, Z) :-
    numero(X),
    numero(Y),
    numero(Z),
    X + Y + Z =:= 15.

numero(N) :- between(1, 50, N).

/*
   En la regla anterior, Prolog evalúa 50 * 50 * 50 = 125.000 combinaciones posibles.
   Si el rango fuera de 1 a 1000, serían 1.000.000.000 de evaluaciones (Explosión Combinatoria).
*/


% -----------------------------------------------------------------------------
% 4. PREVENCIÓN DE BUCLAE INFINITO EN GRAFOS CICLICOS
% -----------------------------------------------------------------------------

/*
   Si el grafo es bidireccional o tiene ciclos (ej: A -> B y B -> A), 'esLlegable/2'
   entrará en un bucle infinito. 

   Solución: Llevar una lista de nodos "Visitados" (Individuo Compuesto/Lista).
*/

camino(Origen, Destino) :-
    caminoAuxiliar(Origen, Destino, [Origen]).

% Caso Base: Conexión directa
caminoAuxiliar(Origen, Destino, _) :-
    conectado(Origen, Destino).

% Caso Inductivo con control de ciclos (Evita el bucle e hiper-recursión)
caminoAuxiliar(Origen, Destino, Visitados) :-
    conectado(Origen, Intermedia),
    not(member(Intermedia, Visitados)),            % Control de Ciclos
    caminoAuxiliar(Intermedia, Destino, [Intermedia | Visitados]).