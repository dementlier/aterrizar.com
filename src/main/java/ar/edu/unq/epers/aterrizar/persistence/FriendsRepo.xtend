package ar.edu.unq.epers.aterrizar.persistence

import org.neo4j.graphdb.GraphDatabaseService
import ar.edu.unq.epers.aterrizar.models.User
import org.neo4j.graphdb.DynamicLabel
import ar.edu.unq.epers.aterrizar.models.FriendRelationshipType
import org.neo4j.graphdb.Node
import org.neo4j.graphdb.Direction
import org.neo4j.graphdb.RelationshipType

class FriendsRepo {
	GraphDatabaseService graph

	new(GraphDatabaseService graph) {
		this.graph = graph
	}
	
	private def userLabel() {
		DynamicLabel.label("User")
	}
	
	
	def createUserNode(User user) {
		val node = this.graph.createNode(userLabel)
		
		node.setProperty("username", user.username)
		node.setProperty("firstname", user.firstname)
		node.setProperty("lastname", user.lastname)
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
		new User => [
			username = nodo.getProperty("username") as String
			firstname = nodo.getProperty("firstname") as String
			lastname = nodo.getProperty("lastname") as String
		]
	}

	def getFriends(User user) {
		val nodeUser = this.getUserNode(user)
		val nodeFriends = this.relatedNodes(nodeUser, FriendRelationshipType.FRIEND, Direction.INCOMING)
		nodeFriends.map[toUser].toSet
	}

	protected def relatedNodes(Node nodo, RelationshipType tipo, Direction direccion) {
		nodo.getRelationships(tipo, direccion).map[it.getOtherNode(nodo)]
	}


}