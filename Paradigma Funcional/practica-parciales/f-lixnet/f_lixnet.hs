{- HLINT ignore "Eta reduce" -}
data Movie = Movie {
    title :: String, 
    genre :: String,
    duration :: Int,
    origin :: String
} deriving Show

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

seeMovie :: Movie -> User -> User
seeMovie movie user = user {
    sawMovies = sawMovies user ++ [movie]
}

notMoviesFrom :: String -> [Movie] -> [Movie]
notMoviesFrom country movies = filter ((country /=) . origin) movies
 
conditionsComplete :: User -> Bool
conditionsComplete user = (>20) . length . notMoviesFrom "Estados Unidos" . sawMovies $ user

upgradeCategory :: User -> User
upgradeCategory user = user {
    category = newCategory . category $ user
}

newCategory :: String -> String
newCategory "Basic" = "Standard"
newCategory _ = "Premium"
            
rewardUser :: User -> User
rewardUser user | conditionsComplete user = upgradeCategory user
                | otherwise = user

reward :: [User] -> [User]
reward users = map rewardUser users