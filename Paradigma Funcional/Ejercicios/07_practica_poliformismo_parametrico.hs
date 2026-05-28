-----------------------------------------------------------
--  Ejercicios: Poliformismo Paramétrico y AD HOC.
-----------------------------------------------------------

-------------------------------------------------------------------------
-- EJERCICIO 1: Determinar tipos
-------------------------------------------------------------------------

{-
    1) Determinar para cada una de las funciones:
        - ¿Que hace?
        - Dar el prototipo / tipo de las funciones
-}

p :: (c -> Bool) -> [c] -> c
p n lista = (head . filter n) lista

f :: Ord a1 => (a2 -> a1) -> [(a2, a2)] -> Bool
f x y = (x . fst . head) y > (x . snd . head) y

g :: Eq a => (t -> a) -> t -> t -> Bool
g f a b = f a == f b

f' :: (a1 -> Bool) -> (a2 -> a1) -> Int -> [a2] -> Bool
f' x y z lista = ((>z) . length . filter x . map y) lista

g' :: (a, b, c) -> b
g' (_ , c , _) = c

h :: Eq b => b -> [(a, b, c)] -> (a, b, c)
h nom = head . filter ((nom==) . g')

h' :: (Ord a, Num a, Num t) => t -> (t -> a) -> [t] -> t
h' x _ [] = x
h' x y (z : zs) | y z > 0 = z + h' x y zs 
                | otherwise = h' x y zs

p' :: (Ord t1) => t1 -> (t1 -> t2) -> [t1] -> t2
p' x y (z : zs) | x > z = p' x y zs
                | otherwise = y z

f'' :: (Num t1) => (t2 -> Bool) -> t3 -> [t3] -> (Int -> (t1, Bool) -> t2) -> Int -> Int
f'' a b c d e | (a . d e) (1 , True)  = 0
              | otherwise = length (b : c) + e

g'' :: (Eq b) => (a -> b) -> b -> [a] -> a
g'' f x l = (head . filter ((x==) . f)) l

qfsort :: Ord b => (a -> b) -> [a] -> [a]
qfsort f [] = []
qfsort f (x : xs) = qfsort f (filter ((>f x) . f) xs) 
                    ++ [x] 
                    ++ qfsort f (filter ((<f x) . f) xs)

floca g f n | (g . f) n = n : floca g f (n + 1)
            | otherwise = floca g f (n + 1)

-- h'' :: (Ord b) => ([a] -> b) -> (b -> [a] -> [a]) -> b -> Bool
h'' :: Ord b => (a -> b) -> (b -> a -> Bool) -> b -> [a] -> Bool
h'' k p r = all (p r) . filter ((> r) . k)

final :: Eq a1 => a1 -> (t1 -> t2 -> a1) -> t1 -> [(a2, t2)] -> Bool
final h r x = any (h==) . map (\(_, z) -> r x z)

{- HLINT ignore "Eta reduce" -}
{- HLINT ignore "Use elem" -}
{- HLINT ignore "Redundant map" -}