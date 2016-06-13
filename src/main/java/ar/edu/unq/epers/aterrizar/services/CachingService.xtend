package ar.edu.unq.epers.aterrizar.services

import ar.edu.unq.epers.aterrizar.persistence.CassandraRepo
import ar.edu.unq.epers.aterrizar.models.social.Visibility
import ar.edu.unq.epers.aterrizar.models.user.CachedUser
import ar.edu.unq.epers.aterrizar.models.user.SocialUser

class CachingService {
	CassandraRepo repo
	
	new(){
		repo = new CassandraRepo
	}
	
	def save(CachedUser user){
		repo.save(user)
	}
	
	def get(String username, Visibility visibility){
		repo.get(username, visibility)
	}
	
	def deleteUser(SocialUser user){
		repo.deleteUser(user)
	}
	
	
}