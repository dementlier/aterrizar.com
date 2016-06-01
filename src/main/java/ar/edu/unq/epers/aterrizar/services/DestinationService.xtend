package ar.edu.unq.epers.aterrizar.services

import ar.edu.unq.epers.aterrizar.models.user.SocialUser
import static ar.edu.unq.epers.aterrizar.utils.VisibilityTransformer.*
import ar.edu.unq.epers.aterrizar.models.social.Destination
import ar.edu.unq.epers.aterrizar.models.social.Visibility
import ar.edu.unq.epers.aterrizar.persistence.MongoDB
import ar.edu.unq.epers.aterrizar.models.social.Comment
import static ar.edu.unq.epers.aterrizar.utils.UserTransformer.*
import org.mongojack.DBQuery
import java.util.ArrayList
import java.util.List
import org.mongojack.Aggregation
import org.mongojack.Aggregation.Group

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
	
	// TODO Hay que testearlo pero debería andar
	def addComment(SocialUser user, Destination destination, Comment comment){
		destination.addComment(comment)
		updateDestination(user, destination)
	}
		
	// TODO Hay que testearlo pero debería andar	
	def updateComment(SocialUser user, Destination destination, Comment comment){
		destination.updateComment(comment)
		updateDestination(user, destination)
	}
	
	// TODO Hay que testear, pero debería andar.
	def updateDestination(SocialUser user, Destination destination){
		var usuario = getUserById(user.username)
		usuario.updateDestination(destination)
		updateUser(usuario)
	}
	
	// TODO Hay que testear, pero debería andar.	
	def like(String username, SocialUser userLiked, Destination destination, Comment comment){
		comment.like(username)
		updateComment(userLiked, destination, comment)
	}
	
	// TODO Hay que testear, pero debería andar.	
	def like(String username, SocialUser userLiked, Destination destination){
		destination.like(username)
		updateDestination(userLiked, destination)
	}
	
	// TODO Hay que testear, pero debería andar.	
	def dislike(String username, SocialUser userDisliked, Destination destination, Comment comment){
		comment.dislike(username)
		updateComment(userDisliked, destination, comment)
	}
	
	// TODO Hay que testear, pero debería andar.	
	def dislike(String username, SocialUser userDisliked, Destination destination){
		destination.dislike(username)
		updateDestination(userDisliked, destination)
	}
	

	
	def getUserById(String username){
		var db = MongoDB.instance()
		var users = db.collection(SocialUser)
		
		var cursor = users.find(DBQuery.is("_id" ,username))
		if(cursor.hasNext){
			cursor.next
		} else {
			null // O Exception quizas.
		}
	}
	
	// TODO deprecated, to be deleted
	def getDestinationsAggregate(SocialUser user, List<Visibility> visibilities){
		var db = MongoDB.instance()
		var users = db.collection(SocialUser)
		
		val res = new ArrayList<Destination>()
		
		val pipeline = Aggregation
		.match(DBQuery.is("_id", user.username))
		.unwind("destinations")
		.match(DBQuery.in("destinations.visibility", visibilities))
		.group("_id").set("destinations", Group.list("destinations.name"))
		
		var userResult = users.mongoCollection.aggregate(pipeline, SocialUser).results
		
		res.addAll(userResult.head.destinations)
		
		return res
	}
	
	def getDestinationsFilter(SocialUser user, List<Visibility> visibilities){
		var res = new ArrayList<Destination>
		for(vis : visibilities){
			res.addAll(getDestinationsForVisibilityFilter(user, vis))
		}
		return res		
	}
	
	// Lo que esta comentado por ahora me tira assertion failed si lo descomento, no se como se hara :(
	def getDestinationsForVisibilityFilter(SocialUser user, Visibility visibility){
		var db = MongoDB.instance()
		var users = db.collection(SocialUser)
		
		var res = new ArrayList<Destination>
		
		val userRes = users.aggregate
					.match("_id", user.username)					
					.project
					.filter("destinations")																
					.eq("visibility", toString(visibility))		
//					.project
//					.rtn("destinations.comments")
//					.filter("destinations.comments")
//					.eq("visibility", toString(visibility))
					.execute


		res.addAll(userRes.head.destinations)
		
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
		return new SocialUser(user.username, getDestinationsFilter(user, visibilities))
	}
	
	def void dropDB(){
		var db = MongoDB.instance()
		db.collection(SocialUser).mongoCollection.drop
	}
	
}