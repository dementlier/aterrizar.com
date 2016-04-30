package ar.edu.unq.epers.aterrizar.models

import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors
import java.util.ArrayList

@Accessors
class Search {
	
	List<Criteria> criterias
	private int id
	FlightOrder flightOrder
	
	new(){
		criterias = new ArrayList<Criteria>()
	}
	
	def getHQL(){
		var res = "SELECT flights FROM Airline as airline INNER JOIN airline.flights as flights "
		if(criterias.size()>0){
			res = res + "WHERE "
			for(criteria : criterias){
				res = res + criteria.getHQL()
			}
		}
		return res + hqlForOrder()
	}
	
	def hqlForOrder(){
		switch(flightOrder){
			case Cost : "ORDER BY flights.price ASC"
			case SectionNo : "ORDER BY count(flights.sections) ASC" // no se si anda.
			case Duration : "" // TODO podria agregarle una property Duration...
			default : ""
			
		}
	}
	
}