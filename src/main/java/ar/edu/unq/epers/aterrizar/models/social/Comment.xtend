package ar.edu.unq.epers.aterrizar.models.social

import ar.edu.unq.epers.aterrizar.models.user.SocialUser
import java.util.List

class Comment {
	String username
	String comment
	List<String> likes
	List<String> dislikes
	Visibility visibility
	
	def like(String username){
		likes.add(username)
	}
	
	def dislike(String username){
		dislikes.add(username)
	}
}