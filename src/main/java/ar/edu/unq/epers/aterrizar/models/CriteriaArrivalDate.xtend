package ar.edu.unq.epers.aterrizar.models

import ar.edu.unq.epers.aterrizar.models.Criteria
import java.sql.Date
import org.eclipse.xtend.lib.annotations.Accessors
import java.util.ArrayList

@Accessors
class CriteriaArrivalDate extends Criteria {
	
	Date wantedDate
	
	new(){
		
	}
	
	new(Date date){
		this.wantedDate = date
	}
	
	override search(Airline airline){
		var list = new ArrayList<Flight>()
		for(flight : airline.flights){
			if(flight.arrivalDate == wantedDate){
				list.add(flight)
			}
		}
		list
	}
}