package ar.edu.unq.epers.aterrizar.test.user

import ar.edu.unq.epers.aterrizar.services.UserHibernateService
import org.junit.Before
import org.junit.Test
import org.mockito.Mockito
import static org.junit.Assert.*
import ar.edu.unq.epers.aterrizar.models.User
import ar.edu.unq.epers.aterrizar.utils.EnviadorDeMails
import ar.edu.unq.epers.aterrizar.utils.Mail
import java.sql.Date
import ar.edu.unq.epers.aterrizar.models.Reservation
import java.util.ArrayList
import ar.edu.unq.epers.aterrizar.models.Seat

class UserHibernateServiceTest {

	UserHibernateService userService;
	User user;
	EnviadorDeMails enviador
	Mail mail
	Reservation reserva

	@Before
	def void setUp() {

		// Inicializaciones
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
		reserva = new Reservation(10, new ArrayList<Seat>())
		
	}
	
	@Test
	def consultar() {
		var user = new UserHibernateService().consultarUser("josejuarez");
		assertEquals("Jose", user.firstname);
		assertEquals("Juarez", user.lastname);
	}
	
	@Test
	def agregarReserva() {
		var user = new UserHibernateService().consultarUser("josejuarez");
		user.addReservation(reserva)
		assertEquals(user.reservations.size(), 1);
	}
}