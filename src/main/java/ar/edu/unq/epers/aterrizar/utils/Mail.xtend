package ar.edu.unq.epers.aterrizar.utils

import org.eclipse.xtend.lib.annotations.Data



class Mail {
    String body
    String subject
    String to
    String from


		new(String body, String subject, String to, String from){
			this.body = body
			this.subject = subject
			this.to = to
			this.from = from
		}

	}