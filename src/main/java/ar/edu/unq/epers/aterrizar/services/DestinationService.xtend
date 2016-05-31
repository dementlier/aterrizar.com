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
	
	// No se debería usar, la implementación tendría que cambiar, dado que se le agrega a la destination,
	// y la destination se tiene updatear en la estructura del user.
	def saveComment(Comment comment){
		var db = MongoDB.instance()
		var comments = db.collection(Comment)
		comments.insert(comment)
	}
	
	// Parecido a lo de arriba, no tienen sus propias collection, sino que se meten en user...
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
	
	// deprecated
	def getDestinationsAggregate(SocialUser user, List<Visibility> visibilities){
		var db = MongoDB.instance()
		var users = db.collection(SocialUser)
		
		val res = new ArrayList<Destination>()
		
		val pipeline = Aggregation
		.match(DBQuery.is("_id", user.username))
		.unwind("destinations")
		.match(DBQuery.in("destinations.visibility", visibilities))
		.group("_id").set("destinations", Group.list("destinations.name"))
		// No pudimos agregar más cosas al $push, y llegamos a entender bien el nuevo update
		// a 15 min de la entrega... :(
		
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
	
	def getDestinationsForVisibilityFilter(SocialUser user, Visibility visibility){
		var db = MongoDB.instance()
		var users = db.collection(SocialUser)
		
		var res = new ArrayList<Destination>
		
		val userRes = users.aggregate
					.match("_id", user.username)
					.project
					.rtn("destinations")
					.filter("destinations")
					.eq("visibility", toString(visibility))
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