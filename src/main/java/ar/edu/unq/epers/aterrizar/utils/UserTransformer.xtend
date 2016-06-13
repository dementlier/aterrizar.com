package ar.edu.unq.epers.aterrizar.utils

import ar.edu.unq.epers.aterrizar.models.user.SocialUser
import ar.edu.unq.epers.aterrizar.models.user.User
import ar.edu.unq.epers.aterrizar.models.user.FriendableUser
import ar.edu.unq.epers.aterrizar.models.user.CachedUser

class UserTransformer {
	
	def static toUser(SocialUser user){
		var newUser = new User => [
			username	= user.username
		]
		newUser
	}
	
	def static toUser(FriendableUser user){
		var newUser = new User => [
			username	= user.username
		]
		newUser
	}
	
	def static toUser(String user){
		var newUser = new User => [
			username = user
		]
		newUser
	}
	
}