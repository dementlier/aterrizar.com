package ar.edu.unq.epers.aterrizar.persistence

import ar.edu.unq.epers.aterrizar.models.User

class UserHibernateRepo extends HibernateRepo<User>{
	
	new(){
		super(User)
	}

}