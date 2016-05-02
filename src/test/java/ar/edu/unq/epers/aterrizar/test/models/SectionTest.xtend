package ar.edu.unq.epers.aterrizar.test.models

import ar.edu.unq.epers.aterrizar.models.Seat
import ar.edu.unq.epers.aterrizar.models.SeatCategory
import ar.edu.unq.epers.aterrizar.models.Section
import java.sql.Date
import java.util.ArrayList
import java.util.List
import org.junit.Before
import org.junit.Test

import static org.junit.Assert.*
import ar.edu.unq.epers.aterrizar.persistence.SearcherHibernateRepo

class SectionTest {
	SearcherHibernateRepo service
	Section section
	List<Seat> seats
	Seat seat
	
	@Before
	def void setUp(){
		seats   = new ArrayList
		seat    = new Seat(10, SeatCategory.Business)
		seats.add(seat)
		section = new Section(9000, "Buenos Aires", "Rio de Janeiro", Date.valueOf("2016-04-17"), Date.valueOf("2016-04-17"), seats)
		service = new SearcherHibernateRepo()
		service.saveSection(section)
	}
	
	@Test
	def void testASectionIsSavedAndRetrievedCorrectly(){
		var retrievedSection = new SearcherHibernateRepo().getSection(section.id)
		assertEquals(section.id, retrievedSection.id)
	}
	
	@Test
	def void testASectionSaysItsReservableSeats(){
		assertEquals(seats.size, service.getSection(section.id).reservableSeats.size )
	}
	
	@Test
	def void testAListOfSeatsIsReservable(){
		val seat2 = new Seat(10, SeatCategory.First)
		section.addSeat(seat2)
		service.saveSection(section)
		assertTrue(service.getSection(section.id).isReservationPossible(seats))
		assertEquals(2, service.getSection(section.id).reservableSeats.size)
	}
	
}