package ar.edu.unq.epers.aterrizar.models.social

import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors
import java.util.ArrayList

@Accessors
class Comment {
	int id
	String username
	String comment
	List<String> likes
	List<String> dislikes
	Visibility visibility
	
	new(String username, String comment){
		this.username = username
		this.comment = comment
		this.id = (username+comment).hashCode
		this.likes = new ArrayList<String>
		this.dislikes = new ArrayList<String>
	}
	
	new(){
		this.likes = new ArrayList<String>
		this.dislikes = new ArrayList<String>
	}
	
	def like(String username){
		likes.add(username)
	}
	
	def dislike(String username){
		dislikes.add(username)
	}
}