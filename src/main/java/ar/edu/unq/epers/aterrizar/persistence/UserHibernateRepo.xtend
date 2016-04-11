package ar.edu.unq.epers.aterrizar.persistence

import ar.edu.unq.epers.aterrizar.models.User
import org.hibernate.criterion.Restrictions

class UserHibernateRepo {
	def get(int id){
		return SessionManager.getSession().get(typeof(User) ,id) as User
	}
	
	def get(String username){
		return SessionManager.getSession().createCriteria(typeof(User)).add(Restrictions.eq("username", username)).list().get(0) as User
	}
	
	def deleteAllUsersInDB(){
		val hql = String.format("delete from %s","usuarios");
    	val query = SessionManager.getSession().createQuery(hql)
    	query.executeUpdate();
	}

	def save(User u) {
		SessionManager.getSession().saveOrUpdate(u)
	}
}