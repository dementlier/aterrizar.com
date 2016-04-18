package ar.edu.unq.epers.aterrizar.test.models

import org.junit.Before
import org.junit.Test
import static org.junit.Assert.*
import ar.edu.unq.epers.aterrizar.services.SearcherHibernateService
import ar.edu.unq.epers.aterrizar.models.Section
import java.sql.Date
import java.util.ArrayList
import java.util.List
import ar.edu.unq.epers.aterrizar.models.Seat
import ar.edu.unq.epers.aterrizar.models.SeatCategory
import org.junit.After

class SectionTest {
	SearcherHibernateService service
	Section section
	List<Seat> seats
	Seat seat
	
	@Before
	def void setUp(){
		seats   = new ArrayList
		seat    = new Seat(10, SeatCategory.Business)
		seats.add(seat)
		section = new Section(9000, "Buenos Aires", "Rio de Janeiro", Date.valueOf("2016-04-17"), Date.valueOf("2016-04-17"), seats)
		service = new SearcherHibernateService()
		service.saveSection(section)
	}
	
	@Test
	def void testASectionIsSavedAndRetrievedCorrectly(){
		assertEquals(new SearcherHibernateService().getSection(1).id, 1)
	}
	
	@Test
	def void testASectionSaysItsReservableSeats(){
		assertEquals(service.getSection(section.id).reservableSeats.size, seats.size)
	}
	
	@Test
	def void testAListOfSeatsIsReservable(){
		val seat2 = new Seat(10, SeatCategory.First)
		section.addSeat(seat2)
		service.saveSection(section)
		assertTrue(service.getSection(section.id).isReservationPossible(seats))
		assertEquals(service.getSection(section.id).reservableSeats.size, 2)
	}
	
}