package ar.edu.unq.epers.aterrizar.models

import org.eclipse.xtend.lib.annotations.Accessors
import java.util.List
import java.util.ArrayList
import ar.edu.unq.epers.aterrizar.services.UserHibernateService
import ar.edu.unq.epers.aterrizar.persistence.SessionManager

@Accessors
class Searcher {
	
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
			SessionManager.getSession.createQuery(searchCriterias.getHQL).list() as List<Flight>
		])
		user.addSearch(searchCriterias)
		new UserHibernateService().saveUser(user)
		list
	}
	

}