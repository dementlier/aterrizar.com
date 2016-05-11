package ar.edu.unq.epers.aterrizar.services

import org.neo4j.graphdb.GraphDatabaseService
import ar.edu.unq.epers.aterrizar.persistence.FriendsRepo
import ar.edu.unq.epers.aterrizar.models.FriendRelationshipType
import ar.edu.unq.epers.aterrizar.models.User
import ar.edu.unq.epers.aterrizar.models.MessageTransferType

class FriendService {
	
	private def createHome(GraphDatabaseService graph) {
		new FriendsRepo(graph)
	}
	
	def deleteUser(User user) {
		GraphServiceRunner::run[
			createHome(it).deleteUserNode(user)
			null
		]
	}

	def addUser(User user) {
		GraphServiceRunner::run[
			createHome(it).createUserNode(user); 
			null
		]
	}

	def befriend(User user1, User user2) {
		GraphServiceRunner::run[
			val home = createHome(it);
			home.relate(user1, user2, FriendRelationshipType.FRIEND)
			home.relate(user2, user1, FriendRelationshipType.FRIEND)
		]
	}

	def friends(User user) {
		GraphServiceRunner::run[
			val home = createHome(it)
			home.getFriends(user)
		]
	}
	
	def sendMessage(User from, User to, String message){
		GraphServiceRunner::run[
			val home = createHome(it)
			if(home.areFriends(from, to)){
				home.sendMessage(from, to, message)
			}
		]
	}
	
	def getMessagesSentBy(User user){
		GraphServiceRunner::run[
			val home = createHome(it)
			home.getMessages(user, MessageTransferType.SENT)
		]
	}

	def getMessagesReceivedBy(User user){
		GraphServiceRunner::run[
			val home = createHome(it)
			home.getMessages(user, MessageTransferType.RECEIVED)
		]
	}


}