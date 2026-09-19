/*
 * ============================================================================
 * ENTRENADOR ASH
 * ============================================================================
 */

object ash {
    const property pokebola = []

    method capturar(unPokemon) { pokebola.add(unPokemon) }

    // all: verifica si TODOS los elementos de la colección cumplen la condición
    method esGroso() {
        return pokebola.all({ p => p.nivel() > 100 })
    }

    // max: retorna el OBJETO de la colección que maximiza la expresión del bloque
    method pokemonPreferido() {
        return pokebola.max({ p => p.potenciaMaxima() })
    }

    // filter: devuelve una NUEVA sub-colección con los que cumplen la condición
    method pokemonesPulenta() {
        return pokebola.filter({ p => p.esPulenta() })
    }
}

/*
 * ============================================================================
 * POKEMONES
 * ============================================================================
 * Cada uno maneja sus ataques de forma distinta, pero comparten la interfaz:
 * - aprenderAtaque(nuevoAtaque)
 * - potencia()
 */
object charizard {
    var ataque = lanzaLlamas

    method aprenderAtaque(nuevoAtaque) { ataque = nuevoAtaque }

    // Su nivel es la potencia de su único ataque
    method nivel() = ataque.potencia()

    // Como tiene uno solo, su ataque más potente es ese mismo
    method potenciaMaxima() = ataque.potencia()

    // Solo sabe 1 ataque, nunca supera los 2
    method esPulenta() = false
}

object pikachu {
    const ataques = [agilidad, trueno, colaDeHierro]

    method aprenderAtaque(nuevoAtaque) { ataques.add(nuevoAtaque) }

    // sum: sumatoria de la potencia de todos sus ataques
    method nivel() = ataques.sum({ a => a.potencia() })

    // max: busca el ataque con mayor potencia y consulta su valor
    method potenciaMaxima() {
        return if (ataques.isEmpty()) 0 else ataques.max({ a => a.potencia() }).potencia()
    }

    // size(): verifica si la cantidad de ataques supera 2
    method esPulenta() = ataques.size() > 2
}

object psyduck {
    method aprenderAtaque(nuevoAtaque) {}

    // No tiene ataques: nivel y potencia máxima son 0
    method nivel() = 0
    method potenciaMaxima() = 0
    method esPulenta() = false
}

object blastoise {
    var ataquePrincipal = hidrobomba
    var ataqueReserva = rayoDeHielo

    method aprenderAtaque(nuevoAtaque) {
        ataqueReserva = ataquePrincipal
        ataquePrincipal = nuevoAtaque
    }

    // Suma la potencia de sus dos ataques actuales
    method nivel() = ataquePrincipal.potencia() + ataqueReserva.potencia()

    // Devuelve la potencia del mayor entre los dos que tiene
    method potenciaMaxima() = ataquePrincipal.potencia().max(ataqueReserva.potencia())

    // Nunca tiene más de 2 ataques
    method esPulenta() = false
}

/*
 * ============================================================================
 * MODELADO DE ATAQUES
 * ============================================================================
 * Interfaz común: todos entienden potencia().
 */

object lanzaLlamas {
    method potencia() = 5
}

object agilidad {
    method potencia() = 2
}

object trueno {
    method potencia() = 10
}

object colaDeHierro {
    method potencia() = 8
}

object hidrobomba {
    var property potencia = 10 
}

object rayoDeHielo {
    method potencia() = 1
}