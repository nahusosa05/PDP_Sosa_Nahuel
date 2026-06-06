{- HLINT ignore "Eta reduce" -}
import Text.Show.Functions
import Data.List 

type Trabajo = Atraccion -> Atraccion

data Reparacion = Reparacion {
    dias :: Int,
    trabajo :: Trabajo
} deriving Show

vueltaAlMundo :: Atraccion
vueltaAlMundo = Atraccion "vueltaAlMundo" 
                120 
                4
                ["genial"] 
                False
                [Reparacion 5 (ajusteDeTornilleria 3)]

data Atraccion = Atraccion {
    nombre :: String,
    alturaRequerida :: Double, -- en cm
    duracion :: Int, -- en minutos
    opiniones :: [String],
    mantenimiento :: Bool, 
    reparaciones :: [Reparacion] -- (duración determinada en días, reparacion que se hace)
} deriving Show

{-
    Punto 1: 
    ¿Que tan buena es una atracción?
    - Si la atracción tiene una duración prolongada (mas de 10 minutos) == 100 puntos
    - Si dura menos de 10 min pero tiene menos de 3 órdenes de reparacion == 10 puntos por cada letra del nombre más 2 por cada opinión que tenga
    - Caso contrario 10 veces la altura mínima requerida
-}

type Score = Double

calcularScore :: Atraccion -> Score
-- calcularScore atraccion = 10 * length (nombre atraccion) + 2*length(opiniones atraccion)
--      genericLength para no tener errores de tipos como lo tengo en la que 
--      hice yo pero para el parcial está bien.

calcularScore atraccion = ((10*) . genericLength . nombre $ atraccion) +
                          ((2*) . genericLength . opiniones $ atraccion)

sistemaDeScoring :: Atraccion -> Score
sistemaDeScoring atraccion
    | duracion atraccion > 10 = 100
    | length (reparaciones atraccion) < 3 = calcularScore atraccion
    | otherwise = 10 * alturaRequerida atraccion

{-
    Punto 2: 
    ¿Que tan buena es una atracción?
    - ajusteDeTornilleria: duración + 1m por cada tornillo apretado, no puede superar los 10
    - engrase: aumenta en 0,1 cm la altura mínima requerida por cada gramo de grasa utilizada
               ++ opinion "para valientes". 
               La cantidad de grasa requerida puede variar según el criterio del técnico.
    - mantenimientoElectrico: solo quedan las 2 primeras opiniones y el resto se descartan
    - mantenimientoBasico: (ajusteDeTornilleria 8 . engrase 10) atraccion
-}

ajusteDeTornilleria :: Int -> Trabajo
ajusteDeTornilleria tornillos atraccion = atraccion {
    duracion = min 10 (duracion atraccion + tornillos)
}

agregarOpinion :: String -> Trabajo
agregarOpinion opinion atraccion = atraccion {
    opiniones = opiniones atraccion ++ [opinion]
}

modificarAltura :: Double -> Trabajo
modificarAltura cant atraccion = atraccion {
    alturaRequerida = alturaRequerida atraccion + (0.1 * cant)
}

engrase :: Double -> Trabajo
engrase cantGrasa = agregarOpinion "para valientes" . modificarAltura cantGrasa

mantenimientoElectrico :: Trabajo
mantenimientoElectrico atraccion = atraccion {
    opiniones = (take 2 . opiniones) atraccion
}

mantenimientoBasico :: Trabajo
mantenimientoBasico = ajusteDeTornilleria 8 . engrase 10

{-
    Punto 3:
-}

meDaMiedito :: Atraccion -> Bool
meDaMiedito atraccion = any ((> 4) . dias) . reparaciones $ atraccion

cantDiasDeReparacion :: Atraccion -> Int
cantDiasDeReparacion atraccion = foldl (\sem repa -> sem + dias repa) 0 (reparaciones atraccion)

cerramos:: Atraccion -> Bool
cerramos atraccion = (>7) . cantDiasDeReparacion $ atraccion

type Parque = [Atraccion]

disneyNoExistis :: Parque -> Bool
disneyNoExistis atracciones = all (null . reparaciones) . filter ((>5) . length . nombre ) $ atracciones