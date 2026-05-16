-----------------------------------------------------------
--  Ejercicios: Orden Superior
-----------------------------------------------------------
{-
    DOMINIO APLICADO: POLÍTICOS
-}
{- HLINT ignore "Eta reduce" -}

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

{-
    - 2) Definir la función promediosAlumnos, que dada una lista de alumnos devuelve una lista de tuplas que tenga el alumno 
        y el promiedo (Consideremos la división entera para el promedio y usamos la funcion div).

        > promedioAlumnos[(Alumno "Juan" [8,6]), (Alumno "Maria" [7,9,4]), (Alumno "Ana" [6,2,4])]
        > [("Juan", 7),("Maria", 6),("Ana", 4)]
-}

type Nombre = String
type Notas = [Int]
data Persona = Alumno {nombre :: Nombre, notas :: Notas}

-- Ejemplos para pruebas en consola:
manuel = Alumno "manuel" [8, 6, 2, 4]
elena  = Alumno "elena"  [7, 9, 8, 7]
ana    = Alumno "ana"    [6, 2, 4, 2]
pedro  = Alumno "pedro"  [9, 6, 7, 10]

alumnosFingod = [manuel, elena, ana, pedro]

{-
    - 3) Definir la funcion promediosSinAplazos, que dada una lista de listas, devuelve la lista de los promedios que cada 
        lista-elemento, excluyendo los que sean menores a 6 no se cuenten.

        > promediosSinAplazos [[8,6], [6,6,4]]
        > [7,6]
-}

{-
    - 4) Definir la función aprobo, que dado un alumno devuelve True si el alumno aprobó.
         Aclaración: se dice que un alumno aprobó si todas sus notas son 6 o más.
         
         > aprobo (Alumno "Manuel" [8,6,2,4]))
         > False
-}

{-
    - 5) Definir la función aprobaron/1, que dada una lista de alumnos, devuelve los 
         nombres de los alumnos que aprobaron.
         
         > aprobaron alumnosFingod
         > ["elena", "pedro"]
-}

{-
    - 6) Definir la función productos que dado una lista de nombres de productos y 
         una lista de precios, devuelve una lista de tuplas.
        Definirla usando zip y usando zipWith de forma separada para entender la diferencia.
         
         > productos ["melon", "zapallo", "palta"] [15, 10, 12, 7]
         > [("melon", 15), ("zapallo", 10), ("palta", 12)]
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