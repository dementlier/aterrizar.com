package ar.edu.unq.epers.aterrizar.utils

import ar.edu.unq.epers.aterrizar.models.user.SocialUser
import ar.edu.unq.epers.aterrizar.models.user.User
import ar.edu.unq.epers.aterrizar.models.user.FriendableUser

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
	
	def static toSocialUser(User user){
		var newSocialUser = new SocialUser(user.username)
		newSocialUser
	}
}