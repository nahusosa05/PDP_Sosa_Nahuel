{- HLINT ignore "Eta reduce" -}
{-
    Primera parte: punto 1
-}
{- HLINT ignore "Use infix" -}

import Text.Show.Functions
data Movie = Movie {
    title :: String, 
    genre :: String,
    duration :: Int,
    origin :: String
} deriving (Show, Eq)

data User = User {
    name :: String,
    age :: Int,
    category :: String,
    residenceCountry :: String,
    sawMovies :: [Movie],
    healthState :: Int
} deriving Show

psicosis = Movie "Psicosis" "Terror" 109 "Estados Unidos" 
perfumeDeMujer=  Movie  "Perfume  de  Mujer"  "Drama"  150   "Estados Unidos" 
elSaborDeLasCervezas = Movie "El sabor de las cervezas"  "Drama" 95 "Iran" 
lasTortugasTambienVuelan  =  Movie  "Las  tortugas  también  vuelan" "Drama" 103 "Iran" 

juan = User "juan"  23 "Standard" "Argentina" [perfumeDeMujer] 60 

{-
    Punto 2
-}

seeMovie :: Movie -> User -> User
seeMovie movie user = user {
    sawMovies = sawMovies user ++ [movie]
}

{-
    Punto 3
-}

notMoviesFrom :: String -> [Movie] -> [Movie]
notMoviesFrom country movies = filter ((country /=) . origin) movies
 
conditionsComplete :: User -> Bool
conditionsComplete user = (>20) . length . notMoviesFrom "Estados Unidos" . sawMovies $ user

newCategory :: String -> String
newCategory "Basic" = "Standard"
newCategory _ = "Premium"

upgradeCategory :: User -> User
upgradeCategory user = user {
    category = newCategory . category $ user
}
            
rewardUser :: User -> User
rewardUser user | conditionsComplete user = upgradeCategory user
                | otherwise = user

reward :: [User] -> [User]
reward users = map rewardUser users

{-
    Punto 4
-}

youWantMore :: Movie -> Bool
youWantMore movie = duration movie < 35

genreProblem :: [String] -> Movie -> Bool
genreProblem genres movie = any (\oneGenre -> oneGenre == genre movie) genres

searchMovie :: String -> [Movie] -> [Movie]
searchMovie country movies = filter ((country==) . origin) movies 

matchBy :: (Movie -> String) -> Movie -> Movie -> Bool
matchBy f movieA movieB = f movieA == f movieB

{-
    Punto 5
-}

type CriterioBusqueda = Movie -> Bool

{-
    Recibe: Usuario
            Lista de Criterios de Busqueda

    Devuelve: Lista de 3 películas que cumplan
-}

listaPelisEmpresa = [psicosis, perfumeDeMujer, elSaborDeLasCervezas, lasTortugasTambienVuelan]

comprobarCriterios :: Movie -> [CriterioBusqueda] -> Bool
comprobarCriterios pelicula criterios = all (\criterio -> criterio pelicula) criterios 

usuarioVioPeli :: Movie -> User -> Bool
usuarioVioPeli pelicula usuario = elem pelicula (sawMovies usuario)

cumpleBusqueda :: User -> [CriterioBusqueda] -> Movie -> Bool
cumpleBusqueda usuario criterios peli = not (usuarioVioPeli peli usuario) && comprobarCriterios peli criterios

buscarTresPelis :: User -> [CriterioBusqueda] -> [Movie]
buscarTresPelis usuario criterios = take 3 (filter (cumpleBusqueda usuario criterios) listaPelisEmpresa)

esDeIran :: CriterioBusqueda
esDeIran peli = origin peli == "Iran"

dramaOComedia :: CriterioBusqueda
dramaOComedia peli = genre peli == "Drama" || genre peli == "Comedia"

listaCriterios = [esDeIran, dramaOComedia, not . youWantMore]

{-
    ghci> buscarTresPelis juan listaCriterios
    [   
    Movie {
        title = "El sabor de las cervezas", 
        genre = "Drama", 
        duration = 95, 
        origin = "Iran"
        },
    Movie {
        title = "Las  tortugas  también  vuelan", 
        genre = "Drama", 
        duration = 103, 
        origin = "Iran" 
        }
    ]
-}

{-
    Segunda Parte:

    La gente de la empresa incorpora series. A su vez, está preocupada por la salud emocional 
    de sus usuarios, ante los interminables maratones de series que suelen tener.  

    1)  Definir el tipo de dato para un capítulo de una serie, sabiendo que de cada uno se 
    tiene  la  misma  información  que  una  película,  pero  además  se  cuenta  con  una 
    determinada forma en la que altera la salud del usuario.  
-}

type FormaDeAlterarSalud = Int -> Int
data CapituloSerie = CapituloSerie {
    titulo :: String, 
    genero :: String,
    duracion :: Int,
    origen :: String,
    formaDeAlterarSalud :: FormaDeAlterarSalud
} deriving Show

{-
    2)  Asumiendo  que  los  usuarios  no  ven  sino  consumen  series,  hacer  la  función que 
    recibiendo  al  usuario  y  un  capítulo  de  la  serie,  en  vez  de  registrarlo como vista, 
    devuelva cómo queda la persona.  
-}

comoAfectaA :: User -> CapituloSerie -> User
comoAfectaA usuario cap = usuario {
    healthState = (formaDeAlterarSalud cap . healthState) usuario
}

{-
    3)  Mostrar un ejemplo, inventando una forma de alterar la salud del usuario.  
-}

breakingBad = CapituloSerie "Breaking Bad" "Drama" 60 "Estados Unidos" (\x -> x -10)

{-
    ghci> comoAfectaA juan breakingBad
    User {
        name = "juan", 
        age = 23, 
        category = "Standard", 
        residenceCountry = "Argentina", 
        sawMovies = [Movie {title = "Perfume  de  Mujer", genre = "Drama", duration = 150, origin = "Estados Unidos"}], 
        healthState = 50 (* Cambio 60 -> 50)
    }
-}

{-
    4) Hacer una función llamada maraton, que recibiendo un usuario y una serie completa, 
    devuelva cómo queda la persona luego de consumir todos sus capítulos. 
-}

maraton :: User -> [CapituloSerie] -> User
maraton usuario serie = foldl comoAfectaA usuario serie

{-
    5) ¿Qué sucedería si la serie tuviera una cantidad infinita de capítulos?
    Afectaría infinitamente al usuario ya que no hay ninguna restricción en cuanto a la salud del usuario.   
-}

{-
    6) ¿Cómo se haría para representar que un usuario realiza un maratón de una serie 
    con una cantidad indeterminada de capítulos, pero indicando cuantos capítulos se 
    desea considerar?  
    Utilizando la función take en la lista infinita de capitulos, por ejemplo:
-}
listaInfinita = repeat breakingBad
listaCapitulos = take 3 listaInfinita
-- implementar maraton juan listaCapitulos

