package ar.edu.unq.epers.aterrizar.services

import org.eclipse.xtend.lib.annotations.Accessors
import java.util.List
import java.util.ArrayList
import ar.edu.unq.epers.aterrizar.services.UserHibernateService
import ar.edu.unq.epers.aterrizar.persistence.SessionManager
import ar.edu.unq.epers.aterrizar.models.Airline
import ar.edu.unq.epers.aterrizar.models.User
import ar.edu.unq.epers.aterrizar.models.Search
import ar.edu.unq.epers.aterrizar.models.Flight
import ar.edu.unq.epers.aterrizar.models.Section
import ar.edu.unq.epers.aterrizar.models.Seat
import ar.edu.unq.epers.aterrizar.persistence.SearcherHibernateRepo

@Accessors
class SearcherService {
	
	List<Airline> airlines
	private int id
	
	new(){
		airlines = new ArrayList<Airline>()
	}
	
	new(List<Airline> aerolineas){
		airlines = aerolineas
	}
	
	/**
	 * Performs a Search and saves it to the User that triggered the query for later reuse
	 * @returns List<Flight>
	 */
	def search(User user, Search searchCriterias){
		var list = SessionManager.runInSession([
			SessionManager.getSession.createQuery(searchCriterias.getHQL()).list() as List<Flight>
		])
		user.addSearch(searchCriterias)
		new UserHibernateService().saveUser(user)
		list
	}
	
	def reserveSeats(User user, Section section, List<Seat> seats){
		val repo = new SearcherHibernateRepo()
		section.reserveSeats(user, seats)
		SessionManager.runInSession([
			repo.saveSection(section)
			repo.saveX(user)
			null
		])
	}
	
	// Solo esta porque son 2 requerimientos diferentes, supongo... se podría obviar porque en una UI
	// nos podriamos encargar de hacer el cambio de Seat a List<Seat> sin necesidad de que nuestro servicio cambie
	def reserveSeat(User user, Section section, Seat seat){
		var list = new ArrayList<Seat>()
		list.add(seat)
		this.reserveSeats(user, section, list)
	}
	
	def reservableSeats(Section section){
		section.reservableSeats()
	}

	def saveSearch(User user, Search searchCriterias){
		user.addSearch(searchCriterias)
		SessionManager.runInSession([
			new SearcherHibernateRepo().saveX(user)
			null
		])
	}
}