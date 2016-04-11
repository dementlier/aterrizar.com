package ar.edu.unq.epers.aterrizar.persistence

import ar.edu.unq.epers.aterrizar.models.User
import org.hibernate.criterion.Restrictions

class UserHibernateRepo {
	def get(int id){
		return SessionManager.getSession().get(typeof(User) ,id) as User
	}
	
	def get(String username){
		val list = SessionManager.getSession().createCriteria(typeof(User)).add(Restrictions.eq("username", username)).list()
		var User user 
		if (list.size > 0){
			user = list.get(0) as User
		}else{
			user = null
		}
		user
	}
	
	def deleteAllUsersInDB(){
		val hql = "delete from usuarios"
    	val query = SessionManager.getSession().createSQLQuery(hql)
    	query.executeUpdate()
	}

	def save(User u) {
		SessionManager.getSession().saveOrUpdate(u)
	}
}