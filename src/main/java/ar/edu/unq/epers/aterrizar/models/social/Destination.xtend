package ar.edu.unq.epers.aterrizar.models.social

import java.util.List
import ar.edu.unq.epers.aterrizar.models.user.SocialUser
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class Destination {
	String name
	List<Comment> comments
	List<String> likes
	List<String> dislikes
	Visibility visibility
	
	new(String name, Visibility visibility){
		this.name = name
		this.visibility = visibility
	}
	
	new(){
		
	}
	
	def like(String username){
		likes.add(username)
	}
	
	def dislike(String username){
		dislikes.add(username)
	}
	
	def addComment(Comment comment){
		this.comments.add(comment)
	}
	
}
