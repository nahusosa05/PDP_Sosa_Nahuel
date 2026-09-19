/*
 ==============================================================================
 GUÍA TEÓRICA 01: FUNDAMENTOS DEL PARADIGMA ORIENTADO A OBJETOS
 ==============================================================================
 Ejes:
 1. Estado, Identidad y Encapsulamiento
 2. Mensajes: Acción (efecto colateral) vs. Consulta
 3. Responsabilidad y Delegación
 4. Autorreferencia (self)
 5. Polimorfismo
*/

/*
 ------------------------------------------------------------------------------
 1. ESTADO, IDENTIDAD Y ENCAPSULAMIENTO
 ------------------------------------------------------------------------------
 - Un objeto tiene identidad única, estado interno (atributos) y comportamiento.
 - 'var': referencia mutable.
 - 'const': referencia inmutable (no puede apuntar a otro valor).
 - Encapsulamiento: Las variables son privadas. Solo se accede o modifica 
   su valor si el propio objeto expone un método para ello.
*/

object lampara {
    var encendida = false
    const potenciaWatts = 60

    // Consulta: no altera variables, devuelve un valor
    method estaEncendida() = encendida
    method potencia() = potenciaWatts

    // Acción: altera variables, no retorna nada
    method encender() {
        encendida = true
    }

    method apagar() {
        encendida = false
    }
}

/*
 ------------------------------------------------------------------------------
 2. RESPONSABILIDAD, DELEGACIÓN Y 'self'
 ------------------------------------------------------------------------------
 - Delegación: Un objeto no debe calcular ni manipular datos ajenos desde 
   afuera; le pide al dueño del dato que haga la tarea.
 - 'self': Referencia al propio objeto que ejecuta el método. Permite llamarse
   a sí mismo o pasarse como argumento a un tercero.
*/

object celular {
    var bateria = 100

    method bateria() = bateria

    // Buen diseño: el celular es el único que modifica su propia batería
    method consumirBateria(porcentaje) {
        bateria = (bateria - porcentaje).max(0)
    }

    // self para invocar una consulta interna
    method tieneBateriaBaja() = self.bateria() < 20

    // self como parámetro (se pasa a sí mismo al cargador)
    method conectar(unCargador) {
        unCargador.cargar(self)
    }
}

/*
 ------------------------------------------------------------------------------
 3. POLIMORFISMO
 ------------------------------------------------------------------------------
 Existe cuando dos o más objetos entienden un MISMO conjunto de mensajes 
 (comparten interfaz), permitiendo que un tercero los utilice de manera 
 transparente sin verificar qué objeto específico son.
*/

// Ambos cargadores son polimórficos respecto al celular: entienden cargar(dispositivo)
object cargadorRapido {
    method cargar(dispositivo) {
        dispositivo.consumirBateria(-50) // Aumenta 50
    }
}

object cargadorSolar {
    method cargar(dispositivo) {
        dispositivo.consumirBateria(-10) // Aumenta 10
    }
}

// Ejemplo de consumidor polimórfico:
// usuario puede usar cargadorRapido o cargadorSolar sin condicionales (if)
object usuario {
    method prepararTelefono(unCargador) {
        celular.conectar(unCargador)
    }
}