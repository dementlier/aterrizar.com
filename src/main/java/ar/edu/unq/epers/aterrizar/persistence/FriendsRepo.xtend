package ar.edu.unq.epers.aterrizar.persistence

import org.neo4j.graphdb.GraphDatabaseService
import ar.edu.unq.epers.aterrizar.models.User
import org.neo4j.graphdb.DynamicLabel
import ar.edu.unq.epers.aterrizar.models.FriendRelationshipType
import org.neo4j.graphdb.Node
import org.neo4j.graphdb.Direction
import org.neo4j.graphdb.RelationshipType
import ar.edu.unq.epers.aterrizar.models.MessageTransferType
import org.neo4j.graphdb.traversal.Evaluators
import java.util.HashSet
import ar.edu.unq.epers.aterrizar.models.FriendableUser

class FriendsRepo {
	GraphDatabaseService graph

	new(GraphDatabaseService graph) {
		this.graph = graph
	}

	private def userLabel() {
		DynamicLabel.label("User")
	}

	private def messageLabel() {
		DynamicLabel.label("Message")
	}

	def createUserNode(User user) {
		val node = this.graph.createNode(userLabel)

		node.setProperty("username", user.username)
		node.setProperty("firstname", user.firstname)
		node.setProperty("lastname", user.lastname)

		node
	}

	def sendMessage(User from, User to, String message) {
		val nodoFrom = this.getUserNode(from)
		val nodoTo = this.getUserNode(to)
		val nodoMessage = this.createMessageNode(message)

		nodoFrom.createRelationshipTo(nodoMessage, MessageTransferType.SENT)
		nodoTo.createRelationshipTo(nodoMessage, MessageTransferType.RECEIVED)
	}

	def createMessageNode(String message) {
		val node = this.graph.createNode(messageLabel)

		node.setProperty("message", message)

		node
	}

	def getMessages(User user, MessageTransferType transferType) {
		val userNode = this.getUserNode(user)
		val nodeMessages = this.relatedNodes(userNode, transferType, Direction.OUTGOING)
		nodeMessages.map[toMessageString].toList
	}

	def deleteUserNode(User user) {
		val nodo = this.getUserNode(user)
		nodo.relationships.forEach[delete]
		nodo.delete
	}

	def getUserNode(User user) {
		this.getUserNode(user.username)
	}

	def getUserNode(String username) {
		this.graph.findNodes(userLabel, "username", username).head
	}

	def relate(User persona1, User persona2, FriendRelationshipType relacion) {
		val nodo1 = this.getUserNode(persona1);
		val nodo2 = this.getUserNode(persona2);
		nodo1.createRelationshipTo(nodo2, relacion);
	}

	private def toUser(Node nodo) {
		new FriendableUser => [
			username = nodo.getProperty("username") as String
			firstname = nodo.getProperty("firstname") as String
			lastname = nodo.getProperty("lastname") as String
		]
	}

	private def toMessageString(Node node) {
		node.getProperty("message") as String
	}

	def getFriends(User user) {
		val nodeUser = this.getUserNode(user)
		val nodeFriends = this.relatedNodes(nodeUser, FriendRelationshipType.FRIEND, Direction.INCOMING)
		nodeFriends.map[toUser].toSet
	}

	protected def relatedNodes(Node nodo, RelationshipType tipo, Direction direccion) {
		nodo.getRelationships(tipo, direccion).map[it.getOtherNode(nodo)]
	}

	def connectedUsers(User user) {
		var td = graph.traversalDescription().breadthFirst().relationships(FriendRelationshipType.FRIEND,
			Direction.OUTGOING).evaluator(Evaluators.excludeStartPosition());
		var paths = td.traverse(this.getUserNode(user.username));
		var set = new HashSet
		for (path : paths) {
			set.add(path.endNode.toUser)
		}

		set

	}

	def areFriends(User user1, User user2) {
		val user1Node = this.getUserNode(user1)
		val user2Node = this.getUserNode(user2)
		val user1NodeFriends = this.relatedNodes(user1Node, FriendRelationshipType.FRIEND, Direction.INCOMING)
		user1NodeFriends.toList.exists[u|u == user2Node]

	// Me hubiese gustado poder checkearlo de forma mas simple, teniendo un metodo que
	// si le paso dos nodos y una relacion me diga si existe o no, pero no hay.
	}

}
