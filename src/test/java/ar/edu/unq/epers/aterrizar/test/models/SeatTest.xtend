package ar.edu.unq.epers.aterrizar.test.models

import org.junit.Before
import org.junit.Test
import static org.junit.Assert.*
import ar.edu.unq.epers.aterrizar.models.Seat
import ar.edu.unq.epers.aterrizar.models.SeatCategory
import java.sql.Date
import ar.edu.unq.epers.aterrizar.models.User
import ar.edu.unq.epers.aterrizar.services.SearcherHibernateService
import ar.edu.unq.epers.aterrizar.services.UserHibernateService

class SeatTest {
	Seat seat
	SearcherHibernateService searcherService
	UserHibernateService uService
	User user
	@Before
	def void setUp(){
		seat = new Seat(15, SeatCategory.Tourist)
		user = new User("Pablo", "Perez", "pperez", "p@prz.com", Date.valueOf("2016-4-18"), "1234", false)
		uService = new UserHibernateService
		uService.saveUser(user)
		seat.setReserver(user)
		searcherService = new SearcherHibernateService
		searcherService.saveSeat(seat)
	}
	
	@Test
	def void testASeatIsReserved(){
		assertFalse(searcherService.getSeat(seat.id).isReservable)
	}
}