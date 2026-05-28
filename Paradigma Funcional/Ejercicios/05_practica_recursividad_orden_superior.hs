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

-- función criterio de firma (Flor -> Int) 
-- Recibe un Flor
-- Retorna un Int porque para los 3 casos retorna un entero: CantidadDemandada, Letras, CantidadDemandadaSobre4

-- De la 'flores' recibida de 'maximaFlorSegun', obtengo la flor maxima según el critero:
maximaFlor :: (Flor -> Int) -> [Flor] -> Flor
maximaFlor _ [flor] = flor -- Caso base donde hay un solo elemento en la lista
maximaFlor f (flor : flores) | f flor >= (f . maximaFlor f) flores = flor -- Caso donde la cabeza sea mayor que el resto de la lista 
                             | otherwise = maximaFlor f flores -- Caso donde el máximo esté en el resto de la lista

-- A esa flor devuelta por 'maximaFlor', le saco el nombre, ya que es la designada:
maximaFlorSegun :: (Flor -> Int) -> [Flor] -> String
maximaFlorSegun f flores = (nombreFlor . maximaFlor f) flores

{-
    - 1.b) Dada una lista de flores determinar si están ordenadas de mayor a menor por 
           cantidad de demanda.
-}

estanOrdenadas :: [Flor] -> Bool
estanOrdenadas [] = True -- Caso base: Lista vacía
estanOrdenadas [_] = True -- Caso 1: Lista con un elemento
estanOrdenadas (flor1 : flor2 : flores) = 
    cantidadDeDemanda flor1 >= cantidadDeDemanda flor2 && estanOrdenadas flores -- Caso 2: Compara todos los elementos 

{-
    - 2) Dada una lista de tuplas, sacar la cantidad de elementos utilizando foldl y foldr.
         
         > cantidadDeElementos [(8,6), (5,5), (5,6), (7,8)]
         > 4
-}

{-
    foldl espera (acumulador → elemento → resultado)
    foldr espera (elemento → acumulador → resultado)
-}

contar :: Int -> (Int , Int) -> Int
contar semilla _ = semilla + 1

cantidadDeElementos :: [(Int, Int)] -> Int
cantidadDeElementos lista = foldl contar 0 lista

contar' :: (Int , Int) -> Int -> Int
contar' _ semilla = semilla + 1

-- cantidadDeElementos con foldr
cantidadDeElementos' :: [(Int, Int)] -> Int
cantidadDeElementos' lista = foldr contar' 0 lista

-- MODELADO DE DATOS: EJERCICIO 3
type Empleado = (String, Integer)

{-
    - 3) Dada una lista de pares (empleado, gasto), conocer el empleado más gastador 
         usando foldl y foldr.
         
         > masGastador [("ana", 8000), ("pepe", 4000), ("juan", 30000), ("maria", 12000)]
         > ("juan", 30000)
-}
empleados = [("ana", 8000), ("pepe", 4000), ("juan", 30000), ("maria", 12000)]

masGasto :: Empleado -> Empleado -> Empleado
masGasto emp1 emp2 
    | snd emp1 >= snd emp2 = emp1 
    | otherwise = emp2

masGastador :: [Empleado] -> Empleado
masGastador (empleado : empleados) = foldl masGasto empleado empleados

masGastador' :: [Empleado] -> Empleado
masGastador' (empleado: empleados) = foldr masGasto empleado empleados

{-
    - 4) Dada una lista de (empleado, gasto), conocer el gasto total usando foldl y foldr.
         
         > monto [("ana", 800), ("pepe", 400), ("juan", 3000), ("maria", 1200)]
         > 5400
-}

empleados2 = [("ana", 800), ("pepe", 400), ("juan", 3000), ("maria", 1200)]

sumarGasto :: Integer -> Empleado -> Integer
sumarGasto semilla emp = semilla + snd emp

monto :: [Empleado] -> Integer
monto empleados = foldl sumarGasto 0 empleados

sumarGasto' :: Empleado -> Integer -> Integer
sumarGasto' emp semilla = semilla + snd emp

monto' :: [Empleado] -> Integer
monto' empleados = foldr sumarGasto' 0 empleados

{-
    - 5) Completar con lo que corresponda para (no hace falta definir funciones auxiliares):
         
         > foldl (\ x f -> f x) 2 [(3+), (*2), (5+)]
         > 15
         
         > foldr (\ f x -> f x) 2 [(3+), (*2), (5+)]
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
nroDeProfesionales :: Proyecto -> Int
nroDeProfesionales proy = foldl (\x _ -> x + 1) 0 (profesionales proy)

cantPalabrasProyecto :: Proyecto -> Int
cantPalabrasProyecto proy = (length . words . nombre) proy

maxProy :: (Proyecto -> Int) -> Proyecto -> Proyecto -> Proyecto
maxProy f proy1 proy2 | f proy1 >= f proy2 = proy1
                      | otherwise = proy2 

maximoProyecto :: (Proyecto -> Int) -> [Proyecto] -> Proyecto
maximoProyecto f (proy : proys) = foldl (maxProy f) proy proys

maximoProyecto' :: (Proyecto -> Int) -> [Proyecto] -> Proyecto
maximoProyecto' f (proy : proys) = foldr (maxProy f) proy proys

{- HLINT ignore "Eta reduce" -}