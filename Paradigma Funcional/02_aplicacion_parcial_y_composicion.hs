{-
  Clase: 17/04/2026 - Funcional II
  Temas: 
    - Aplicación Parcial
    - Composición
    - Data Types 
    - Pattern Matching
-}

import Text.Show.Functions ()
-- Librería de Haskell que sirve para ver la instancias de las funciones

-----------------------------------------------------------
-- 1. MATEMÁTICA Y CURRIFICACIÓN
-----------------------------------------------------------

-- Función currificada (Permite aplicación parcial)
suma :: Integer -> Integer -> Integer
suma x y = x + y

-- Función NO currificada (Usa tuplas, no permite parcialidad directa)
sumaTupla :: (Integer, Integer) -> Integer
sumaTupla (x, y) = x + y

-- Ejemplos de Aplicación Parcial
sumaSiete :: Integer -> Integer
sumaSiete = suma 7 -- Generamos una nueva función fijando el primer argumento

-- FORMA EXPLÍCITA (Mencionando el argumento)
-- Pensamiento: "Defino una función 'sumaSiete' que recibe un 'n' y le suma 7"
sumaSieteExp :: Integer -> Integer
sumaSieteExp nroIngresadoPorConsola = suma 7 nroIngresadoPorConsola

-- FORMA CON APLICACIÓN PARCIAL (Point-free)
-- Pensamiento: "La función 'sumaSiete' ES la función 'suma' con un 7 ya puesto"
sumaSieteEjemplo = suma 7
-- Ambas funciones suman 7 al número ingresado por consola mediante aplicación parcial.
--   Equivale a aplicar 'suma' con el valor fijo 7.


-----------------------------------------------------------
-- 2. COMPOSICIÓN DE FUNCIONES
-----------------------------------------------------------

doble :: Integer -> Integer
doble = (* 2) -- Point-free usando aplicación parcial de un operador

siguiente :: Integer -> Integer
siguiente = (+ 1)

-- Composición pura: El resultado de doble entra en siguiente
siguienteDelDoble :: Integer -> Integer
siguienteDelDoble = siguiente . doble 

-- Composición con lógica booleana
esParSiguiente :: Integer -> Bool
esParSiguiente = even . siguiente 

-----------------------------------------------------------
-- 3. MODELADO CON DATA TYPES (TIPOS ALGEBRAICOS)
-----------------------------------------------------------

data Figura = Circulo { radio :: Double } 
            | Rectangulo { base :: Double, altura :: Double } 

area :: Figura -> Double
area (Circulo r) = pi * r^2
area (Rectangulo b h) = b * h -- Pattern matching sobre los campos del data

{- HLINT ignore "Use list literal" -}
{- HLINT ignore "Eta reduce" -}
{- HLINT ignore "Use maximum" -}
{- HLINT ignore "Use sum" -}
{- HLINT ignore "Use foldr" -}