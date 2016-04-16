package ar.edu.unq.epers.aterrizar.models

import ar.edu.unq.epers.aterrizar.models.Criteria
import java.util.ArrayList

class CriteriaOriginAndDestination extends Criteria {
	
	String originWanted
	String destinationWanted

	new(){
		
	}
	
	new(String origin, String destination){
		this.destinationWanted = destination
		this.originWanted = origin
	}
	
	override search(Airline airline){
		var list = new ArrayList<Flight>()
		for(flight : airline.flights){
			if(flight.origin == originWanted && flight.destination == destinationWanted){
				list.add(flight)
			}
		}
		list
	}
}