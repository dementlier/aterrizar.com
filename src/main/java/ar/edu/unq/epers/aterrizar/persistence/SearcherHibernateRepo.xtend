package ar.edu.unq.epers.aterrizar.persistence

import ar.edu.unq.epers.aterrizar.models.airlines.Airline
import ar.edu.unq.epers.aterrizar.models.airlines.Flight
import ar.edu.unq.epers.aterrizar.models.airlines.Seat
import ar.edu.unq.epers.aterrizar.models.airlines.Section
import ar.edu.unq.epers.aterrizar.persistence.HibernateRepo
import ar.edu.unq.epers.aterrizar.persistence.SessionManager
import ar.edu.unq.epers.aterrizar.services.SearcherService

class SearcherHibernateRepo {

	def <T> T getX(int id, Class<T> tipo){
		SessionManager.runInSession([
            new HibernateRepo(tipo).get(id) as T
        ])
	}
	
	def getSearcher(int id){
		getX(id, SearcherService)
	}
	
	def getSection(int id){
		getX(id, Section)
	}
	
	def getSeat(int id) {
		getX(id, Seat)
	}
	
	def <T> void saveX(T aGuardar){
		SessionManager.runInSession([
            val tipo = aGuardar.class as Class<T>
            new HibernateRepo(tipo).save(aGuardar)
            void
        ])
	}
	
	def saveSearcher(SearcherService searcher){
		saveX(searcher)
	}
	
	def saveSection(Section section){
		saveX(section)
	}
	
	def saveSeat(Seat seat) {
		saveX(seat)
	}

	
	 /**
     * Deletes EVERYTHING
     * */
    def deleteAllSearchersInDB() {
        SessionManager.runInSession([
        	new HibernateRepo(Seat).deleteAllInDB("Seat")
        	new HibernateRepo(Section).deleteAllInDB("Section")
        	new HibernateRepo(Flight).deleteAllInDB("Flight")
        	new HibernateRepo(Airline).deleteAllInDB("Airline")
            new HibernateRepo(SearcherService).deleteAllInDB("SearcherService")
        ])
    }
    
     /**
     * Deletes EVERYTHING
     * */
    def deleteAllSectionsInDB() {
        SessionManager.runInSession([
            new HibernateRepo(Section).deleteAllInDB("Seat")
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