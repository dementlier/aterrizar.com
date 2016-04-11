package ar.edu.unq.epers.aterrizar.test.user

import ar.edu.unq.epers.aterrizar.models.User
import ar.edu.unq.epers.aterrizar.services.UserService
import ar.edu.unq.epers.aterrizar.utils.EnviadorDeMails
import ar.edu.unq.epers.aterrizar.exceptions.EnviarMailException
import ar.edu.unq.epers.aterrizar.utils.Mail
import ar.edu.unq.epers.aterrizar.exceptions.UserAlreadyExistsException
import ar.edu.unq.epers.aterrizar.exceptions.UserDoesNotExistsException
import ar.edu.unq.epers.aterrizar.exceptions.UserNewPasswordSameAsOldPasswordException
import java.sql.Date
import org.junit.Before
import org.junit.Test
import org.mockito.Mockito

import static org.junit.Assert.*
import ar.edu.unq.epers.aterrizar.services.UserHibernateService

public class UserServiceTest {

	UserService userService;
	User user;
	EnviadorDeMails enviador
	Mail mail

	@Before
	def void setUp() {

		// Inicializaciones
		userService = new UserService()
		userService.deleteAllUsersInDB()
		user = new User("Jose", "Juarez", "josejuarez", "pe@p.com", new Date(1), "1234", false)

		// Mocks
		enviador = Mockito.mock(typeof(EnviadorDeMails))
		mail = new Mail("Su codigo es: " + "pepejuarez".hashCode(), "Codigo de validacion", "p@p.com", "admin@pp.com")

		// Register user
		userService.setEnviador(enviador)
		userService.registerUser(user);
	}

	@Test
	def void testANewUserRegistersSuccesfullyIntoTheSystem() {

		val user2 = new User("Pepe", "Juarez", "pepejuarez", "p@p.com", new Date(1), "1234", false)
		userService.registerUser(user2);
		val user = userService.getUser("pepejuarez");
		assertEquals(user.username, user2.username);
		Mockito.verify(enviador).enviarMail(mail)
	}

	@Test(expected=UserAlreadyExistsException)
	def void testANewUserCannotRegisterIfAlreadyExists() {
		userService.registerUser(user);
	}

	@Test(expected=UserDoesNotExistsException)
	def void testAnInexistentUserCannotBeRetrieved() {
		userService.getUser("i_dont_exist");
	}

	@Test
	def void testAUserValidatesCorrectly() {
		assertTrue(userService.validateUser(user.username, user.username.hashCode))
	}

	@Test
	def void testAPasswordChanges() {
		userService.changePassword(user.username, "3456")
		val user2 = userService.getUser(user.username)
		assertEquals(user2.password, "3456")
	}

	@Test(expected=UserNewPasswordSameAsOldPasswordException)
	def void testAPasswordDoesNotChangeIfItIsSameAsOld() {
		userService.changePassword(user.username, user.password)
	}

	@Test
	def testAUserLoginsSuccessfully() {
		assertTrue(userService.login(user.username, user.password))
	}

	@Test(expected=UserDoesNotExistsException)
	def void testAUserFailsToLoginBecauseTheUserDoesNotExist() {
		userService.login("i_dont_exist", "asdasdasd")
	}

	@Test
	def void testAUserFailsToLoginBecausePasswordIsInvalid() {
		assertFalse(userService.login(user.username, "passNoValida"))
	}

	@Test(expected=EnviarMailException)
	def void testCheckForExceptionOnMailSending() {
		Mockito.doThrow(EnviarMailException).when(enviador).enviarMail(mail)
		val user2 = new User("Pepe", "Juarez", "pepejuarez", "p@p.com", new Date(1), "1234", false)
		userService.registerUser(user2);
	}
	
	@Test
	def consultar() {
		var user = new UserHibernateService().consultarUser(1);
		assertEquals("Jose", user.firstname);
		assertEquals("Juarez", user.lastname);
	}

}
