package ar.edu.unq.epers.aterrizar.test.services

import ar.edu.unq.epers.aterrizar.services.UserHibernateService
import org.junit.Before
import org.junit.Test
import org.mockito.Mockito
import static org.junit.Assert.*
import ar.edu.unq.epers.aterrizar.models.user.User
import ar.edu.unq.epers.aterrizar.utils.EnviadorDeMails
import ar.edu.unq.epers.aterrizar.utils.Mail
import java.sql.Date
import ar.edu.unq.epers.aterrizar.models.user.Reservation
import java.util.ArrayList
import ar.edu.unq.epers.aterrizar.models.airlines.Seat
import ar.edu.unq.epers.aterrizar.persistence.SearcherHibernateRepo

class UserHibernateServiceTest {

	UserHibernateService userService
	SearcherHibernateRepo searcherService
	User user;
	EnviadorDeMails enviador
	Mail mail
	Reservation reserva

	@Before
	def void setUp() {

		// Inicializaciones
		searcherService = new SearcherHibernateRepo
		searcherService.deleteAllSeatsInDB
		userService = new UserHibernateService()
		userService.deleteAllUsersInDB()
		// Mocks
		enviador = Mockito.mock(typeof(EnviadorDeMails))
		mail = new Mail("Su codigo es: " + "pepejuarez".hashCode(), "Codigo de validacion", "p@p.com", "admin@pp.com")

		// Register user
		userService.setEnviador(enviador)
		user = new User("Jose", "Juarez", "josejuarez", "pe@p.com", new Date(1), "1234", false)
		userService.registerUser(user);
		
		// Reservations
		reserva = new Reservation(new ArrayList<Seat>, "hola", "hola")
		
	}
	
	@Test
	def testGettingARegisteredUser() {
		var user = new UserHibernateService().getUser("josejuarez");
		assertEquals("Jose", user.firstname);
		assertEquals("Juarez", user.lastname);
	}
	
	@Test
	def testAddAReservationToAExistingUser() {
		var user = new UserHibernateService().getUser("josejuarez");
		user.addReservation(reserva)
		userService.saveUser(user)
		user = userService.getUser("josejuarez")
		assertEquals(user.reservations.size(), 1);
	}
}