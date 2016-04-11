package ar.edu.unq.epers.aterrizar.persistence

import ar.edu.unq.epers.aterrizar.models.User
import org.hibernate.criterion.Restrictions

class UserHibernateRepo extends HibernateRepo{
	
	def deleteAllUsersInDB(){
		val hql = "delete from usuarios"
    	val query = SessionManager.getSession().createSQLQuery(hql)
    	query.executeUpdate()
	}

	def save(User u) {
		SessionManager.getSession().saveOrUpdate(u)
	}
}