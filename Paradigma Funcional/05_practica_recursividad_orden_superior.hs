-----------------------------------------------------------
--  Ejercicios: Recursividad
-----------------------------------------------------------

-- MODELADO DE DATOS: EJERCICIO 1

data Flor = Flor {
    nombreFlor        :: String, 
    aplicacion        :: String, 
    cantidadDeDemanda :: Int
} deriving Show

-- Instancias base para pruebas en consola:
rosa     = Flor "rosa" "decorativo" 120
jazmin   = Flor "jazmin" "aromatizante" 100
violeta  = Flor "violeta" "infusión" 110
orquidea = Flor "orquidea" "decorativo" 90

flores = [orquidea, rosa, violeta, jazmin]

{-
    - 1.a) Definir maximaFlorSegun que permite conocer el nombre de la flor que es 
           máxima según estos criterios:
           - La cantidad demandada
           - La cantidad de letras de la flor
           - El resto de la división de la cantidad demandada por 4
           
           REQUERIMIENTO: Resolverla evitando tener código duplicado y usando recursividad.
-}

{-
    - 1.b) Dada una lista de flores determinar si están ordenadas de mayor a menor por 
           cantidad de demanda.
-}

{-
    - 2) Dada una lista de tuplas, sacar la cantidad de elementos utilizando foldl y foldr.
         
         > cantidadDeElementos [(8,6), (5,5), (5,6), (7,8)]
         > 4
-}

{-
    - 3) Dada una lista de pares (empleado, gasto), conocer el empleado más gastador 
         usando foldl y foldr.
         
         > masGastador [("ana", 8000), ("pepe", 4000), ("juan", 30000), ("maria", 12000)]
         > ("juan", 30000)
-}

{-
    - 4) Dada una lista de (empleado, gasto), conocer el gasto total usando foldl y foldr.
         
         > monto [("ana", 800), ("pepe", 400), ("juan", 3000), ("maria", 1200)]
         > 5400
-}

{-
    - 5) Completar con lo que corresponda para (no hace falta definir funciones auxiliares):
         
         > foldl .... 2 [(3+), (*2), (5+)]
         > 15
         
         > foldr .... 2 [(3+), (*2), (5+)]
         > 17
         
         NOTA: Pensar qué hace cada función de la lista sobre el acumulador según el orden de plegado.
-}

-- MODELADO DE DATOS: EJERCICIO 6 

type Nombre = String
type InversionInicial = Int
type Profesionales = [String]

data Proyecto = Proy {
    nombre           :: Nombre, 
    inversionInicial :: InversionInicial, 
    profesionales    :: Profesionales
} deriving Show

-- Instancias base para pruebas en consola:
proyectos = [
    Proy "red social de arte" 200000 ["ing. en sistemas", "contador"],
    Proy "restaurante"         50000 ["cocinero", "adm. de empresas", "contador"],
    Proy "ventaChurros"        10000 ["cocinero"]
  ]

{-
    - 6) Determine una función que permita conocer el máximo proyecto según los siguientes criterios.
         Resolverlo usando foldl y foldr de forma separada.
         
         Criterios a desarrollar:
         a) La inversión inicial
         b) El nro de profesionales
         c) La cantidad de palabras del proyecto
         
         REQUERIMIENTO: Mostrar por cada caso ejemplos de invocación y respuesta en el .txt.
-}
