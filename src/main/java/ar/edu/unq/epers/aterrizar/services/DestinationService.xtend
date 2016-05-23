package ar.edu.unq.epers.aterrizar.services

import ar.edu.unq.epers.aterrizar.models.user.SocialUser
import ar.edu.unq.epers.aterrizar.models.social.Destination
import ar.edu.unq.epers.aterrizar.models.social.Visibility
import ar.edu.unq.epers.aterrizar.persistence.MongoDB
import ar.edu.unq.epers.aterrizar.models.social.Comment

class DestinationService {
	FriendService fService
	
	new(){
		fService = new FriendService
	}

	def addDestination(SocialUser user, Destination destination, Visibility visibility){
		user.addDestination(destination, visibility)
		saveUser(user)
	}
	
	def saveUser(SocialUser user){
		var db = MongoDB.instance()
		var users = db.collection(SocialUser)
		users.insert(user)
	}
	
	def saveComment(Comment comment){
		var db = MongoDB.instance()
		var comments = db.collection(Comment)
		comments.insert(comment)
	}
	
	def saveDestination(Destination destination){
		var db = MongoDB.instance()
		var destinations = db.collection(Destination)
		destinations.insert(destination)
	}
	
	def like(SocialUser user, Comment comment){
		comment.like(user.username)
		saveComment(comment)
	}
	
	def like(SocialUser user, Destination destination){
		destination.like(user.username)
		saveDestination(destination)
	}
	
	def dislike(SocialUser user, Comment comment){
		comment.dislike(user.username)
		saveComment(comment)
	}
	
	def dislike(SocialUser user, Destination destination){
		destination.dislike(user.username)
		saveDestination(destination)
	}
	
	def addComment(Destination destination, Comment comment){
		destination.addComment(comment)
		saveDestination(destination)
	}
	
	def getVisibleDestinationsOfTo(SocialUser watched, SocialUser watching){

	}
	
	def getVisibilityFor(SocialUser user, SocialUser user2){
		var fUser1 = fService.
		switch(user){
			case user.username == user2.username:
				return Visibility.PRIVATE
			case fService.areFriends()
		}
	}
	
}