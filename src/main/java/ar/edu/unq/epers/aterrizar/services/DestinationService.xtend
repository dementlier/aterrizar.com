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
import ar.edu.unq.epers.aterrizar.models.user.User
import ar.edu.unq.epers.aterrizar.persistence.Filter
import ar.edu.unq.epers.aterrizar.utils.VisibilityTransformer
import ar.edu.unq.epers.aterrizar.models.user.CachedUser

class DestinationService {
	FriendService fService
	CachingService cService
	UserHibernateService uService

	new(){
		fService 	= new FriendService
		cService 	= new CachingService
		uService	= new UserHibernateService
	}

	def void addUser(User user){
		if(getUserById(user.username) == null){
			var db = MongoDB.instance()
			var users = db.collection(SocialUser)
			var socUser = new SocialUser(user.username)
			users.insert(socUser)
		}
	}

	def void addDestination(SocialUser user, Destination destination){
		val fullUser = uService.getUser(user.username)
		if(fullUser != null && fullUser.hasReservationForDestination(destination.name)){
			user.addDestination(destination)
			updateUser(user)
		}
	}
	
	def saveUser(SocialUser user){
		var db = MongoDB.instance()
		var users = db.collection(SocialUser)
		users.insert(user)
		cService.deleteUser(user)
	}
	
	def updateUser(SocialUser user){
		var db = MongoDB.instance()
		var users = db.collection(SocialUser)
		users.mongoCollection.updateById(user.username, user)
		cService.deleteUser(user)
	}
	
	def addComment(SocialUser user, Destination destination, Comment comment){
		destination.addComment(comment)
		updateDestination(user, destination)
	}
		
	def updateComment(SocialUser user, Destination destination, Comment comment){
		destination.updateComment(comment)
		updateDestination(user, destination)
	}
	
	def updateDestination(SocialUser user, Destination destination){
		var usuario = getUserById(user.username)
		usuario.updateDestination(destination)
		updateUser(usuario)
	}
		
	def like(String username, SocialUser userLiked, Destination destination, Comment comment){
		comment.like(username)
		updateComment(userLiked, destination, comment)
	}
	
	def like(String username, SocialUser userLiked, Destination destination){
		destination.like(username)
		updateDestination(userLiked, destination)
	}
		
	def dislike(String username, SocialUser userDisliked, Destination destination, Comment comment){
		comment.dislike(username)
		updateComment(userDisliked, destination, comment)
	}
		
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
	// Lo que esta comentado por ahora me tira assertion failed si lo descomento, no se como se hara :(	
	def getDestinationsFilter(SocialUser user, List<Visibility> visibilities){
		var db = MongoDB.instance()
		var users = db.collection(SocialUser)
		
		var res = new ArrayList<Destination>
		
		val userRes = users.aggregate
					.match("_id", user.username)					
					.project
					.filter("destinations")																
					.orVisibilities(visibilities)		
//					.project
//					.rtn("destinations.comments")
//					.filter("destinations.comments")
//					.eq("visibility", toString(visibility))
					.execute


		res.addAll(userRes.head.destinations)
		
		return res		
	}
	
	def orVisibilities(Filter<SocialUser> filter, List<Visibility> visibilities){
		filter.or(visibilities.map[v | [Filter<SocialUser> f | f.eq("visibility", toString(v))] ])
	}
	

		
	def getVisibleProfile(SocialUser watched, SocialUser watching){
		var list = new ArrayList<Visibility>
		if(watched.username == watching.username){
			list.add(Visibility.PRIVATE)
			list.add(Visibility.FRIENDS)
			list.add(Visibility.PUBLIC)
			getProfile(watched, list, Visibility.PRIVATE.toString)
		} else if(fService.areFriends(toUser(watched), toUser(watching))){
			list.add(Visibility.FRIENDS)
			list.add(Visibility.PUBLIC)
			getProfile(watched, list, Visibility.FRIENDS.toString)
		} else {
			list.add(Visibility.PUBLIC)
			getProfile(watched, list, Visibility.PUBLIC.toString)
		}		
	}
	
	def getProfile(SocialUser user, List<Visibility> visibilities, String topVisibility) {
		var visibility = VisibilityTransformer.toVisibility(topVisibility)
		var cUser = cService.get(user.username, visibility)
		
		if(cUser != null){
			return cUser.user
		}
		else{
			var sUser = new SocialUser(user.username, getDestinationsFilter(user, visibilities))
			cService.save(new CachedUser(sUser, visibility))
			return sUser
		}
		
	}
	
	def void dropDB(){
		var db = MongoDB.instance()
		db.collection(SocialUser).mongoCollection.drop
	}
	
}