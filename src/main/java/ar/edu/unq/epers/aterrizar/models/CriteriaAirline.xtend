package ar.edu.unq.epers.aterrizar.models

import ar.edu.unq.epers.aterrizar.models.Criteria
import java.util.ArrayList
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class CriteriaAirline extends Criteria {
	
	String airlineName
	
	new(){
		
	}
	
	new(String name){
		airlineName = name
	}
	
	override search(Airline airline){
		var list = new ArrayList<Flight>()
		if(airline.name == airlineName){
			list.addAll(airline.flights)
		}
		list
	}
}