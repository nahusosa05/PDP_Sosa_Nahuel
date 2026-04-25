{-
  Clase: 17/04/2026 - Funcional III
  Temas: 
    - Tipos de Datos Algebraicos (Data)
    - Composición de funciones (.)
    - Aplicación Parcial y Point-free
    - Pattern Matching avanzado
-}

import Text.Show.Functions ()

{-
    import Text.Show.Functions: Se usa para que, si tu data tiene una función adentro, el 
    programa no explote al intentar mostrarla.

    deriving (Show): Se usa en los Data Types (como Empleado o Bebida) 
    para mostrar sus valores (el sueldo, el nombre, etc.).
-}

-----------------------------------------------------------
-- 1. NOTAS Y RENDIMIENTO (Tuplas y Composición)
-----------------------------------------------------------

type Notas = (Integer, Integer) -- Alias para legibilidad 

-- 1.a: esNotaBochazo (Point-free con aplicación parcial)
-- Definida como una función que espera un nro y ve si es < 6 
esNotaBochazo :: Integer -> Bool
esNotaBochazo = (< 6) 

-- 1.b: aprobo (Delegación y negación)
-- Para aprobar, ambas notas NO deben ser bochazo 
aprobo :: Notas -> Bool
aprobo (n1, n2) = (not . esNotaBochazo) n1 && (not . esNotaBochazo) n2

-- 1.c: promociono (Lógica combinada)
-- Suma >= 16 y ambas >= 8 
promociono :: Notas -> Bool
promociono (n1, n2) = (n1 + n2 >= 16) && n1 >= 8 && n2 >= 8

-- 1.d: Consulta con composición 
-- fst extrae la primera nota, luego evaluamos si NO es bochazo.
-- Ejecución: (not . esNotaBochazo . fst) (5, 8) -> False
aproboPrimerParcial = not . esNotaBochazo . fst

-----------------------------------------------------------
-- 2. EMPRESA (Pattern Matching sobre Data)
-----------------------------------------------------------

-- Definimos el tipo de dato con múltiples constructores 
data Empleado = Comun { sueldoBasico :: Double, nombre :: String }
              | Jefe { sueldoBasico :: Double, antiguedad :: Double, nombre :: String }
              deriving (Show)

-- Función auxiliar para el plus 
plusPorAntiguedad :: Double -> Double
plusPorAntiguedad = (* 10000)

-- Cálculo de sueldo usando Pattern Matching
calcularSueldo :: Empleado -> Double
calcularSueldo (Comun basico _) = basico
calcularSueldo (Jefe basico ant _) = basico + plusPorAntiguedad ant

-----------------------------------------------------------
-- 3. BEBIDAS (Pattern Matching de Valores Específicos)
-----------------------------------------------------------

data Bebida = Cafe { nombreBebida :: String }
            | Gaseosa { sabor :: String, azucar :: Integer }
            deriving (Show)

-- Versión elegante: Macheamos directamente el valor "capuchino" o "pomelo" 
esEnergizante :: Bebida -> Bool
esEnergizante (Cafe "capuchino") = True
esEnergizante (Gaseosa "pomelo" g) = g > 10
esEnergizante _ = False -- Cualquier otra combinación no es energizante