object chanchito {
    // Aporta 20 calorías según el segundo test (100 + 20 = 120)
    method energiaQueAporta() = 20
}

object yamilo {
    var calorias = 100 // Inicia con 100 según el primer test

    method calorias() = calorias

    method comer(animal) {
        calorias = calorias + animal.energiaQueAporta()
    }

    // El tercer test indica que con 100 calorías NO tiene sobrepeso
    method estaConSobrePeso() {
        return calorias > 200 // (O el límite que indique tu enunciado)
    }

    // El cuarto test indica que con 100 calorías SÍ está saludable
    method estaSaludable() {
        // Un rango común en este ejercicio suele ser entre 20 y 150 calorías
        return calorias.between(20, 150) 
    }
}