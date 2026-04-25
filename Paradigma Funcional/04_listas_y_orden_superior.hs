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

-----------------------------------------------------------
-- 3. Ejercicios
-----------------------------------------------------------
{-
    DOMINIO APLICADO: POLÍTICOS
-}

data Politico = Politico { 
    proyectosPresentados :: [String], 
    sueldo :: Integer, 
    edad :: Integer 
} deriving Show

politicos = [
    Politico ["Ser libres", "Educación", "Ley 18234"] 20000 81, 
    Politico ["Impulsar tecnología"] 10000 63, 
    Politico ["Tolerancia nula ante delitos"] 15500 49 
  ]

{-
    - 1) Resolver la función find' que encuentra el primer elemento que cumple una condición.
         No se puede resolver con recursividad. Si ningún elemento cumple la condición dejar que falle.
-}


-- find': busca el primer elemento que cumple.
-- NOTA: Es una función PARCIAL. Si filter devuelve [], head explota
find' :: (a -> Bool) -> [a] -> a
find' f lista = (head . filter f) lista

{-
    - 1.1) Aprovechar la función find' para aplicarla al dominio.
            REQUERIMIENTOS (Para probar en consola):
            
            a) Político joven (< 50 años):
                find' ((<50) . edad) politicos

            b) Con más de 3 proyectos (OJO: da Exception si no hay ninguno):
                find' ((>3) . length . proyectosPresentados) politicos

            c) Con algún proyecto de más de 3 palabras:
                find' (any ((>3) . length . words) . proyectosPresentados) politicos
-}

-----------------------------------------------------------
-- ANOTACIONES
-----------------------------------------------------------
{-
  1. EL FLUJO DEL ANY (Punto C):
     - proyectosPresentados: extrae [String] del político.
     - any: actúa como sensor. Si AL MENOS UN proyecto devuelve True, el político pasa el filter.
     - ((>3) . length . words): lógica interna aplicada a cada String de la lista.

  2. ERRORES COMUNES:
     - Variable not in scope: Casi siempre es un typo (ej: 'lenght' en vez de 'length').
     - Prelude.head empty list: El filter no encontró nada y head no puede operar en [].
-}