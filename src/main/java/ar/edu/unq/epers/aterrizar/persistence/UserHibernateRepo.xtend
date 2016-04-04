package ar.edu.unq.epers.aterrizar.persistence

import ar.edu.unq.epers.aterrizar.models.User

class UserHibernateRepo {
		def get(int id){
		return SessionManager.getSession().get(typeof(User) ,id) as User
	}

	def save(User u) {
		SessionManager.getSession().saveOrUpdate(u)
	}
}