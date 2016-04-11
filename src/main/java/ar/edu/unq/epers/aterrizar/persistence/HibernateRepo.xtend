package ar.edu.unq.epers.aterrizar.persistence

import org.hibernate.criterion.Restrictions

class HibernateRepo {
	def Object get(int id){
		return SessionManager.getSession().get(typeof(Object) ,id) as Object
	}
	
	def Object getBy(String field, String value){
		val list = SessionManager.getSession().createCriteria(typeof(Object)).add(Restrictions.eq(field, value)).list()
		var Object user = null
		if (list.size > 0){
			user = list.get(0) as Object
		}
		user
	}
}