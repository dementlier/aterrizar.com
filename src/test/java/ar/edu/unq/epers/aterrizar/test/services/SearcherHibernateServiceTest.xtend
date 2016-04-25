package ar.edu.unq.epers.aterrizar.test.services

import org.junit.Before
import org.junit.Test
import static org.junit.Assert.*
import ar.edu.unq.epers.aterrizar.models.Searcher
import ar.edu.unq.epers.aterrizar.persistence.SearcherHibernateRepo

class SearcherHibernateServiceTest {
	SearcherHibernateRepo service
	Searcher searcher
	
	@Before
	def void setUp(){
		searcher = new Searcher()
		service  = new SearcherHibernateRepo()
		service.deleteAllSearchersInDB()
	}
	
	@Test
	def void testSavingAndGettingASearcher(){
		service.saveSearcher(searcher)
		assertEquals(service.getSearcher(searcher.id).getId, searcher.getId)
	}
	

}