object sara {
    var peso = 55
    var vitalidad = 90
    var temperatura = 37

    // getters
    method peso() = peso
    method vitalidad() = vitalidad
    method temperatura() = temperatura

    // setters 
    method peso(cantidad) {
        peso = cantidad
    }

    method vitalidad(cantidad) {
        vitalidad = cantidad
    }

    method temperatura(cantidad) {
        temperatura = cantidad
    }

    // comportamientos
    method esAfectadaPor(enfermedad) {
        enfermedad.afectar(self)
    }

    method modificarTemperatura(cantidad) {
        temperatura += cantidad
    }

    method modificarPeso(cantidad) {
        peso += cantidad
    }

    method temperaturaNormal() {
        temperatura = 37
    }
}

object malaria {
    method afectar(persona) {
        persona.aumentarTemperatura(3)
    } 
}
//
/*
El cambio de temperatura es algo de la persona, no de la enfermedad. En este caso, corresponde delegar
la modificación de la temperatura a sara.

object malaria {
    method afectar(persona) {
        persona.temperatura(persona.temperatura() + 3)
    } 
}*/


object varicela {
    method afectar(persona) {
        persona.modificarVitalidad(5)
        persona.modificarPeso(-persona.peso() * 0.10)
    } 
}

object gripe {
    method afectar(persona) {
        persona.modificarVitalidad(-persona.vitalidad() * 0.2)
    }
}

object paracetamol {
    method afectar(persona) {
        if(persona.temperatura() > 37) {
            persona.temperaturaNormal()
        } 
    }
}

object polen {
    const gramos = 10

    method afectar(persona) {
        persona.modificarVitalidad(gramos * 0.1)
    }
}

object nuez {
    method afectar(persona) {
        persona.modificarVitalidad(persona.vitalidad() * 0.3)
    }
}