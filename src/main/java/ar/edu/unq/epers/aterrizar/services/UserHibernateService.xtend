package ar.edu.unq.epers.aterrizar.services

import ar.edu.unq.epers.aterrizar.persistence.SessionManager
import ar.edu.unq.epers.aterrizar.persistence.UserHibernateRepo

class UserHibernateService {
	def consultarUser(int id) {
		SessionManager.runInSession([
			new UserHibernateRepo().get(id)
		])
	}
	
}
