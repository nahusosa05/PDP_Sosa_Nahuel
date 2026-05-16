{- HLINT ignore "Use list literal" -}
{- HLINT ignore "Eta reduce" -}
import GHC.ExecutionStack (Location(functionName))

{- 
  Clase: 24/04/2026 - Funcional IV
  Temas: 
    - Listas (Extensión, Cons y Comprensión)
    - Funciones de Orden Superior (Concepto y uso)
    - Composición avanzada con Listas
-}

-----------------------------------------------------------
-- 1. Listas: Definiciones
-----------------------------------------------------------

-----------------------------------------------------------
-- 1. LISTAS: DEFINICIONES Y ESTRUCTURA
-----------------------------------------------------------

-- Listas por Extensión
-- Las listas son HOMOGÉNEAS (mismo tipo) y se construyen con el operador ":" (cons)
-- [3,5,8,9] es equivalente a:

lista = [3,5,8,9]
listaA = 3:[5,8,9]
listaB = 3:5:[8,9]
listaC = 3:5:8:[9]
listaEjemplo = 3:5:8:9:[] -- [] es el caso base (lista vacía)

-- Listas por Comprensión: { imagen | generador , filtro }
pares :: [Integer] -> [Integer]
pares conjunto = [nro | nro <- conjunto, even nro]

esDivisible :: Integer -> Integer -> Bool
esDivisible n nro = ((==0).(`mod`n)) nro

-- divisiblesPor refactorizada: usamos filter y aplicación parcial para mayor declaratividad
divisiblesPor :: Integer -> [Integer] -> [Integer]
divisiblesPor n = filter (esDivisible n)

divisiblesPorA :: Integer -> [Integer] -> [Integer]
divisiblesPorA n numeros = [nro | nro <- numeros , esDivisible n nro]

duplicadosDeCincoNumeros :: [Integer] -> [Integer]
-- [1..5] = [1,2,3,4,5] 
duplicadosDeCincoNumeros conjunto = [2*nro | nro <- [1..5]]

conjuntoDePares :: [(Integer, Char)] -> [(Integer, Char)]
conjuntoDePares conjunto = [(x,y) | x <- [1..3] , y <- ['a'..'c']]

mayoresA :: Integer -> [Integer] -> [Integer]
mayoresA n numeros = [nro | nro <- numeros , n < nro]

-----------------------------------------------------------
-- 2. FUNCIONES DE ORDEN SUPERIOR
-----------------------------------------------------------

-- Reciben funciones por parámetro para abstraer lógica de recorrido

-- Ejemplo: seleccionar es equivalente a 'filter' del Prelude
seleccionar :: (Integer -> Bool) -> [Integer] -> [Integer]
seleccionar funcion numeros = [nro | nro <- numeros, funcion nro]

-- Esta es de ejemplo, se pueden realizar pero vamos a usar las que vienen en el prelude
-- cómo filter, map, any o all, cómo algunos ejemplos. Pero de igual manera algunas las vamos a crear.