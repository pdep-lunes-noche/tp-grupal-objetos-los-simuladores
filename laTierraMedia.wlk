object baculo {
    var property poderBase = 250

    method poderOtorgado(unGuerrero) {
        var poder = poderBase

        if (unGuerrero.tienePocaVida()) {
            poder = poderBase * 2
        }

        if (poder > 400) {
            poder = 400
        }

        return poder
    }

    method pasarDia() {
    }
}

object espada {
    var magia = magiaElfica

    method poderOtorgado(unGuerrero) {
        return magia.poderOtorgado(unGuerrero) * 10
    }

    method cambiarMagia(nuevaMagia) {
        magia = nuevaMagia
    }

    method pasarDia() {
    }
}

object magiaElfica {
    method poderOtorgado(unGuerrero) {
        return 25
    }
}

object magiaEnana {
    method poderOtorgado(unGuerrero) {
        return unGuerrero.vida() / 2
    }
}

object flechaBronce {
    var poder = 100

    method poderOtorgado(unGuerrero) {
        return poder
    }

    method pasarDia() {
        poder = (poder - 1).max(0)
    }

    method lustrar() {
        poder = 100
    }

}

object flechaAluminio {
    var poder = 50

    method poderOtorgado(unGuerrero) {
        return poder
    }

    method pasarDia() {
    }
}


object flechaHierro {
    var property oxidada = false

    method poderOtorgado(unGuerrero) {
        var poder = 70

        if (oxidada) {
            poder = poder / 2
        }

        return poder
    }

    method pasarDia() {
    }
}

object cajaFlechas {
    var flechas = [flechaAluminio, flechaHierro, flechaBronce]

    method poderOtorgado(unGuerrero) {
        var flechasImportantes = flechas.filter({ flecha => flecha.poderOtorgado(unGuerrero) > 50 })

        return flechasImportantes.sum({ flecha => flecha.poderOtorgado(unGuerrero) }) / flechasImportantes.size()
    }

    method pasarDia() {
        flechas.forEach({ flecha => flecha.pasarDia()})
    }
}


class Gandalf {
    var property vidaActual = 100
    var property armas = [baculo, espada]
    var property caja = cajaFlechas

    method vida() {
        return vidaActual
    }

    method tienePocaVida() {
        return vidaActual < 10
    }

    method poder() {
        var multiplicadorDeVida = 15

        if (self.tienePocaVida()) {
            multiplicadorDeVida = 200
        }

        var poderArmas = armas.sum({
            arma => arma.poderOtorgado(self)
        })

        poderArmas += caja.poderOtorgado(self)

        return vidaActual * multiplicadorDeVida + poderArmas * 2
    }

    method cantidadDeArmas() {
        return armas.size()
    }

    method estaArmado() {
        return armas.size() > 0
    }

    method pasarDia() {
        armas.forEach({ arma => arma.pasarDia() })
    }

    method perderVida(cantidad) {
        vidaActual -= cantidad
    }

    method ganarVida(cantidad) {
        vidaActual += cantidad
    }
}

object lebennin {
    var cantidadGuardias = 3
    var poderMinimoParaPasar = 1000

    method puedePasar(unGuerrero) {
        if (cantidadGuardias > 3) {
            poderMinimoParaPasar = 1500
        }

        return unGuerrero.poder() > poderMinimoParaPasar
    }
    method consecuencia (unGuerrero){

    }
}


object minasTirith {
    method puedePasar(unGuerrero) {
        return unGuerrero.estaArmado()
    }
    

    method consecuencia(unGuerrero) {
        if (self.puedePasar(unGuerrero)) {
            unGuerrero.perderVida(
                unGuerrero.cantidadDeArmas() * 10
            )
        }
    }
}


object lossarnach {
    method puedePasar(unGuerrero) {
        return true
    }

    method consecuencia(unGuerrero) {
        unGuerrero.ganarVida(
            unGuerrero.cantidadDeArmas() * 2
        )
    }
}

object caminoDeGondor {
    var recorrido = [lebennin, minasTirith]

    method puedeRecorrer(unGuerrero) {
        return recorrido.all({
            lugar => lugar.puedePasar(unGuerrero)
        })
    }

    method consecuencia(unGuerrero) {
        if (self.puedeRecorrer(unGuerrero)) {
            recorrido.forEach({
                lugar => lugar.consecuencia(unGuerrero)
            })
        }
    }

    method cambiarRecorrido(nuevoRecorrido) {
        recorrido = nuevoRecorrido
    }
}

object tomBombadil {
    var vidaActual = 100

    method vida() {
        return vidaActual
    }

    method tienePocaVida() {
        return vidaActual < 10
    }

    method poder() {
        return 2000
    }

    method cantidadDeArmas() {
        return 100
    }

    method estaArmado() {
        return true
    }

    method perderVida(cantidad) {

    }

    method ganarVida(cantidad) {
        vidaActual += cantidad
    }
}