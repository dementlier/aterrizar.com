package ar.edu.unq.epers.aterrizar.test.services

import ar.edu.unq.epers.aterrizar.services.CachingService
import ar.edu.unq.epers.aterrizar.models.user.SocialUser
import ar.edu.unq.epers.aterrizar.models.user.CachedUser
import ar.edu.unq.epers.aterrizar.models.social.Destination
import org.junit.Before
import ar.edu.unq.epers.aterrizar.models.social.Visibility
import org.junit.Test
import org.junit.After
import static org.junit.Assert.*

class CachingServiceTest {
	CachingService service
	SocialUser sUser
	CachedUser user
	CachedUser user2
	Destination friendDestination
	
	@Before
	def void setUp(){
		service = new CachingService
		friendDestination = new Destination("cancun", Visibility.FRIENDS)
		sUser = new SocialUser("pepe")
		sUser.addDestination(friendDestination)
		user = new CachedUser(sUser, Visibility.FRIENDS)
		user2 = new CachedUser(sUser, Visibility.PUBLIC)
		
		service.save(user)
		service.save(user2)
	}
	
	@Test
	def void obtenerBusqueda() {
		val busqueda = service.get(user.username, user.visibility)
		assertEquals(busqueda.username, "pepe")
		assertEquals(busqueda.user.cached, true)
		assertEquals(busqueda.visibility, Visibility.FRIENDS)
	}
	
	@After
	def void tearDown(){
		service.deleteAllUsers
	}

	
	
}