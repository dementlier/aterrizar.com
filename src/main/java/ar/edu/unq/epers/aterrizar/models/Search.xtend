package ar.edu.unq.epers.aterrizar.models

import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class Search {
	
	List<Criteria> criterias
	private int id
	
	def getHQL(){
		var res = "SELECT airline.flights FROM Airline as airline INNER JOIN Flight as flight WHERE "
		for(criteria : criterias){
			res + criteria.getHQL
		}
		return res
	}
}