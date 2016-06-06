package ar.edu.unq.epers.aterrizar.models.social

import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors
import java.util.ArrayList
import com.datastax.driver.mapping.annotations.UDT

@UDT(keyspace = "cached_users", name = "destination")
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
		comments = new ArrayList<Comment>
		likes = new ArrayList<String>
		dislikes = new ArrayList<String>
	}
	
	new(String name){
		this.name = name
		comments = new ArrayList<Comment>
		likes = new ArrayList<String>
		dislikes = new ArrayList<String>
	}
	
	new(){
		comments = new ArrayList<Comment>
		likes = new ArrayList<String>
		dislikes = new ArrayList<String>
	}
	
	def like(String username){
		if(!likes.contains(username) && !dislikes.contains(username)){
			likes.add(username)
		} else if(dislikes.contains(username)){
			dislikes.remove(username)
			likes.add(username)
		}
	}
	
	def dislike(String username){
		if(!dislikes.contains(username) && !likes.contains(username)){
			dislikes.add(username)
		} else if(likes.contains(username)){
			likes.remove(username)
			dislikes.add(username)
		}
	}
	
	def addComment(Comment comment){
		this.comments.add(comment)
	}
	
	def updateComment(Comment comment){
		for(comm : comments){
			if(comm.id == comment.id){
				comments.remove(comm)
				comments.add(comment)
			}
		}
	}
	
}
