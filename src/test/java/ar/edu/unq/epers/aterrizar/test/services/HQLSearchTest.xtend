package ar.edu.unq.epers.aterrizar.test.services

import org.junit.Before
import org.junit.Test
import static org.junit.Assert.*
import ar.edu.unq.epers.aterrizar.services.SearcherHibernateService
import ar.edu.unq.epers.aterrizar.models.Flight
import ar.edu.unq.epers.aterrizar.models.Airline
import ar.edu.unq.epers.aterrizar.models.Searcher
import ar.edu.unq.epers.aterrizar.persistence.SessionManager
import java.util.List

class HQLSearchTest {
	
	Airline aerolinea
	
	@Before
	def void setUp() {
		
		var vuelo = new Flight()
		vuelo.origin = "Madrid"
		vuelo.destination = "Orlando"
		
		aerolinea = new Airline()
		aerolinea.name = "Pepe Airlines"
		aerolinea.flights.add(vuelo)
		
		var searcher = new Searcher()
		searcher.airlines.add(aerolinea)
		
		var searcherService = new SearcherHibernateService()
		searcherService.saveSearcher(searcher)
	}
	
	@Test
	def testHQL() {
		var hql = "SELECT airline.flights FROM Airline AS airline WHERE airline.name='Pepe Airlines'"
		var session = SessionManager.getSessionFactory().openSession()
		var query = session.createQuery(hql)
		var list = query.list() as List<Flight>
		session.close()
		assertEquals(aerolinea.flights, list );
		// las listas son del mismo vuelo, pero tienen distinto hash		
	}
	
		
}