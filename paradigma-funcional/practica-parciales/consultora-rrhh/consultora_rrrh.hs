{- HLINT ignore "Eta reduce" -}
import Data.Array (Ix(range))
import Data.Text (replace)
{- HLINT ignore "Use infix" -}
data Postulante = UnPostulante {
    nombre :: String,
    edad :: Double,
    remuneracion :: Double,
    conocimientos :: [String]
} | Estudiante {
    legajo :: Integer,
    conocimientos :: [String]
} deriving Show

pepe = UnPostulante "Jose Perez" 35 15000.0 ["Haskell", "Prolog", "Wollok", "C"]

tito = UnPostulante "Roberto González" 20 12000.0 ["Haskell", "Php"]

type Nombre = String

data Puesto = UnPuesto {
    puesto :: String,
    conocimientosRequeridos :: [String]
} deriving Show

jefe = UnPuesto "gerente de sistemas" ["Haskell", "Prolog", "Wollok"]
chePibe = UnPuesto "cadete" ["ir al banco"]

apellidoDueno :: Nombre
apellidoDueno = "Gonzalez"

tieneConocimientos :: Puesto -> Requisito
tieneConocimientos puesto post = all (\x -> elem x (conocimientos post)) (conocimientosRequeridos puesto)

edadAceptable :: Double -> Double -> Requisito
edadAceptable edadMin edadMax post = edadMin <= edad post && edad post <= edadMax

sinArreglo :: Requisito
sinArreglo post =  (last . words . nombre) post /= apellidoDueno

type Requisito = Postulante -> Bool

cumpleRequisitos :: [Requisito] -> Postulante -> Bool
cumpleRequisitos requisitos postulante = all ($ postulante) requisitos

preseleccion :: [Postulante] -> [Requisito] -> [Postulante]
preseleccion posts requisitos = filter (cumpleRequisitos requisitos) posts

{-
    Ejercicio a
    ghci> preseleccion [pepe, tito] [tieneConocimientos jefe, edadAceptable 30 40, sinArreglo]
    [   UnPostulante {
            nombre = "Jose Perez", 
            edad = 35.0, 
            remuneracion = 15000.0, 
            conocimientos = ["Haskell","Prolog","Wollok","C"]
        }
    ]
-}

{-
    Ejercicio b
    ghci> preseleccion [pepe, tito] [tieneConocimientos jefe, edadAceptable 30 40, sinArreglo, notElem "repetir lógica" . conocimientos]   
    [   UnPostulante {
            nombre = "Jose Perez", 
            edad = 35.0, 
            remuneracion = 15000.0, 
            conocimientos = ["Haskell","Prolog","Wollok","C"]
        }
    ]
-}

-- Funciones ya dadas
incrementarEdad :: Postulante -> Postulante
incrementarEdad post = post

aumentarSueldo :: Double -> Postulante -> Postulante
aumentarSueldo porcentaje post = post

-- Por compresión
actualizarPostulantes :: [Postulante] -> [Postulante]
actualizarPostulantes postulantes = [(incrementarEdad . aumentarSueldo 27) unPostulante | unPostulante <- postulantes]

-- Utilizando Composición y aplicación parcial
actualizarPostulantes1 :: [Postulante] -> [Postulante] 
actualizarPostulantes1 postulantes = map (incrementarEdad . aumentarSueldo 27) postulantes

type Conocimiento = String
capacitar :: Postulante -> Conocimiento -> Postulante
capacitar (UnPostulante nombre edad remuneracion conocimientos) nuevoConocimiento = UnPostulante nombre edad remuneracion (conocimientos ++ [nuevoConocimiento])
capacitar (Estudiante legajo conocimientos) nuevoConocimiento =  Estudiante legajo (init conocimientos ++ [nuevoConocimiento])

capacitacion :: Puesto -> Postulante -> Postulante
capacitacion puesto post = foldl capacitar post (conocimientosRequeridos puesto) 