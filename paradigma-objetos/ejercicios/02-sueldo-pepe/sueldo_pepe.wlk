/*
 * ============================================================================
 * OBJETO PEPE: Orquestador y cálculo dinámico
 * ============================================================================
 * - No almacena el sueldo en una variable para evitar inconsistencias de estado.
 * - Conoce sus partes y DELEGA cada cálculo en los objetos correspondientes.
 */
object pepe {
    // Referencias mutables: permiten cambiar de categoría o bonos en tiempo de ejecución
    var categoria = cadete
    var cantFaltas = 3
    var bonoPresentismo = bonoDependeDeFaltas
    var bonoResultado = bonoFijo

    // Setters: necesarios para configurar a Pepe en diferentes escenarios de prueba
    method categoria(unaCategoria) { categoria = unaCategoria }
    method cantFaltas(unasFaltas) { cantFaltas = unasFaltas }
    method bonoPresentismo(unBono) { bonoPresentismo = unBono }
    method bonoResultado(unBono) { bonoResultado = unBono }

    // Consulta: Pepe no fija su sueldo básico, le delega a su categoría actual saber su neto
    method neto() = categoria.neto()

    /*
     * SUELDO: Se calcula a demanda combinando los resultados delegados.
     * 1. bonoResultado: espera un valor monetario (su sueldo neto).
     * 2. bonoPresentismo: espera una cantidad numérica de días ausentes.
     * Menor acoplamiento: solo enviamos el dato necesario, no al empleado entero.
     */
    method sueldo() {
        return self.neto() + 
               bonoResultado.monto(self.neto()) + 
               bonoPresentismo.monto(cantFaltas)
    }
}

/*
 * ============================================================================
 * FAMILIA BONOS DE PRESENTISMO
 * ============================================================================
 * Interfaz común: todos entienden monto(faltas).
 * Permiten que Pepe calcule su adicional sin hacer ifs sobre qué bono tiene asignado.
 */
object bonoDependeDeFaltas {
    // Evalúa tramos escalonados según las ausencias recibidas por parámetro
    method monto(faltas) {
        if (faltas == 0) return 1000
        if (faltas == 1) return 500
        return 0
    }
}

object bonoIndependienteDeFaltas {
    // Caso de presentismo nulo: respeta la misma interfaz ignorando el parámetro con _
    method monto(_) = 0
}

/*
 * ============================================================================
 * FAMILIA BONOS POR RESULTADO (Implementan la interfaz conceptual Bono)
 * ============================================================================
 * Interfaz común: todos entienden monto(valor).
 * Son polimórficos entre sí: Pepe los trata de forma idéntica pasándoles el neto.
 */
object bonoPorcentaje {
    // Aplica el porcentaje variable sobre el importe recibido
    method monto(neto) = neto * 0.10
}

object bonoFijo {
    // Devuelve una constante; usa '_' porque no necesita el monto base para calcularse
    method monto(_) = 800
}

object bonoNulo {
    // Objeto Neutro / Null Object: evita chequear con ifs si el empleado tiene bono o no
    method monto(_) = 0
}

/*
 * ============================================================================
 * FAMILIA DE CATEGORÍAS
 * ============================================================================
 * Interfaz común: todas entienden neto().
 * Si mañana se agrega una categoría 'gerenteSenior', solo creamos un nuevo objeto
 * sin modificar una sola línea de código del objeto pepe.
 */
object gerente {
    method neto() = 10000
}

object cadete {
    method neto() = 15000
}