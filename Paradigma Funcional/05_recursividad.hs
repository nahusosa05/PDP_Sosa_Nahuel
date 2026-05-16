{- 
  Clase: 08/05/2026 - Funcional V
  Temas: 
    - Recursividad pura sobre listas (Concepto de inducción, Caso Base y Caso Inductivo)
    - Pattern Matching estructural con el constructor Cons (x:xs)
    - Plegados de listas: Funciones de Orden Superior (foldl, foldr, foldl1, foldr1)
-}

-----------------------------------------------------------
-- 1. RECURSIVIDAD EN HASKELL: MECANISMO DE FIN DE PATRÓN
-----------------------------------------------------------

-- La recursividad emula el principio matemático de inducción.
-- Toda función recursiva sobre listas requiere:
--   1. CASO BASE: Detiene la ejecución (generalmente la lista vacía []).
--   2. CASO INDUCTIVO: Procesa la cabeza (x) y delega recursivamente el resto (xs).

-- Estructura del desarmado (x:xs): 
-- 'x' representa la cabeza (un elemento individual).
-- 'xs' representa la cola (el plural: una lista con los elementos restantes).

sumarElementos :: [Int] -> Int
sumarElementos []     = 0                   -- Caso base: rebota en el neutro de la suma
sumarElementos (x:xs) = x + sumarElementos xs -- Caso inductivo

multiplicarElementos :: [Int] -> Int
multiplicarElementos []     = 1                 -- Caso base: neutro de la multiplicación
multiplicarElementos (x:xs) = x * multiplicarElementos xs

longitud :: [a] -> Int
longitud []     = 0
longitud (_:xs) = 1 + longitud xs           -- Usamos '_' porque la cabeza no nos interesa para contar

-----------------------------------------------------------
-- 2. FUNCIONES DE ORDEN SUPERIOR DEFINIDAS CON RECURSIVIDAD
-----------------------------------------------------------

-- Las funciones nativas del Prelude (map, filter, all, any) están implementadas así internamente:

miMap :: (a -> b) -> [a] -> [b]
miMap _ []     = []
miMap f (x:xs) = f x : miMap f xs

miFilter :: (a -> Bool) -> [a] -> [a]
miFilter _ []     = []
miFilter f (x:xs) | f x       = x : miFilter f xs
                  | otherwise = miFilter f xs

miAll :: (a -> Bool) -> [a] -> Bool
miAll _ []     = True                       -- Por definición lógica, el vacío cumple todo
miAll f (x:xs) = f x && miAll f xs

-----------------------------------------------------------
-- 3. EL PODER DE FOLD (PLEGADOS / REDUCCIÓN)
-----------------------------------------------------------

-- Fold es una abstracción de orden superior que evita escribir recursividad manual.
-- Su objetivo es reducir una lista completa a un único valor consolidado.

-- A) foldl (Fold Left): Procesa de izquierda a derecha.
-- Es recursión de cola (acumulador). Va arrastrando el estado desde el inicio.
-- Firma: (acumulador -> elemento -> acumulador) -> semilla -> lista -> resultado
restarConFoldl :: Int -> [Int] -> Int
restarConFoldl semilla numeros = foldl (-) semilla numeros
-- Invocación: foldl (-) 10 [1, 2, 3] -> ((10 - 1) - 2) - 3 = 4

-- B) foldr (Fold Right): Procesa de derecha a izquierda.
-- Trabaja de forma asociativa hacia la derecha. Fundamental para la evaluación diferida.
-- Firma: (elemento -> acumulador -> acumulador) -> semilla -> lista -> resultado
restarConFoldr :: Int -> [Int] -> Int
restarConFoldr semilla numeros = foldr (-) semilla numeros
-- Invocación: foldr (-) 10 [1, 2, 3] -> 1 - (2 - (3 - 10)) = -8

-- C) foldl1 / foldr1: Variantes sin semilla inicial.
-- Toman automáticamente el primer (o último) elemento de la lista como el valor inicial.
-- ¡OJO! Explotan con excepciones si la lista está vacía ([]).
sumarConFoldl1 :: [Int] -> Int
sumarConFoldl1 = foldl1 (+)

encontrarMaximo :: [Int] -> Int
encontrarMaximo = foldl1 max

{- HLINT ignore "Use list literal" -}
{- HLINT ignore "Eta reduce" -}
{- HLINT ignore "Use maximum" -}
{- HLINT ignore "Use sum" -}
{- HLINT ignore "Use foldr" -}