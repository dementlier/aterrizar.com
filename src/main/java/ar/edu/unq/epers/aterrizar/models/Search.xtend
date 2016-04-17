package ar.edu.unq.epers.aterrizar.models

import java.util.List
import java.util.HashSet
import java.util.ArrayList
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class Search {
	
	List<Criteria> criterias
	private int id
	
	def search(Airline airline){
		var set = new HashSet<Flight>()
		for(criteria : criterias){
			set.addAll(criteria.search(airline))
		}
		var list = new ArrayList<Flight>(set)
		list
	}
}