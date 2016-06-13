package ar.edu.unq.epers.aterrizar.test.services

import org.junit.Test
import org.junit.After
import org.junit.Before
import static org.junit.Assert.*
import ar.edu.unq.epers.aterrizar.persistence.CassandraRepo
import ar.edu.unq.epers.aterrizar.models.user.CachedUser
import ar.edu.unq.epers.aterrizar.models.user.SocialUser
import ar.edu.unq.epers.aterrizar.models.social.Destination
import ar.edu.unq.epers.aterrizar.models.social.Visibility

class CassandraRepoTest {
	CassandraRepo repo
	SocialUser sUser
	CachedUser user
	CachedUser user2
	Destination friendDestination
	
	@Before
	def void setUp(){
		repo = new CassandraRepo
		friendDestination = new Destination("cancun", Visibility.FRIENDS)
		sUser = new SocialUser("pepe")
		sUser.addDestination(friendDestination)
		user = new CachedUser(sUser, Visibility.FRIENDS)
		user2 = new CachedUser(sUser, Visibility.PUBLIC)
		
		repo.save(user)
		repo.save(user2)
	}
	
	@Test
	def void obtenerBusqueda() {
		val busqueda = repo.get(user.username, user.visibility)
		assertEquals(busqueda.username, "pepe")
		assertEquals(busqueda.visibility, Visibility.FRIENDS)
	}
	
	
	@After
	def void tearDown(){
		repo.drop_database
	}
}