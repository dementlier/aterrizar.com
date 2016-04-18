package ar.edu.unq.epers.aterrizar.persistence

import org.hibernate.criterion.Restrictions

class HibernateRepo<T> {
	Class<T> entityType 
	
	new(Class<T>  entityType){
		this.entityType = entityType
	}
	
	def T get(int id){
		return SessionManager.getSession().get(entityType ,id) as T
	}
	
	def T getBy(String field, String value){
		val list = SessionManager.getSession().createCriteria(entityType).add(Restrictions.eq(field, value)).list()
		var T instance = null
		if (list.size > 0){
			instance = list.get(0) as T
		}
		instance
	}
	
	def deleteAllInDB(String tableName){
		val hql = String.format("delete from %s", tableName)
		val query = SessionManager.getSession().createSQLQuery(hql)
		query.executeUpdate()
	}
	
	def deleteAll(){
		val query = SessionManager.getSession().createSQLQuery("TRUNCATE SCHEMA PUBLIC RESTART IDENTITY AND COMMIT NO CHECK")
		query.executeUpdate()
	}
	
	def save(T algo) {
		SessionManager.getSession().saveOrUpdate(algo)
	}
}