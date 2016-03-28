package ar.edu.unq.epers.aterrizar.test.user

import ar.edu.unq.epers.aterrizar.user.UserService
import ar.edu.unq.epers.aterrizar.user.User
import org.junit.Before
import java.sql.Date
import org.junit.Test
import static org.junit.Assert.*;


public class UserServiceTest {

    UserService userService;
    User u;

    @Before
    def void setUp(){
        userService = new UserService()
        userService.cleanDatabase()
        u = new User("Jose", "Juarez", "pepejuarez", "p@p.com", new Date(1), "1234", false)
    }

    @Test
    def testANewUserRegistersSuccesfullyIntoTheSystem() throws Exception{
        userService.registerUser(u);
        val user = userService.getUser("pepejuarez");
        assertEquals(user.getNombreDeUsuario(), u.getNombreDeUsuario());
    }
    

}
