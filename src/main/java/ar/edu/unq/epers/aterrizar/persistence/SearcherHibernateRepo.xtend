package ar.edu.unq.epers.aterrizar.persistence

import ar.edu.unq.epers.aterrizar.models.Airline
import ar.edu.unq.epers.aterrizar.models.Flight
import ar.edu.unq.epers.aterrizar.models.Searcher
import ar.edu.unq.epers.aterrizar.models.Seat
import ar.edu.unq.epers.aterrizar.models.Section
import ar.edu.unq.epers.aterrizar.persistence.HibernateRepo
import ar.edu.unq.epers.aterrizar.persistence.SessionManager

class SearcherHibernateRepo {

	def <T> T getX(int id, Class<T> tipo){
		SessionManager.runInSession([
            new HibernateRepo(tipo).get(id) as T
        ])
	}
	
	def getSearcher(int id){
		getX(id, Searcher)
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
	
	def saveSearcher(Searcher searcher){
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
            new HibernateRepo(Searcher).deleteAllInDB("Searcher")
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