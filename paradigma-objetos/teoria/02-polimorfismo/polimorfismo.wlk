/*
    Polimorfismo: 
    2 objetos son polimórficos a la vista de un tercero porque puede enviar el mismo mensaje sin
    importar cómo estén implementados los métodos. Requieren una interfaz.

    - Los 2 objetos que comparten cierta interaz en común son polimórficos para ese observador.

    - En las interfaces se especifíca que se debe hacer y no cómo lo implementa el objeto.

    ¿Quién tiene la responsabilidad de hacer algo?
    En los objetos SIEMPRE tenemos que decidir a quién le eviamos el mensaje. Marcar bien la responsabilidad
    de los objetos.

    En objetos los atributos son privados. 

    - Acoplamiento
*/

object galvan {
    const sueldo = 15000

    method sueldo() = sueldo
}

object baigorria {
    var cantidadEmpanadasVendidas = 100
    const montoPorEmpanada = 15

    method venderEmpanada() {
        cantidadEmpanadasVendidas = cantidadEmpanadasVendidas + 1
    }

    method sueldo() = cantidadEmpanadasVendidas * montoPorEmpanada
}

object negocio {
    var disponible = 50000

    method pagarA(empleado) {
        disponible = disponible - empleado.sueldo()
    }

    method disponible() = disponible
}