package ar.edu.unq.epers.aterrizar.test.services

import org.junit.Test
import org.junit.Before
import static org.junit.Assert.*
import ar.edu.unq.epers.aterrizar.services.DestinationService
import ar.edu.unq.epers.aterrizar.models.user.SocialUser
import ar.edu.unq.epers.aterrizar.models.social.Destination
import ar.edu.unq.epers.aterrizar.models.social.Visibility
import java.util.ArrayList
import org.junit.After

class DestinationServiceTest {
	DestinationService service
	SocialUser user
	Destination destination
	
	@Before
	def void setUp(){
		service = new DestinationService
		user = new SocialUser("pepe")
		destination = new Destination("pompeya", Visibility.FRIENDS)
		service.saveUser(user)
	}
	
	@Test
	def void testAddDestination(){
		service.addDestination(user, destination)
		var visibility = new ArrayList<Visibility>()
		visibility.add(Visibility.FRIENDS)
		assertTrue(service.getDestinationsOf(user, visibility).isEmpty)
	}
	
	@After
	def void tearDown(){
		service.dropDB()
	}
	
}