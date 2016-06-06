package ar.edu.unq.epers.aterrizar.models.social

import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors
import java.util.ArrayList
import com.datastax.driver.mapping.annotations.UDT

@UDT(keyspace = "cached_users", name = "comment")
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
}