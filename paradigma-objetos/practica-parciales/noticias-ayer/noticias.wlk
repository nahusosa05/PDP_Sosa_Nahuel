class Noticia {
    var property fechaPublicacion = new Date()
    var property gradoImportancia
    var property titulo
    var property desarrollo

    method esCopada() {
        return gradoImportancia >= 8 && (new Date () - fechaPublicacion) < 3 and self.condicionCopada()
    }

    method condicionCopada() 

    method condicionSensacionalistaReportaje(palabrasPreferidas, reportadoPreferido) {
        return palabrasPreferidas.any({palabra => titulo.words().contains(palabra)})
    }

    method cantidadPalabrasDesarrollo() = desarrollo.words().size()

    method esChivo() = false

    method estaBienEscrita() {
        return titulo.words().size() >= 2 && !desarrollo.isEmpty()
    }

    method sePublicoEnLaUltimaSemana() {
        const hoy = new Date()
        return (hoy - fechaPublicacion) <= 7
    }
}

/* 
    PUNTO 1: Modelado de NOTICIA, ARTICULO, CHIVO, REPORTAJE y COBERTURA. 
             Implementación del método 'esCopado', para saber si una noticia es copada.
             Implementación del método 'condicionCopada', que implementa la condición de noticia copada según el estilo de Noticia.
*/
class Articulo inherits Noticia {
    const property links = []

    override method condicionCopada() {
        return links.size() >= 2
    }
}

class Chivo inherits Noticia {
    var property producto
    var property montoPagado

    override method condicionCopada() {
        return montoPagado > 2000000
    }

    override method esChivo() = true
}

class Reportaje inherits Noticia {
    var property reportado

    override method condicionCopada() {
        return reportado.size().odd()
    }

    override method condicionSensacionalistaReportaje(palabrasPreferidas, reportadoPreferido) {  
        return super(palabrasPreferidas, reportadoPreferido) && reportado == reportadoPreferido
    }
}

class Cobertura inherits Noticia {
    const property noticiasRelacionadas

    override method condicionCopada() {
        return noticiasRelacionadas.all({noticia => noticia.esCopada()})
    }
}

/* 
    PUNTO 2: Modelado de PERIODISTA, objetos de preferencia: noticiaCopada, sensacionalista, vago, joseDeZer.
             Implementación del método de la interfaz Preferencia 'esPreferida(noticia)' según la preferencia.
             Implementación de métodos en la clase Noticias para algunas comprobaciones de preferencias.
*/

class Periodista {
    var property fechaIngreso = new Date()
    var property preferencia
    const property noticiasPublicadas = []

    method esPreferida(noticia) = preferencia.esPreferida(noticia)

    /*
        PUNTO 3: Implementación del método 'publicar(noticia)' para que un periodista pueda publicar noticias bajo ciertas condiciones. 
    */
    method publicar(noticia) {
        self.validarPublicacion(noticia)
        noticiasPublicadas.add(noticia)
    }

    method validarPublicacion(noticia) {
        self.condicionPreferencia(noticia)
        self.condicionEscritura(noticia)
    }

    method condicionPreferencia(noticia) {
        if(!self.esPreferida(noticia) && self.verNoticiasPublicadasPreferidas()) {
            throw new DomainException(message = "El periodista no puede publicar mas de 2 noticias no preferidas.")
        }
    }

    method verNoticiasPublicadasPreferidas() {
        const contador = noticiasPublicadas.count({noticia => !self.esPreferida(noticia) && noticia.fechaPublicacion() == new Date()})
        return contador >= 2
    }

    method condicionEscritura(noticia) {
        if(!noticia.estaBienEscrita()) {
            throw new DomainException(message = "La noticia no está bien escrita.")
        }
    }

    method esReciente() {
        const haceUnAnio = new Date().minusYears(1)
        return fechaIngreso >= haceUnAnio
    }

    method publicoRecientemente() {
        return noticiasPublicadas.any({noticia => noticia.sePublicoEnLaUltimaSemana()})
    }
}

object noticiaCopada {
    method esPreferida(noticia) {
        return noticia.esCopada()
    }
}

object sensacionalista {
    var property palabrasPreferidas = ["espectacular", "increíble", "grandioso"]
    var property reportadoPreferido = "Dibu Martínez" 

    method esPreferida(noticia) {
        return noticia.condicionSensacionalistaReportaje(palabrasPreferidas, reportadoPreferido)
    }
}

object vago {
    method esPreferida(noticia) {
        return noticia.esChivo() || noticia.cantidadPalabrasDesarrollo() < 100
    }
}

object joseDeZer {
    method esPreferida(noticia) {
        return noticia.titulo().take(1) == "T" || noticia.titulo().take(1) == "t" 
    }
}

/*
    PUNTO 4: Modelado de objeto 'multimedio'.
             Implementación de método 'periodistasRecientes()'
*/

object multimedio {
    const property periodistas = [] 

    method periodistasRecientes() {
        return periodistas.filter({p => p.esReciente() && p.publicoRecientemente()})
    }
}