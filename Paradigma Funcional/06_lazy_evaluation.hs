{- 
  Clase: 15/05/2026 - Funcional VI
  Temas: 
    - Lazy Evaluation (Evaluación Diferida / Perezosa)
    - Estrategias de Reducción: Call-by-value vs Call-by-name
    - Listas Infinitas y estructuras conceptuales sin fin
    - Optimización por descarte de ramas no evaluadas
-}

-----------------------------------------------------------
-- 1. LAZY EVALUATION (EVALUACIÓN DIFERIDA)
-----------------------------------------------------------

-- Haskell NO evalúa los argumentos de una función hasta que su resultado sea estrictamente necesario.
-- A diferencia de lenguajes imperativos (como Java, C o Python) que evaluate de adentro hacia afuera,
-- Haskell evalúa de afuera hacia adentro (Call-by-name / Reducción Externa).

-- Ejemplo clásico con cortocircuito de error:
-- En otros lenguajes, '1/0' rompería el programa inmediatamente por división por cero.
-- En Haskell, como 'fst' solo requiere la cabeza del par, el segundo componente jamás se evalúa.

ejemploFst :: Integer
ejemploFst = fst (5, 1 `div` 0) -- Retorna 5 sin lanzar excepciones

ejemploAnd :: Bool
ejemploAnd = False && error "Este error nunca se va a disparar" -- Retorna False por cortocircuito

-----------------------------------------------------------
-- 2. LISTAS INFINITAS Y LAZY EVALUATION
-----------------------------------------------------------

-- Gracias a que Haskell no calcula los datos de antemano, podemos definir listas infinitas.
-- El programa solo computará la porción de la lista que le sea requerida por otra función.

-- Generador infinito básico mediante rangos infinitos:
numerosNaturales :: [Integer]
numerosNaturales = [1..] -- Genera [1, 2, 3, 4, 5, 6, 7, ...] infinitamente

-- Generador usando la función recursiva nativa 'repeat' o 'cycle'
listaInfinitaDeUnos :: [Integer]
listaInfinitaDeUnos = repeat 1

-----------------------------------------------------------
-- 3. APROVECHAMIENTO CON ORDEN SUPERIOR (ACOTACIÓN)
-----------------------------------------------------------

-- Para trabajar de forma segura con conjuntos infinitos, nos "colgamos" de funciones 
-- que imponen un límite de lectura (como 'take' o predicados directos).

tomarElementosDeListaInfinita :: [Integer]
tomarElementosDeListaInfinita = take 5 numerosNaturales -- Retorna [1,2,3,4,5] y frena el cómputo

-- Ejemplo adaptado a los apuntes de la clase de hoy ("La medicina del Futuro" / "Experimentos"):
-- Encontrar el primer número par dentro de un universo infinito
primerParIdeal :: Integer
primerParIdeal = head (filter even [1..]) -- Retorna 2 de manera instantánea

-- Ejemplo avanzado combinando 'any' sobre lista infinita (cambiamos el nombre de la variable para evitar escape):
existeMultiploDeSiete :: Bool
existeMultiploDeSiete = any (\nro -> nro `mod` 7 == 0) [1..] -- Retorna True apenas encuentra el 7

{- HLINT ignore "Use list literal" -}
{- HLINT ignore "Eta reduce" -}
{- HLINT ignore "Evaluate" -}
