package ar.edu.unq.epers.aterrizar.test.user

import ar.edu.unq.epers.aterrizar.services.UserService
import ar.edu.unq.epers.aterrizar.models.User
import org.junit.Before
import java.sql.Date
import org.junit.Test
import static org.junit.Assert.*;
import ar.edu.unq.epers.aterrizar.utils.EnviadorDeMails
import org.mockito.Mockito
import ar.edu.unq.epers.aterrizar.utils.Mail
import org.mockito.stubbing.Answer
import org.mockito.invocation.InvocationOnMock

public class UserServiceTest {

    UserService userService;
    User u;
	EnviadorDeMails enviador
	Mail mail

    @Before
    def void setUp(){
    	// Inicializaciones
        userService = new UserService()
        userService.cleanDatabase()
        u = new User("Jose", "Juarez", "josejuarez", "pe@p.com", new Date(1), "1234", false)
        
        // Mocks
        enviador 	= Mockito.mock(EnviadorDeMails)
        mail 		= Mockito.mock(Mail)
        Mockito.doAnswer(new Answer() {
			override answer(InvocationOnMock invocation) throws Throwable {
				throw new UnsupportedOperationException("TODO: auto-generated method stub")
			}
		}).when(enviador).enviarMail(mail)
		
		// Register user
		userService.setEnviador(enviador)
        userService.registerUser(u);
    }

    @Test
    def void testANewUserRegistersSuccesfullyIntoTheSystem(){
		
    	try{
    	val u2 = new User("Pepe", "Juarez", "pepejuarez", "p@p.com", new Date(1), "1234", false)
    		userService.registerUser(u2);
        val user = userService.getUser("pepejuarez");
        assertEquals(user.getNombreDeUsuario(), u2.getNombreDeUsuario());
    	}
        catch(Exception e){
			fail
        }
    }
    
    @Test
    def void testAUserValidatesCorrectly(){
    	try{
    		assertTrue(userService.validateUser(u.nombreDeUsuario, u.nombreDeUsuario.hashCode))
    	}
    	catch(Exception e){
    		fail
    	}
    }
    
    @Test
    def void testAPasswordChanges(){
    	try{
    		
    		userService.changePassword(u.nombreDeUsuario, "3456")
    		val u2 = userService.getUser(u.nombreDeUsuario)
    		assertEquals(u2.password, "3456")
    	}
    	catch(Exception e){
    		fail
    	}
    }
    
    @Test
    def void testARepeatedPasswordDoesntChange(){
    	try{
    		userService.changePassword(u.nombreDeUsuario, u.password)
    		fail
    	}
    	catch(Exception e){
    		assertEquals(e.getMessage(), "La nueva contraseña no puede ser igual a la anterior.")
    	}
    }
    
    @Test
    def testAUserLoginsSuccessfully(){
    		assertTrue(userService.login(u.nombreDeUsuario, u.password))
    }
    
    

}
