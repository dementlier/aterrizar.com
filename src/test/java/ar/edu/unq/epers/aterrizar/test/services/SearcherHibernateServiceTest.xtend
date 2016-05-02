package ar.edu.unq.epers.aterrizar.test.services

import org.junit.Before
import org.junit.Test
import static org.junit.Assert.*
import ar.edu.unq.epers.aterrizar.persistence.SearcherHibernateRepo
import ar.edu.unq.epers.aterrizar.services.SearcherService

class SearcherHibernateServiceTest {
	SearcherHibernateRepo service
	SearcherService searcher
	
	@Before
	def void setUp(){
		searcher = new SearcherService()
		service  = new SearcherHibernateRepo()
		service.deleteAllSearchersInDB()
	}
	
	@Test
	def void testSavingAndGettingASearcher(){
		service.saveSearcher(searcher)
		assertEquals(service.getSearcher(searcher.id).getId, searcher.getId)
	}
	

}