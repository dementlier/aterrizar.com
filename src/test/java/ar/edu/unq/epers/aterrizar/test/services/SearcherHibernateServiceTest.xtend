package ar.edu.unq.epers.aterrizar.test.services

import org.junit.Before
import org.junit.Test
import static org.junit.Assert.*
import ar.edu.unq.epers.aterrizar.models.Searcher
import ar.edu.unq.epers.aterrizar.services.SearcherHibernateService

class SearcherHibernateServiceTest {
	SearcherHibernateService service
	Searcher searcher
	
	@Before
	def void setUp(){
		searcher = new Searcher()
		service  = new SearcherHibernateService()
		service.deleteAllSearchersInDB()
	}
	
	@Test
	def void testSavingAndGettingASearcher(){
		service.saveSearcher(searcher)
		assertEquals(service.getSearcher(1).id, 1)
	}
	

}