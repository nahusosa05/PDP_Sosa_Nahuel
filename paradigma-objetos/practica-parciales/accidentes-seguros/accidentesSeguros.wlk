class Vehiculo {
    var property poliza
    const property siniestros = []

    method cuantoCubrePolizaEn(siniestro) {
        poliza.cuantoCubreEn(siniestro, self)
    }

    method montoNoCubiertoEnSiniestros() {
        return siniestros.sum({siniestro => poliza.montoNoCubierto(siniestro, self)})
    }

    method agregarSiniestro(siniestro) {
        siniestros.add(siniestro)
    }
}

class Siniestro {
    const property danios = []

    method participo(vehiculo) {
        danios.any({danio => danio.afectado() == vehiculo})
    }

    method daniosExceptoVehiculo(vehiculo) {
        return danios.filter({danio => danio.afectado() != vehiculo})
    }

    method danioPara(vehiculo) {
        return danios.find({danio => (danio.afectado() == vehiculo)}).monto()
    }
}

class Danio {
    var property afectado
    var property monto
}

class Poliza {
    var property aseguradora

    method danios(siniestro, vehiculo)

    method cuantoCubreEn(siniestro, vehiculo) {
        return self.danios(siniestro, vehiculo).sum({danio => danio.monto()})
    }

    method montoNoCubierto(siniestro, vehiculo)
}

class ContraTerceros inherits Poliza {
    override method danios(siniestro, vehiculo) {
        return siniestro.daniosExceptoVehiculo(vehiculo)
    }

    override method montoNoCubierto(siniestro, vehiculo) = siniestro.danioPara(vehiculo)
}

class ContraTodoRiesgo inherits Poliza {
    override method danios(siniestro, vehiculo) {
        return siniestro.danios()
    }

    override method montoNoCubierto(siniestro, vehiculo) = 0
}

class Aseguradora {
    method cuantoPagarPor(siniestro, vehiculo) {
        self.validarVehiculo(siniestro, vehiculo)
        return vehiculo.cuantoCubrePolizaEn(siniestro)
    }

    method validarVehiculo(siniestro, vehiculo) {
        if (!siniestro.participo(vehiculo)) {
            throw new NoParticipoVehiculo (message = "El vehiculo no estuvo involucrado")
        }
    }
}

class NoParticipoVehiculo inherits DomainException {}