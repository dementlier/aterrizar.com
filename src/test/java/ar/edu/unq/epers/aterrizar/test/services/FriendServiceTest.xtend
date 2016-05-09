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
		assertEquals(friends.size(), 2);
		assertTrue(friends.exists[u | u.username == user2.username])
		assertTrue(friends.exists[u | u.username == user3.username])
		
	}
	
	// TODO Modelar nodo Mensaje que tenga sender, receiver y cuerpo
	// Los usuarios mandan mensajes que se agregan al service y quedan flotando ahí
	// No hace falta agregar un mensaje a un usuario. Solo envían. 
	
	@After
	def void tearDown(){
		friendService.deleteUser(user)
		friendService.deleteUser(user2)
		friendService.deleteUser(user3)
		friendService.deleteUser(user4)
		friendService.deleteUser(user5)
	}
	
	
}