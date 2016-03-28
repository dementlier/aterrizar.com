package ar.edu.unq.epers.aterrizar.utils

import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class EnviarMailException extends Exception {
    Mail mail
}