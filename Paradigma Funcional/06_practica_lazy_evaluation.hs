-----------------------------------------------------------
--  Ejercicios: Lazy Evaluation
-----------------------------------------------------------

-------------------------------------------------------------------------
-- 1. MODELADO DE DATOS Y ENFERMEDADES BASE
-------------------------------------------------------------------------
data Animal = Raton {
    nombre       :: String,
    edad         :: Double,
    peso         :: Double,
    enfermedades :: [String]
} deriving Show

-- Ejemplo de ratón base para pruebas:
cerebro :: Animal
cerebro = Raton "Cerebro" 9.0 0.2 ["brucelosis", "sarampion", "tuberculosis"]

-- Lista de enfermedades infecciosas del enunciado:
enfermedadesInfecciosas :: [String]
enfermedadesInfecciosas = ["brucelosis", "tuberculosis"]


-------------------------------------------------------------------------
-- EJERCICIO 1: Funciones de Modificación (Uso de Record Syntax)
-------------------------------------------------------------------------

{-
    - 1) Hacer 4 funciones de modificación del ratón: modificarNombre, modificarEdad, 
         modificarPeso, modificarEnfermedades. Deben recibir una función de transformación 
         y un ratón, y devolver el ratón modificado.
         
         > modificarEdad (*2) cerebro
         Raton "Cerebro" 18.0 0.2 ["brucelosis", "sarampión", "tuberculosis"]
         
         > modificarNombre (++ " el genio") cerebro
         Raton "Cerebro el genio" 9.0 0.2 ["brucelosis", "sarampión", "tuberculosis"]
-}

modificarEdad :: (Double -> Double) -> Animal -> Animal
modificarEdad f raton = raton { edad = (f . edad) raton }

modificarNombre :: (String -> String) -> Animal -> Animal
modificarNombre f raton = raton { nombre = (f . nombre) raton }

modificarPeso :: (Double -> Double) -> Animal -> Animal
modificarPeso f raton = raton { peso = (f . peso) raton }

modificarEnfermedades :: ([String] -> [String]) -> Animal -> Animal
modificarEnfermedades f raton = raton { enfermedades = (f . enfermedades) raton }

-------------------------------------------------------------------------
-- EJERCICIO 2: Hierbas (Transformadores de Ratones)
-------------------------------------------------------------------------

type Hierba = Animal -> Animal

{-
    - 2.a) hierbaBuena: Rejuvenece al ratón a la raíz cuadrada de su edad.
           > hierbaBuena cerebro -> edad = 3.0
-}

hierbaBuena :: Hierba
hierbaBuena raton = modificarEdad sqrt raton

{-
    - 2.b) hierbaVerde: Elimina una enfermedad dada de la lista del ratón.
           > hierbaVerde "brucelosis" cerebro -> saca "brucelosis" de las enfermedades
-}

hierbaVerde :: String -> Hierba
hierbaVerde enf raton = modificarEnfermedades (filter (/=enf )) raton

{-
    - 2.c) alcachofa: Hace que el ratón pierda peso en un 10% si pesa más de 2kg, 
           sino pierde un 5%.
-}

alcachofa :: Animal -> Animal
alcachofa raton | peso raton > 2.0 = modificarPeso (*0.9) raton
                | otherwise = modificarPeso (*0.95) raton

{-
    - 2.d) hierbaMagica: Hace que el ratón pierda todas sus infecciones y quede con 0 años de edad.
           NOTA: Se limpia usando las infecciosas de base del punto 1.
-}

hierbaMagica :: Hierba
-- hierbaMagica raton = (modificarEnfermedades (const []) . modificarEdad (*0)) raton
hierbaMagica raton = modificarEnfermedades (const []) . modificarEdad (*0) $ raton

-------------------------------------------------------------------------
-- EJERCICIO 3: Medicamentos (Uso de Folds / Plegados)
-------------------------------------------------------------------------

{-
    - 3.a) Hacer la función medicamento, que recibe una lista de hierbas, un ratón, 
           y administra al ratón todas las hierbas.
           REQUERIMIENTO: Las hierbas deben aplicarse en orden sucesivo. (Pista: foldl o foldr)
-}

medicamento :: [Hierba] -> Animal -> Animal
medicamento listaHierbas raton = foldl (\rat hierba -> hierba rat) raton listaHierbas

{-
    - 3.b) Hacer antiAge: Medicamento hecho con 3 hierbas buenas y una alcachofa.
           > antiAge (Raton "bicenterata" 256.0 0.2 [])
           Raton "bicenterata" 2.0 0.19 []
-}

antiAge :: Animal -> Animal
antiAge raton = medicamento  (replicate 3 hierbaBuena ++ [alcachofa]) raton

{-
    - 3.c) Hacer reduceFatFast: Recibe una potencia (Int) y es un medicamento compuesto 
           por una hierbaVerde de "obesidad" y tantas alcachofas como indique su potencia.
           
           > reduceFatFast 1 (Raton "Orejudo" 4.0 10.0 ["obesidad", "sinusitis"])
           Raton "Orejudo" 4.0 9.0 ["sinusitis"]
-}

reduceFatFast :: Int -> Animal -> Animal
-- reduceFatFast potencia raton = medicamento ([hierbaVerde "obesidad"] ++ replicate potencia alcachofa) raton
reduceFatFast potencia raton = medicamento (hierbaVerde "obesidad" : replicate potencia alcachofa) raton

{-
    - 3.d) Hacer la función hierbaMilagrosa, que es un medicamento que usa hierbasVerdes 
           para curar todas las enfermedades infecciosas.
-}

hierbaMilagrosa :: Animal -> Animal
hierbaMilagrosa raton = medicamento (map hierbaVerde enfermedadesInfecciosas) raton

-------------------------------------------------------------------------
-- EJERCICIO 4: Experimentos
-------------------------------------------------------------------------

{-
    - 4.a) Hacer la función cantidadIdeal. Recibe una condición y dice cuál es 
           el primer número natural que la cumple.
           
           > cantidadIdeal even -> 2
           > cantidadIdeal (>5) -> 6
           
           NOTA: Recordá que podés generar una lista infinita con [1..] gracias a Lazy Evaluation.
-}

cantidadIdeal :: (Int -> Bool) -> Int
cantidadIdeal f = (head . filter f) [1..]

{-
    - 4.b) Hacer la función estanMejoresQueNunca que dado un conjunto (lista) de ratones 
           y un medicamento, es cierto cuando cada uno pesa menos de 1 kg después de 
           aplicarle el medicamento dado.
-}

estanMejoresQueNunca :: [Animal] -> (Animal -> Animal) -> Bool
estanMejoresQueNunca ratones medicamento = all ((<1) . peso . medicamento) ratones

{-
    - 4.c) Diseñar el siguiente experimento: dado un conjunto de ratones, encontrar la 
           potencia ideal del reduceFatFast necesaria para que todos estén mejores que nunca.
-}

ratonA = Raton "Pelon" 20 5.0 ["obesidad"]
ratonB = Raton "Pelado" 10 6.0 ["obesidad"]

experimento :: [Animal] -> Int
experimento ratones = cantidadIdeal (estanMejoresQueNunca ratones . reduceFatFast)

{- HLINT ignore "Eta reduce" -}