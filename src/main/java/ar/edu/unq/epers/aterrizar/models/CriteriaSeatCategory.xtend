package ar.edu.unq.epers.aterrizar.models

import ar.edu.unq.epers.aterrizar.models.Criteria
import java.util.ArrayList
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class CriteriaSeatCategory extends Criteria {
	
	SeatCategory categoryWanted
	
	new(){
		
	}
	
	new(SeatCategory category){
		this.categoryWanted = category
	}
	
	override search(Airline airline){
		var list = new ArrayList<Flight>()
		for(flight : airline.flights){
			if(flight.hasSeatsOfCategory(categoryWanted)){
				list.add(flight)
			}
		}
		list
	}
}