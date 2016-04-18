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
	
	def getSeat(int id) {
		SessionManager.runInSession([
            new HibernateRepo(Seat).get(id) as Seat
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
	
	def saveSeat(Seat seat) {
		SessionManager.runInSession([
            new HibernateRepo(Seat).save(seat)
            void
        ])
	}

	
	 /**
     * Deletes EVERYTHING
     * */
    def deleteAllSearchersInDB() {
        SessionManager.runInSession([
            new HibernateRepo(Searcher).deleteAllInDB("Searcher")
        ])
    }
    
     /**
     * Deletes EVERYTHING
     * */
    def deleteAllSectionsInDB() {
        SessionManager.runInSession([
            new HibernateRepo(Section).deleteAllInDB("Section")
        ])
    }
    
     /**
     * Deletes EVERYTHING
     * */
    def deleteAllSeatsInDB() {
        SessionManager.runInSession([
            new HibernateRepo(Seat).deleteAllInDB("Seat")
        ])
    }
	

    
	
}