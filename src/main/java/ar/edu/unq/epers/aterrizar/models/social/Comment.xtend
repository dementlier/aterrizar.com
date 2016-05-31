package ar.edu.unq.epers.aterrizar.models.social

import java.util.List

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
	}
	
	def getId(){
		return id
	}	
	
	def like(String username){
		likes.add(username)
	}
	
	def dislike(String username){
		dislikes.add(username)
	}
}