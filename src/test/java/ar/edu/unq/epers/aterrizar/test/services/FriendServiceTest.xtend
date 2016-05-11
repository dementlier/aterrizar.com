package ar.edu.unq.epers.aterrizar.test.services

import ar.edu.unq.epers.aterrizar.models.User
import ar.edu.unq.epers.aterrizar.services.FriendService
import java.sql.Date
import org.junit.After
import org.junit.Before
import org.junit.Test

import static org.junit.Assert.*

class FriendServiceTest {

	User user
	User user2
	User user3
	User user4
	User user5
	
	FriendService friendService

	@Before
	def void setUp() {

		// Inicializaciones
		friendService = new FriendService

		// Register user
		user  = new User("Jose", "Juarez", "josejuarez", "pe@p.com", new Date(1), "1234", false)
		user2 = new User("Anna", "Azcuenaga", "aa", "aa@p.com", new Date(1), "1234", false)
		user3 = new User("Antonio", "Algoncona", "aa2", "aa2@p.com", new Date(1), "1234", false)
		user4 = new User("Benjamin", "Benitez", "bb", "bb@p.com", new Date(1), "1234", false)
		user5 = new User("Blanca", "Basualdo", "bb2", "bb2@p.com", new Date(1), "1234", false)
		//userService.registerUser(user);
		
		// register user in friendsrepo
		friendService.addUser(user)
		friendService.addUser(user2)
		friendService.addUser(user3)
		friendService.addUser(user4)
		friendService.addUser(user5)		
		
	}
	
	@Test
	def testGettingFriendsOfANewRegisteredUser() {
		
		var friends = friendService.friends(user)
		
		assertEquals(0, friends.size());
		
	}
	
	@Test
	def testFriendsAreAddedCorrectlyToAnUser() {
		friendService.befriend(user, user2)
		friendService.befriend(user, user3)
		var friends = friendService.friends(user)
		assertEquals(2, friends.size());
		assertTrue(friends.exists[u | u.username == user2.username])
		assertTrue(friends.exists[u | u.username == user3.username])
		
	}
	
	// TODO Modelar nodo Mensaje que tenga sender, receiver y cuerpo
	// Los usuarios mandan mensajes que se agregan al service y quedan flotando ahí
	// No hace falta agregar un mensaje a un usuario. Solo envían.
	
	// Me di cuenta despues de este comentario, cuando ya habia terminado todo la creacion y demas
	// y solo me faltaba testear, termine haciendo un mensaje que solo es un string
	// que se guarda como nodo y que se lo relaciona tanto con el sender como con el receiver
	// y que son 2 relaciones con distinto tipo (SENT, RECEIVED).
	// Si lo habian charlado con los profes de que tenia que ser como lo dijeron despues lo cambiamos,
	// total es más facil de su manera, pero pense que habia que usar relaciones!
	
	@Test
	def testMessagesAreSentCorrectlyToAnUserThatAFriendWithSender(){
		friendService.befriend(user, user2)
		friendService.sendMessage(user, user2, "Mensaje")
		var messagesSentByUser = friendService.getMessagesSentBy(user)
		var messagesReceivedByUser2 = friendService.getMessagesReceivedBy(user2)
		assertEquals(1, messagesSentByUser.size())
		assertEquals(1, messagesReceivedByUser2.size())
		assertEquals("Mensaje", messagesSentByUser.head)
		assertEquals("Mensaje", messagesReceivedByUser2.head)
	}
	
	@Test
	def testMessagesAreNotSentCorrectlyToAnUserThatIsNotAFriendWithSender(){
		friendService.sendMessage(user, user2, "Mensaje")
		var messagesSentByUser = friendService.getMessagesSentBy(user)
		var messagesReceivedByUser2 = friendService.getMessagesReceivedBy(user2)
		assertEquals(0, messagesSentByUser.size())
		assertEquals(0, messagesReceivedByUser2.size())
	}
	
	@Test
	def testUsersConectedToUser1(){
		friendService.befriend(user, user2)
		friendService.befriend(user, user3)
		friendService.befriend(user2, user4)
		friendService.befriend(user3, user5)
		friendService.befriend(user2, user3)
		var connectedUsers = friendService.getConnectedUsers(user)
		assertEquals(4, connectedUsers.size())
		assertTrue(connectedUsers.exists[u | u.username == user2.username])
		assertTrue(connectedUsers.exists[u | u.username == user3.username])
		assertTrue(connectedUsers.exists[u | u.username == user4.username])
		assertTrue(connectedUsers.exists[u | u.username == user5.username])
	}
	
	@After
	def void tearDown(){
		friendService.deleteUser(user)
		friendService.deleteUser(user2)
		friendService.deleteUser(user3)
		friendService.deleteUser(user4)
		friendService.deleteUser(user5)
	}
	
	
}