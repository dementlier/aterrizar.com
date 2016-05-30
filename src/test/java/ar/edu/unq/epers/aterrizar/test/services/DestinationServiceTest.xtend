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
	Destination publicDestination
	Destination friendDestination
	Destination privateDestination
	
	@Before
	def void setUp(){
		service = new DestinationService
		service.dropDB()
		user = new SocialUser("pepe")
		publicDestination = new Destination("pompeya", Visibility.PUBLIC)
		friendDestination = new Destination("cancun", Visibility.FRIENDS)
		privateDestination = new Destination("mdq", Visibility.PRIVATE)
		service.saveUser(user)
	}
	
	@Test
	def void testAddFriendDestination(){
		service.addDestination(user, friendDestination)
		var visibility = new ArrayList<Visibility>()
		visibility.add(Visibility.FRIENDS)
		
		var result = service.getDestinationsOf(user, visibility)
		assertEquals(1, result.size)
		assertEquals(friendDestination.name, result.get(0).name)
	}
	
	@Test
	def void testAddEveryDestination(){
		
		service.addDestination(user, publicDestination)
		service.addDestination(user, friendDestination)
		service.addDestination(user, privateDestination)
		
		var visibility = new ArrayList<Visibility>()
		visibility.add(Visibility.PUBLIC)
		visibility.add(Visibility.FRIENDS)
		visibility.add(Visibility.PRIVATE)
		
		var result = service.getDestinationsOf(user, visibility)
		
		assertEquals(3, result.size)
		
	}
	
	@Test
	def void testAddEveryDestinationAndGetOnlyPublic(){
		
		service.addDestination(user, publicDestination)
		service.addDestination(user, friendDestination)
		service.addDestination(user, privateDestination)
		
		var visibility = new ArrayList<Visibility>()
		visibility.add(Visibility.PRIVATE)
		
		var result = service.getDestinationsOf(user, visibility)
		
		assertEquals(1, result.size)
		
	}
	
	@After
	def void tearDown(){
	}
	
}