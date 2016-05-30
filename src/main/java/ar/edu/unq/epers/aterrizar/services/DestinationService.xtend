package ar.edu.unq.epers.aterrizar.services

import ar.edu.unq.epers.aterrizar.models.user.SocialUser
import ar.edu.unq.epers.aterrizar.models.social.Destination
import ar.edu.unq.epers.aterrizar.models.social.Visibility
import ar.edu.unq.epers.aterrizar.persistence.MongoDB
import ar.edu.unq.epers.aterrizar.models.social.Comment
import static ar.edu.unq.epers.aterrizar.utils.UserTransformer.*
import org.mongojack.DBQuery
import ar.edu.unq.epers.aterrizar.models.social.Profile
import java.util.ArrayList
import java.util.List
import com.mongodb.BasicDBObject
import com.mongodb.util.JSON
import com.mongodb.BasicDBList

class DestinationService {
	FriendService fService
	
	new(){
		fService = new FriendService
	}

	def void addDestination(SocialUser user, Destination destination){
		user.addDestination(destination)
		updateUser(user)
	}
	
	def saveUser(SocialUser user){
		var db = MongoDB.instance()
		var users = db.collection(SocialUser)
		users.insert(user)
	}
	
	def updateUser(SocialUser user){
		var db = MongoDB.instance()
		var users = db.collection(SocialUser)
		users.mongoCollection.updateById(user.username, user)
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
	
	def getDestinationsOf(SocialUser user, List<Visibility> visibilities){
		var db = MongoDB.instance()
		var users = db.collection(SocialUser)
		
		val res = new ArrayList<Destination>()
		
		val inLista = new BasicDBList()
		inLista.addAll(visibilities)
		val in = new BasicDBObject("$in", inLista )
		val vis = new BasicDBObject("visibility", in )
		val elemMatch = new BasicDBObject("$elemMatch", vis )
		val destinations = new BasicDBObject("destinations", elemMatch )
		
		
		res.addAll(
			users.find(DBQuery.is("_id", user.username), destinations).next.destinations
		)
		return res
	}
	
	def getVisibleProfile(SocialUser watched, SocialUser watching){
		var list = new ArrayList<Visibility>
		if(watched.username == watching.username){
			list.add(Visibility.PRIVATE)
			list.add(Visibility.FRIENDS)
			list.add(Visibility.PUBLIC)
			getProfile(watched, list)
		} else if(fService.areFriends(toUser(watched), toUser(watching))){
			list.add(Visibility.FRIENDS)
			list.add(Visibility.PUBLIC)
			getProfile(watched, list)
		} else {
			list.add(Visibility.PUBLIC)
			getProfile(watched, list)
		}		
	}
	
	def getProfile(SocialUser user, List<Visibility> visibilities) {
//		return new Profile(user.username, getDestinationsOf(user, visibilities))
	}
	
	def void dropDB(){
		var db = MongoDB.instance()
		db.collection(SocialUser).mongoCollection.drop
	}
	
}