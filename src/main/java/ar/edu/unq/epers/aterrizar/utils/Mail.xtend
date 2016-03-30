package ar.edu.unq.epers.aterrizar.utils

import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class Mail {

	String body
	String subject
	String to
	String from

	new(String body, String subject, String to, String from) {
		this.body = body
		this.subject = subject
		this.to = to
		this.from = from
	}

	override boolean equals(Object o) {
		val m = o as Mail
		this.body == m.getBody() && this.subject == m.getSubject() && this.to == m.getTo() && this.from == m.getFrom()
	}

}
