package ar.edu.unq.epers.aterrizar.test.services

import org.junit.Before
import org.junit.Test
import static org.junit.Assert.*
import ar.edu.unq.epers.aterrizar.services.SearcherHibernateService
import ar.edu.unq.epers.aterrizar.models.Flight
import ar.edu.unq.epers.aterrizar.models.Airline
import ar.edu.unq.epers.aterrizar.models.Searcher
import ar.edu.unq.epers.aterrizar.models.Search
import ar.edu.unq.epers.aterrizar.models.User
import ar.edu.unq.epers.aterrizar.models.CriteriaEquals
import java.sql.Date

class HQLSearchTest {
	
	Airline aerolinea
	Searcher searcher
	
	@Before
	def void setUp() {
		
		var vuelo = new Flight()
		vuelo.origin = "Madrid"
		vuelo.destination = "Orlando"
		
		aerolinea = new Airline()
		aerolinea.name = "Pepe Airlines"
		aerolinea.flights.add(vuelo)
		
		searcher = new Searcher()
		searcher.airlines.add(aerolinea)
		
		var searcherService = new SearcherHibernateService()
		searcherService.saveSearcher(searcher)
	}
	
	@Test
	def testHQLCriteriaEquals() {
		var searchCriteria = new Search()
		searchCriteria.criterias.add(new CriteriaEquals("airline.name", "Pepe Airlines"))
		var list = searcher.search(new User("Jose", "Juarez", "josejuarez", "pe@p.com", new Date(1), "1234", false), searchCriteria)
		assertEquals(aerolinea.flights, list );
		// las listas son del mismo vuelo, pero tienen distinto hash		
	}
	
		
}