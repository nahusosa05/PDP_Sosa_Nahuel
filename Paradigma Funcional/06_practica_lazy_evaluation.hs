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
cerebro = Raton "Cerebro" 9.0 0.2 ["brucelosis", "sarampión", "tuberculosis"]

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


-------------------------------------------------------------------------
-- EJERCICIO 2: Hierbas (Transformadores de Ratones)
-------------------------------------------------------------------------

{-
    - 2.a) hierbaBuena: Rejuvenece al ratón a la raíz cuadrada de su edad.
           > hierbaBuena cerebro -> edad = 3.0
-}

{-
    - 2.b) hierbaVerde: Elimina una enfermedad dada de la lista del ratón.
           > hierbaVerde "brucelosis" cerebro -> saca "brucelosis" de las enfermedades
-}

{-
    - 2.c) alcachofa: Hace que el ratón pierda peso en un 10% si pesa más de 2kg, 
           sino pierde un 5%.
-}

{-
    - 2.d) hierbaMagica: Hace que el ratón pierda todas sus infecciones y quede con 0 años de edad.
           NOTA: Se limpia usando las infecciosas de base del punto 1.
-}

-------------------------------------------------------------------------
-- EJERCICIO 3: Medicamentos (Uso de Folds / Plegados)
-------------------------------------------------------------------------

{-
    - 3.a) Hacer la función medicamento, que recibe una lista de hierbas, un ratón, 
           y administra al ratón todas las hierbas.
           REQUERIMIENTO: Las hierbas deben aplicarse en orden sucesivo. (Pista: foldl o foldr)
-}

{-
    - 3.b) Hacer antiAge: Medicamento hecho con 3 hierbas buenas y una alcachofa.
           > antiAge (Raton "bicenterata" 256.0 0.2 [])
           Raton "bicenterata" 2.0 0.19 []
-}

{-
    - 3.c) Hacer reduceFatFast: Recibe una potencia (Int) y es un medicamento compuesto 
           por una hierbaVerde de "obesidad" y tantas alcachofas como indique su potencia.
           
           > reduceFatFast 1 (Raton "Orejudo" 4.0 10.0 ["obesidad", "sinusitis"])
           Raton "Orejudo" 4.0 9.0 ["sinusitis"]
-}

{-
    - 3.d) Hacer la función hierbaMilagrosa, que es un medicamento que usa hierbasVerdes 
           para curar todas las enfermedades infecciosas.
-}

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

{-
    - 4.b) Hacer la función estanMejoresQueNunca que dado un conjunto (lista) de ratones 
           y un medicamento, es cierto cuando cada uno pesa menos de 1 kg después de 
           aplicarle el medicamento dado.
-}

{-
    - 4.c) Diseñar el siguiente experimento: dado un conjunto de ratones, encontrar la 
           potencia ideal del reduceFatFast necesaria para que todos estén mejores que nunca.
-}
