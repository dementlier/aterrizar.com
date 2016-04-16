package ar.edu.unq.epers.aterrizar.models

import java.util.List
import java.util.HashSet
import java.util.ArrayList

class Search {
	
	List<Criteria> criterias
	int id
	
	def search(Airline airline){
		var set = new HashSet<Flight>()
		for(criteria : criterias){
			set.addAll(criteria.search(airline))
		}
		var list = new ArrayList<Flight>(set)
		list
	}
}