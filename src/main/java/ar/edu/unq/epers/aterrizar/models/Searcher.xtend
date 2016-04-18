package ar.edu.unq.epers.aterrizar.models

import java.util.List
import java.util.ArrayList
import org.eclipse.xtend.lib.annotations.Accessors
import ar.edu.unq.epers.aterrizar.services.SearcherHibernateService
import ar.edu.unq.epers.aterrizar.services.UserHibernateService
import org.eclipse.xtend.lib.annotations.EqualsHashCode

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
		var list = new ArrayList<Flight>()
		for(airline : airlines){
			list.addAll(searchCriterias.search(airline))
		}
		user.addSearch(searchCriterias)
		new UserHibernateService().saveUser(user)
		list
	}
	

}