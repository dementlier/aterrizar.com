package ar.edu.unq.epers.aterrizar.exceptions

import org.eclipse.xtend.lib.annotations.Accessors
import ar.edu.unq.epers.aterrizar.utils.Mail

@Accessors
class EnviarMailException extends Exception {
	Mail mail
}
