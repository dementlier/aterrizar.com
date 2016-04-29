package ar.edu.unq.epers.aterrizar.test.services

import org.junit.Before
import org.junit.Test
import static org.junit.Assert.*
import ar.edu.unq.epers.aterrizar.models.Flight
import ar.edu.unq.epers.aterrizar.models.Airline
import ar.edu.unq.epers.aterrizar.models.Search
import ar.edu.unq.epers.aterrizar.models.User
import ar.edu.unq.epers.aterrizar.models.CriteriaEquals
import java.sql.Date
import ar.edu.unq.epers.aterrizar.models.CriteriaAnd
import ar.edu.unq.epers.aterrizar.services.UserHibernateService
import ar.edu.unq.epers.aterrizar.models.CriteriaOr
import ar.edu.unq.epers.aterrizar.persistence.SearcherHibernateRepo
import ar.edu.unq.epers.aterrizar.services.SearcherService

class HQLSearchTest {
	
	Airline aerolinea
	SearcherService searcher
	Airline aerolinea2
	User user
	
	@Before
	def void setUp() {
		
		var searcherService = new SearcherHibernateRepo()		
		searcherService.deleteAllSearchersInDB()
		var userService = new UserHibernateService()
		userService.deleteAllUsersInDB()

		var vuelo = new Flight()
		vuelo.origin = "Madrid"
		vuelo.destination = "Orlando"

		
		var vuelo2 = new Flight()
		vuelo2.origin = "Sirya"
		vuelo2.destination = "Orlando"
		
		var vuelo3 = new Flight()
		vuelo3.origin = "Tokyo"
		vuelo3.destination = "Madrid"
		
		aerolinea = new Airline()
		aerolinea.name = "Pepe Airlines"
		aerolinea.flights.add(vuelo)
				
		aerolinea2 = new Airline()
		aerolinea2.name = "Not Pepe Airlines"
		aerolinea2.flights.add(vuelo2)		
		aerolinea2.flights.add(vuelo3)
				
		searcher = new SearcherService()
		searcher.airlines.add(aerolinea)
		searcher.airlines.add(aerolinea2)

		searcherService.saveSearcher(searcher)
		
		user = new User("Jose", "Juarez", "josejuarez", "pe@p.com", new Date(1), "1234", false)
		
	}
	
	@Test
	def testHQLCriteriaEquals() {
		
		var criteria = new CriteriaEquals("airline.name", "Pepe Airlines")
		var searchCriteria = new Search()
		searchCriteria.criterias.add(criteria)
		var list = searcher.search(user, searchCriteria)
		
		assertEquals(1, list.size() )
		assertEquals("Madrid", aerolinea.flights.get(0).origin)
		assertEquals("Orlando", aerolinea.flights.get(0).destination)
		assertEquals("Madrid", list.get(0).origin)
		assertEquals("Orlando", list.get(0).destination)
		// Se hizo esto porque el hashCode cambia, y no queremos cambiar el hashCode (lease, no tenemos tiempo :( )
	}
	
	@Test
	def testHQLCriteriaEqualsYAND() {
		var searchCriteria = new Search()
		var criteriaAnd = new CriteriaAnd()
		criteriaAnd.criterias.add(new CriteriaEquals("airline.name", "Not Pepe Airlines"))
		criteriaAnd.criterias.add(new CriteriaEquals("flights.destination", "Madrid"))
		searchCriteria.criterias.add(criteriaAnd)
		var list = searcher.search(new User("Pepe", "Juarez", "pepejuarez", "pee@p.com", new Date(1), "1234", false), searchCriteria)
		assertEquals(1, list.size())
		assertEquals("Tokyo", list.get(0).origin)
		assertEquals("Madrid", list.get(0).destination)
		// Se hizo esto porque el hashCode cambia, y no queremos cambiar el hashCode (lease, no tenemos tiempo :( )
	}	

	@Test
	def testHQLCriteriaEqualsYOR() {
		var searchCriteria = new Search()
		var criteriaOr = new CriteriaOr()
		criteriaOr.criterias.add(new CriteriaEquals("airline.name", "Pepe Airlines"))
		criteriaOr.criterias.add(new CriteriaEquals("flights.destination", "Madrid"))
		searchCriteria.criterias.add(criteriaOr)
		var list = searcher.search(new User("Pepe", "Juarez", "pepejuarez", "pee@p.com", new Date(1), "1234", false), searchCriteria)
		assertEquals(2, list.size())
		assertEquals("Tokyo", list.get(1).origin)
		assertEquals("Madrid", list.get(1).destination)
		assertEquals("Madrid", list.get(0).origin)
		assertEquals("Orlando", list.get(0).destination)
		// Se hizo esto porque el hashCode cambia, y no queremos cambiar el hashCode (lease, no tenemos tiempo :( )
	}		
		
}