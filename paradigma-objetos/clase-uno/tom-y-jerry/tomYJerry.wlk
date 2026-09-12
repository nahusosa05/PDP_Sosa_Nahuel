object tom {
    var energia = 20
    var posicion = 30

    // versión larga de métodos
    method puedeAtrapar(unAnimal) {
        return self.velocidad() > unAnimal.velocidad()
    }

    method velocidad() {
        return 5 + (energia / 10)
    }

    method energia(cantidad) {
        energia = cantidad
    }

    method correr(unAnimal) {
        energia -= self.tiempoAlcanzar(unAnimal)
        posicion = unAnimal.posicion()
    }

    method tiempoAlcanzar(unAnimal) {
        return 0.5 * self.velocidad() *self.distancia(unAnimal)
    }

    method distancia(unAnimal) {
        return (posicion - unAnimal.posicion()).abs()
    }

    method posicion() = posicion
    method energia() = energia
}

object jerry {
    const peso = 4
    const posicion = 34

    // versión corta de métodos
    method velocidad() = 10 - peso

    method posicion() = posicion

}

object robotRaton {
    const velocidad = 8
    const posicion = 35

    method velocidad() = velocidad
    method posicion() = posicion
}