package ar.edu.unq.epers.aterrizar.utils

import org.eclipse.xtend.lib.annotations.Data


@Data
class Mail {
    String body
    String subject
    String to
    String from
}