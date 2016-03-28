package ar.edu.unq.epers.aterrizar.test.user
import ar.edu.unq.epers.aterrizar.user.User
import org.junit.Test
import static org.junit.Assert.*
import java.sql.Date

class UserTest {
    User u = new User("Pepe", "Juarez", "pepej", "p@p.com", new Date(1), "1234", false)

    @Test def void testAUserCanSayItsName(){
        assertEquals(u.getNombre(), "Pepe")
    }


}