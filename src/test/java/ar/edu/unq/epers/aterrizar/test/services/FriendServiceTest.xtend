package ar.edu.unq.epers.aterrizar.test.services

import org.junit.Before
import ar.edu.unq.epers.aterrizar.services.UserHibernateService
import ar.edu.unq.epers.aterrizar.models.User
import ar.edu.unq.epers.aterrizar.utils.EnviadorDeMails
import org.mockito.Mockito
import java.sql.Date
import org.junit.Test
import static org.junit.Assert.*
import ar.edu.unq.epers.aterrizar.services.FriendService

class FriendServiceTest {

	UserHibernateService userService
	User user
	EnviadorDeMails enviador
	
	FriendService friendService

	@Before
	def void setUp() {

		// Inicializaciones
		userService = new UserHibernateService()
		userService.deleteAllUsersInDB()
		// Mocks
		enviador = Mockito.mock(typeof(EnviadorDeMails))

		// Register user
		userService.setEnviador(enviador)
		user = new User("Jose", "Juarez", "josejuarez", "pe@p.com", new Date(1), "1234", false)
		userService.registerUser(user);
		
		// register user in friendsrepo
		friendService = new FriendService
		friendService.addUser(user)
		
		
	}
	
	@Test
	def testGettingFriendsOfANewRegisteredUser() {
		
		var friends = friendService.friends(user)
		
		assertEquals(0, friends.size());
		
	}
	
	
}