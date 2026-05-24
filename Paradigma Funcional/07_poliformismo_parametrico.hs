{- 
  Clase: 21/05/2026 - Funcional VII
  Temas: 
    - Polimorfismo Paramétrico vs. Polimorfismo Ad-hoc (Typeclasses)
    - Restricciones de Contexto (Context Constraints)
    - Typeclasses nativas esenciales: Num, Eq, Ord, Show
    - Implementación de funciones genéricas con recursividad pura
-}

-----------------------------------------------------------
-- 1. POLIMORFISMO PARAMÉTRICO VS AD-HOC (CONCEPTOS CLAVE)
-----------------------------------------------------------

-- De acuerdo con la teoría de Uqbar, existen dos formas en que una función puede ser polimórfica:
--
-- A) POLIMORFISMO PARAMÉTRICO (Puro): 
-- La función ejecuta EXACTAMENTE LA MISMA LÓGICA para cualquier tipo de dato, sin importarle qué es.
-- No requiere conocer ninguna propiedad del tipo. Se representa con variables de tipo libres (a, b, c).
-- Ejemplo clásico: La función Identidad 'id' o la extracción de cabezas 'head'.

id :: a -> a
id x = x

-- Evaluaciones en GHCi para analizar cómo se ligan los tipos paramétricos:
-- > :t id 'b'   -> id 'b' :: Char
-- > :t id True  -> id True :: Bool
-- > :t id id    -> id id :: a -> a
-- > :t id not   -> id not :: Bool -> Bool
-- > :t head     -> head :: [a] -> a

-- B) POLIMORFISMO AD-HOC (Sobrecarga / Typeclasses):
-- La función puede aceptar diferentes tipos de datos, pero la lógica interna depende del tipo concreto.
-- Para que funcione, el tipo debe pertenecer a un "Typeclass" (una interfaz que asegura que el tipo 
-- sabe responder a ciertas operaciones, como sumar, comparar o mostrarse como string).


-----------------------------------------------------------
-- 2. TYPECLASSES Y RESTRICCIONES DE CONTEXTO
-----------------------------------------------------------

-- El símbolo '=>' define una RESTRICCIÓN DE CONTEXTO. Limita las variables de tipo libres 
-- únicamente a los tipos que implementan las funciones definidas por dicha Typeclass.

-- ========================================================
-- TYPECLASS: Num (Numéricos)
-- Op. provistas: (+), (-), (*), abs, signum
-- Tipos comunes: Int, Integer, Float, Double
-- ========================================================

-- (*) Ejercicio: Realizar la función 'sumatoria' empleando el Typeclass Num,
-- que suma todas las variables de una lista, devolviendo el valor total.

sumatoria :: (Num a) => [a] -> a
sumatoria []     = 0
sumatoria (x:xs) = x + sumatoria xs

-- ========================================================
-- TYPECLASS: Eq (Equiparables / Comparables por igualdad)
-- Op. provistas: (==), (/=)
-- Tipos comunes: Int, Integer, Float, Double, String, Char, Bool, listas y tuplas
-- ========================================================

-- (*) Ejercicio: Realizar la función 'elem' empleando el Typeclass Eq,
-- que recibe un elemento, una lista del mismo tipo y verifica si se encuentra en ella.

elem' :: (Eq b) => b -> [b] -> Bool
elem' _ []     = False
elem' x (y:ys) = x == y || elem' x ys

-- ========================================================
-- TYPECLASS: Ord (Ordenables)
-- Op. provistas: (>=), (>), (<=), (<), max, min, compare
-- Tipos comunes: Int, Integer, Float, Double, String, Char, Bool (Los que tienen un orden lógico)
-- ========================================================

-- (*) Ejercicio: Realizar la función 'maximo' con el Typeclass Ord,
-- que recibe una lista de elementos y devuelve su valor máximo.

maximo :: (Ord a) => [a] -> a
maximo [x]    = x
maximo (x:xs) = x `max` maximo xs

-- Nota: La función nativa 'max' del Prelude también utiliza este Typeclass:
-- max :: (Ord a) => a -> a -> a
-- max x y | x > y     = x
--         | otherwise = y

-- ========================================================
-- TYPECLASS: Show (Imprimibles)
-- Op. provistas: show (Convierte el tipo de dato a String)
-- Uso común: Se agrega mediante 'deriving (Show)' en nuestros data propios 
-- para permitir que GHCi pueda renderizarlos e imprimirlos en la consola.
-- ========================================================

{- HLINT ignore "Use list literal" -}
{- HLINT ignore "Eta reduce" -}
{- HLINT ignore "Use foldr" -}
