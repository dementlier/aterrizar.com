package ar.edu.unq.epers.aterrizar.services

import ar.edu.unq.epers.aterrizar.persistence.SessionManager
import ar.edu.unq.epers.aterrizar.persistence.HibernateRepo
import ar.edu.unq.epers.aterrizar.models.Searcher
import ar.edu.unq.epers.aterrizar.models.Section
import ar.edu.unq.epers.aterrizar.models.Seat

class SearcherHibernateService {
	
	def getSearcher(int id){
		SessionManager.runInSession([
            new HibernateRepo(Searcher).get(id) as Searcher
        ])
	}
	
	def getSection(int id){
		SessionManager.runInSession([
            new HibernateRepo(Section).get(id) as Section
        ])
	}
	
	def saveSearcher(Searcher searcher){
		SessionManager.runInSession([
            new HibernateRepo(Searcher).save(searcher)
            void
        ])
	}
	
	def saveSection(Section section){
		SessionManager.runInSession([
            new HibernateRepo(Section).save(section)
            void
        ])
	}

	
	 /**
     * Deletes EVERYTHING
     * */
    def deleteAllSearchersInDB() {
        SessionManager.runInSession([
            new HibernateRepo(Searcher).deleteAllInDB("buscador")
        ])
    }
    
     /**
     * Deletes EVERYTHING
     * */
    def deleteAllSectionsInDB() {
        SessionManager.runInSession([
            new HibernateRepo(Section).deleteAllInDB("secciones")
        ])
    }
    
     /**
     * Deletes EVERYTHING
     * */
    def deleteAllSeatsInDB() {
        SessionManager.runInSession([
            new HibernateRepo(Seat).deleteAllInDB("asientos")
        ])
    }
    
	
}