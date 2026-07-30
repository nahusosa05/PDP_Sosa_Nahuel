data Persona = Persona {
    nombre :: String,
    habilidades :: [String],
    reflejos :: Double,
    bebidasQueTomo :: [Bebida]
}

type Bebida = Persona -> Persona

    -- Bebidas --
-- café: aumenta los reflejos en 5 unidades
cafe :: Bebida
cafe = modificarReflejos 5 

modificarReflejos :: Double -> Persona -> Persona
modificarReflejos reflejosIngresados persona = persona {
    reflejos = reflejos persona + reflejosIngresados
}

{- 
    whisky: se bebe con hielo y quita a quien lo bebe todas las habilidades con long mayor a 6
           (puede "tomar", puede "correr", pero no puede "dar explicación" ni "jugar a la pelota")
           y ademas disminuye los reflejos tanto como la diferencia entre el porcentaje de alcohol 
           y la cantidad de hielo que contenga.
-}
whisky :: Double -> Double -> Bebida
whisky hielo porcentaje persona = modificarReflejos (abs (-(porcentaje - hielo))) . 
                                  modificarHabilidades (filter ((<=6). length) (habilidades persona)) $ persona

modificarHabilidades :: [String] -> Persona -> Persona
modificarHabilidades nuevasHabilidades persona = persona {
    habilidades = nuevasHabilidades
}

{-
    cerveza: disminuye los reflejos tanto como el porcentaje de alcohol que aporta y hace que
    pierda la primera habilidad.
-}
cerveza :: Double -> Bebida
cerveza porcentaje persona = modificarReflejos (- porcentaje) .
                             modificarHabilidades (tail . habilidades $ persona) $ persona

-- gaseosa: aumenta los reflejos la mitad de la cantidad de azúcar que aporta
gaseosa :: Double -> Bebida
gaseosa azucar = modificarReflejos (azucar * 0.5)

-- agua mineral: no altera a la persona
aguaMineral :: Bebida
aguaMineral persona = persona

{-
    Definir una bebida inventada usando expresiones lambda:
    (\persona -> modificarReflejos 20 persona)
-}

{-
    Modelar a Ana: Tiene como habilidad "jugar al poker" y "cantar",
                   su nivel de reflejos es de 20,
                   bebió cerveza con porcentaje de alcohol de 3%, 1 gaseosa con 5g de azucar y otra de 7g.
-}

ana = Persona "Ana" 
              ["Jugar al poker", "Cantar"] 
              20 
              [cerveza 3, gaseosa 5, gaseosa 7]

{-
    Definir tomar: Dada una persona y una bebida
                   Agrega la bebida en el conjunto de bebidas que tomó y devuelve a la persona con el
                   efecto producido.
-}

tomar :: Persona -> Bebida -> Persona
tomar persona bebida = bebida . modificarBebida (++ [bebida]) $ persona

modificarBebida :: ([Bebida] -> [Bebida]) -> Persona -> Persona
modificarBebida funcion persona = persona {
    bebidasQueTomo = funcion . bebidasQueTomo $ persona
} 

{-
    Definir degustar: Dada una persona y un trago (conjunto de bebidas) devuelve la persona luego de
                      haber tomar el trago. (usar orden superior)
-}

type Trago = [Bebida]

degustar :: Persona -> Trago -> Persona
degustar persona trago = foldl tomar persona trago

{-
    Dado un conjunto de personas y un trago: Conocer las personas que están sobrias luego de tomarse un
    trago. Está sobria una persona si tiene al menos 2 habilidades y tiene mas de 80 en su nivel de reflejos.
-}

personasSobrias :: [Persona] -> Trago -> [Persona]
personasSobrias personas trago = filter (estaSobria . flip degustar trago) personas

estaSobria :: Persona -> Bool
estaSobria persona = ((>=2) . length . habilidades) persona && ((>80) . reflejos) persona

{-
    Dada una persona y un trago: Conocer la mejor bebida que es aquella que deja a la persona con mayor
    cantidad de reflejos. (orden superior)
-}

mejorBebida :: Persona -> Trago -> Bebida
mejorBebida persona (trago : tragos) = foldl (mayorReflejos persona) trago tragos

mayorReflejos :: Persona -> Bebida -> Bebida -> Bebida
mayorReflejos persona bebidaA bebidaB | (reflejos . bebidaA) persona > (reflejos . bebidaB) persona = bebidaA
                                      | otherwise = bebidaB

-- Construir un trago infinito y construir una persona con infinitas habilidades.
tragoInfinito = repeat cafe

pedro = Persona "Pedro" 
                (repeat "correr") 
                100 
                []

{-
    Dada la persona y el trago infinito construido en el punto anterior.
    ¿Hay alguna consulta que pueda hacer por consola sin definir funciones auxiliares
    para conocer la bebida que deje a persona sobria? Justificar conceptualmente y dar
    un ejemplo de invocación en caso de que si se pueda.

    > head . filter (\bebida -> (estaSobria . bebida) pedro) tragoInfinito

    No corta porque "((>=2) . length . habilidades) persona" en "estaSobria" no sabe
    que cantidad devolver ya que es una lista infinita.
-}

{- HLINT ignore "Eta reduce" -}
