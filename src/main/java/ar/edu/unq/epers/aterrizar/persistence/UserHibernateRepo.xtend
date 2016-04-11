package ar.edu.unq.epers.aterrizar.persistence

import ar.edu.unq.epers.aterrizar.models.User
import org.hibernate.criterion.Restrictions

class UserHibernateRepo extends HibernateRepo<User>{
	
	new(){
		super(User)
	}

}