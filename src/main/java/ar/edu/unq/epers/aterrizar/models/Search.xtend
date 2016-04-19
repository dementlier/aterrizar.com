package ar.edu.unq.epers.aterrizar.models

import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors
import java.util.ArrayList

@Accessors
class Search {
	
	List<Criteria> criterias
	private int id
	
	new(){
		criterias = new ArrayList<Criteria>()
	}
	
	def getHQL(){
		var res = "SELECT flights FROM Airline as airline INNER JOIN airline.flights as flights WHERE "
		for(criteria : criterias){
			res = res + criteria.getHQL()
		}
		return res
	}
}