/*
 ==============================================================================
 1. PROPERTY (AZÚCAR SINTÁCTICO PARA ACCESORS)
 ==============================================================================
 Evita escribir manualmente los métodos de acceso triviales (getters y setters).
 - var property x = valor   --> Genera getter 'x()' y setter 'x(nuevoValor)'.
 - const property x = valor --> Genera únicamente el getter 'x()'.
*/

object raton {
    var property velocidad = 1       // Crea velocidad() y velocidad(valor)
    const property peso = 5          // Crea sólo peso() (inmutable)

    /*
     * CUIDADO con la sintaxis "funcionalosa":
     * - method peso() = 5       --> Retorna el número 5.
     * - method peso() { return 5 } --> Retorna el número 5.
     * - method peso() = { return 5 } --> ¡ERROR COMÚN! Retorna un BLOQUE, no el 5.
     */
}

/*
 ==============================================================================
 2. BLOQUES DE CÓDIGO (OBJETOS QUE ENCAPSULAN COMPORTAMIENTO)
 ==============================================================================
 Un bloque es un objeto análogo a una función lambda o clausura (closure):
 - Conoce y recuerda el contexto donde fue creado.
 - No se evalúa al instanciarse; se ejecuta explícitamente con '.apply(...)'.
 - Sintaxis: { param1, param2 => cuerpo }
*/

object demoBloques {
    method ejemplos() {
        // Bloque con 1 parámetro
        const saludo = "Hola"
        const saludar = { nombre => saludo + " " + nombre }
        saludar.apply("Pepita") // Devuelve "Hola Pepita"

        // Bloque con 2 parámetros
        const sumar = { a, b => a + b }
        sumar.apply(5, 6) // Devuelve 11

        // Repetir N veces una acción
        3.times({ _ => raton.velocidad(raton.velocidad() + 1) })
    }
}

/*
 ==============================================================================
 3. MODELADO DE COLECCIONES (List vs Set)
 ==============================================================================
 Las colecciones son objetos que almacenan referencias a otros objetos.
 BUENA PRÁCTICA: Declarar las referencias con 'const' para que el objeto siempre
 apunte a la misma colección, aunque la colección mute internamente (agregando/quitando).
*/

object demoColecciones {
    // List: ordenadas por índice, permiten elementos duplicados
    const animalesLista = [] 

    // Set: no tienen índice ni orden, no admiten repetidos
    // const animalesSet = #{}

    method mutarColeccion(unAnimal) {
        animalesLista.add(unAnimal)       // Agrega elemento
        animalesLista.remove(unAnimal)    // Quita una aparición
        animalesLista.contains(unAnimal)  // Consulta existencia (true/false)
        animalesLista.size()              // Cantidad de elementos
    }
}

/*
 ==============================================================================
 4. MENSAJES DE COLECCIONES (CONSULTA VS ACCIÓN)
 ==============================================================================
*/

// Objetos polimórficos de prueba para entender las operaciones
object vaca   { method peso() = 400; method tieneHambre() = true;  method comer(g) {} }
object gallina{ method peso() = 4;   method tieneHambre() = false; method comer(g) {} }
object cerdo  { method peso() = 120; method tieneHambre() = true;  method comer(g) {} }

object granja {
    const property animales = [vaca, gallina, cerdo]

    // --- ACCIÓN / EFECTO COLATERAL ---
    // forEach: NO es de consulta. Itera produciendo efectos colaterales sobre cada objeto.
    method alimentarATodos(gramos) {
        animales.forEach({ animal => animal.comer(gramos) })
    }

    // --- CONSULTAS ELEMENTALES ---
    // find: Retorna el PRIMER elemento que cumple la condición. Explota si no hay ninguno.
    method algunPesado() = animales.find({ a => a.peso() > 250 })

    // max: Retorna el elemento que maximiza el criterio numérico del bloque.
    method elMasPesado() = animales.max({ a => a.peso() })

    // all / any: Consultas booleanas sobre el conjunto.
    method todosTienenHambre() = animales.all({ a => a.tieneHambre() })
    method algunoPesaMasDe(kg) = animales.any({ a => a.peso() > kg })

    // --- TRANSFORMACIÓN Y FILTRADO (RETORNAN UNA NUEVA COLECCIÓN) ---
    // filter: Retorna un subconjunto con los elementos que cumplen la condición booleana.
    method losHambrientos() = animales.filter({ a => a.tieneHambre() })

    // map: Proyecta o transforma cada elemento en un nuevo valor, retornando la nueva lista.
    method pesosDeTodos() = animales.map({ a => a.peso() })

    // --- REDUCCIÓN / AGREGACIÓN ---
    // sum: Suma los resultados numéricos del bloque directamente.
    method pesoTotal() = animales.sum({ a => a.peso() })

    // fold: Reducción general con acumulador inicial (análogo a foldl de Haskell).
    method pesoTotalConFold() {
        return animales.fold(0, { acum, a => acum + a.peso() })
    }
}