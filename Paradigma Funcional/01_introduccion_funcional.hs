{-
  Clase: 10/04/2026 - Funcional I
  Temas: 
    - Transparencia Referencial y Funciones Puras.
    - Guardas vs. Pattern Matching.
    - Manejo de Tuplas y Alias de Tipo.
    - Expresiones Lambda y Variables Anónimas (_).
-}

-----------------------------------------------------------
-- 1. EL PROBLEMA DE LA DUPLICACIÓN (Ejercicio calcular)
-----------------------------------------------------------

-- Funciones Auxiliares (Aumentan la expresividad)
doble :: Integer -> Integer
doble nro = nro * 2

siguiente :: Integer -> Integer
siguiente nro = nro + 1

-- Lógica individual con Guardas
duplicarSiEsPar :: Integer -> Integer
duplicarSiEsPar nro | even nro  = doble nro
                    | otherwise = nro

sumarSiEsImpar :: Integer -> Integer
sumarSiEsImpar nro | odd nro   = siguiente nro
                   | otherwise = nro

{-
    1) Definir la función calcular’, que recibe una tupla de 2 elementos, y devuelve una 
    nueva tupla según las siguientes reglas: 
        - Si el primer elemento es par lo duplica; si no lo deja como está 
        - Si el segundo elemento es impar le suma 1; si no deja como está
-}

-- Función Principal: Aplicamos transformación a una tupla
-- En funcional, no "cambiamos" la tupla, devolvemos una NUEVA.
calcular :: (Integer, Integer) -> (Integer, Integer)
calcular (nroA, nroB) = (duplicarSiEsPar nroA, sumarSiEsImpar nroB)

-----------------------------------------------------------
-- 2. LÓGICA BOOLEANA (Pattern Matching Avanzado)
-----------------------------------------------------------
-- Ejercicio 2.1: Formas de la definir 'and' segun su Declaratividad:

-- La mejor forma de definir 'and' es con Pattern Matching
-- (_ _) Pattern Matching, Declaratividad I	
andI :: Bool -> Bool -> Bool
andI True valor = valor -- Si el primero es True, el resultado depende del segundo
andI False _    = False -- Si el primero es False, el resultado es False (Short-circuit)

-- Declaratividad II
andII :: Bool -> Bool -> Bool
andII conditionA conditionB | 
      conditionA = conditionB | 
      otherwise = False

-- Declaratividad III												  
andIII :: Bool -> Bool -> Bool
andIII conditionA conditionB |  not conditionA = False | not conditionB = False | otherwise = True

-- Ejercicio 2.2: or' siguiendo la misma lógica
or' :: Bool -> Bool -> Bool
or' True _  = True
or' _  True = True
or' _  _    = False

-----------------------------------------------------------
-- 3. MODELADO DE DATOS (Ejercicio Alumno)
-----------------------------------------------------------

type Nota = Integer
type Alumno = (String, Nota, Nota, Nota) -- Sinónimo de tipo para legibilidad

-- notaMaxima sin guardas (Uso de funciones predefinidas de forma infija)
-- Corregido: Usamos los nombres de variables que declaramos en el matching.
notaMaxima :: Alumno -> Nota
notaMaxima (_, n1, n2, n3) = n1 `max` (n2 `max` n3)