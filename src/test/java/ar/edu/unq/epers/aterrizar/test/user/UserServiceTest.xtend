package ar.edu.unq.epers.aterrizar.test.user

import ar.edu.unq.epers.aterrizar.models.User
import ar.edu.unq.epers.aterrizar.services.UserService
import ar.edu.unq.epers.aterrizar.utils.EnviadorDeMails
import ar.edu.unq.epers.aterrizar.utils.EnviarMailException
import ar.edu.unq.epers.aterrizar.utils.Mail
import ar.edu.unq.epers.aterrizar.utils.UserAlreadyExistsException
import ar.edu.unq.epers.aterrizar.utils.UserDoesNotExistsException
import java.sql.Date
import org.junit.Before
import org.junit.Test
import org.mockito.Mockito

import static org.junit.Assert.*

public class UserServiceTest {

    UserService userService;
    User u;
    EnviadorDeMails enviador
    Mail mail

    @Before
    def void setUp() {
        // Inicializaciones
        userService = new UserService()
        userService.cleanDatabase()
        u = new User("Jose", "Juarez", "josejuarez", "pe@p.com", new Date(1), "1234", false)

        // Mocks
        enviador = Mockito.mock(typeof(EnviadorDeMails))
        mail = new Mail("Su codigo es: " + "pepejuarez".hashCode(), "Codigo de validacion", "p@p.com", "admin@pp.com")

        // Register user
        userService.setEnviador(enviador)
        userService.registerUser(u);
    }

    @Test
    def void testANewUserRegistersSuccesfullyIntoTheSystem() {

        val u2 = new User("Pepe", "Juarez", "pepejuarez", "p@p.com", new Date(1), "1234", false)
        userService.registerUser(u2);
        val user = userService.getUser("pepejuarez");
        assertEquals(user.getNombreDeUsuario(), u2.getNombreDeUsuario());
        Mockito.verify(enviador).enviarMail(mail)
    }

    @Test(expected = UserAlreadyExistsException)
    def void testANewUserCannotRegisterIfAlreadyExists() {
        userService.registerUser(u);
    }

    @Test(expected = UserDoesNotExistsException)
    def void testAnInexistentUserCannotBeRetrieved() {
        userService.getUser("i_dont_exist");
    }

    @Test
    def void testAUserValidatesCorrectly() {
        assertTrue(userService.validateUser(u.nombreDeUsuario, u.nombreDeUsuario.hashCode))
    }

    @Test
    def void testAPasswordChanges() {
        userService.changePassword(u.nombreDeUsuario, "3456")
        val u2 = userService.getUser(u.nombreDeUsuario)
        assertEquals(u2.password, "3456")
    }

    @Test(expected = Exception)
    def void testARepeatedPasswordDoesntChange() {
        userService.changePassword(u.nombreDeUsuario, u.password)
    }

    @Test
    def testAUserLoginsSuccessfully() {
        assertTrue(userService.login(u.nombreDeUsuario, u.password))
    }

    @Test(expected = EnviarMailException)
    def void testCheckForExceptionOnMailSending(){
        Mockito.doThrow(EnviarMailException).when(enviador).enviarMail(mail)
        val u2 = new User("Pepe", "Juarez", "pepejuarez", "p@p.com", new Date(1), "1234", false)
        userService.registerUser(u2);
    }


}
