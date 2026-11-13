class Plato {
    var property cocinero

    method cantidadAzucar()
    method bienDecorada()
    
    // Punto 1: Calorías calculadas con el mensajePolimórfico cantidadAzucar()
    method calorias() = 3 * self.cantidadAzucar() + 100
}

class Entrada inherits Plato {
    override method cantidadAzucar() = 0
    override method bienDecorada() = true
}

class Principal inherits Plato {
    var property cantidadAzucar
    var property bienDecorada

    override method cantidadAzucar() = cantidadAzucar.max(0)
    override method bienDecorada() = bienDecorada
}

class Postre inherits Plato {
    var property cantColores

    override method cantidadAzucar() = 120
    override method bienDecorada() = cantColores > 3
}

// --- COCINERO Y ESPECIALIDADES ---

class Cocinero {
    var property especialidad

    // Punto 2: catar un plato devuelve el puntaje del plato, max 10.
    method catar(unPlato) = especialidad.degustacion(unPlato)

    // Punto 4: Cocinar delega en la especialidad y se asigna como creador
    method cocinar() {
        const nuevoPlato = especialidad.cocinar(self)
        return nuevoPlato
    }
}

class Repostero {
    var property cantDulceEsperada

    // Punto 2: catar un plato devuelve el puntaje del plato, max 10.
    method degustacion(plato) {
        return (5 * plato.cantidadAzucar() / cantDulceEsperada).min(10)
    }

    method cocinar(cocinero) {
        return new Postre(cocinero = cocinero, cantColores = cantDulceEsperada / 50)
    }
}

class Chef {
    var property cantMaximaCalorias

    method cumpleExpectativas(plato) {
        return plato.bienDecorada() && plato.calorias() <= cantMaximaCalorias
    }

    method calificacionCuandoNoCumpleExpectativas(plato) = 0

    // Punto 2: catar un plato devuelve el puntaje del plato, max 10.
    method degustacion(plato) {
        if (self.cumpleExpectativas(plato)) {
            return 10
        } else {
            return self.calificacionCuandoNoCumpleExpectativas(plato)
        }
    }

    method cocinar(cocinero) {
        return new Principal(cocinero = cocinero, cantidadAzucar = cantMaximaCalorias, bienDecorada = true)
    }
}

// Punto 3: Especialidad garde manger
class GardeManger inherits Chef {
    // Punto 2: catar un plato devuelve el puntaje del plato, max 10.
    override method calificacionCuandoNoCumpleExpectativas(plato) {
        return (plato.calorias() / 100).min(6)
    }

    override method cocinar(cocinero) {
        return new Entrada(cocinero = cocinero)
    }
}

// --- TORNEO ---

class Torneo {
    const property catadores = []
    const property platosPaticipantes = []

    // Punto 5.a: Que un cocinero participe en el Torneo.
    method hacerPaticipar(cocinero) {
        const platoPresentado = cocinero.cocinar()
        platosPaticipantes.add(platoPresentado)
    }

    // función auxiliar de 5.b
    method puntajePlato(plato) {
        return catadores.sum({ catador => catador.catar(plato) })
    }

    // Punto 5.b: Si la colección está vacía lanza excepción
    method ganador() {
        if (platosPaticipantes.isEmpty()) {
            throw new DomainException(message = "No se presentó ningún cocinero al torneo")
        }
        const platoGanador = platosPaticipantes.max({ plato => self.puntajePlato(plato) })
        return platoGanador.cocinero()
    }
}