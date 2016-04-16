package ar.edu.unq.epers.aterrizar.models

import ar.edu.unq.epers.aterrizar.models.Criteria
import java.sql.Date
import java.util.ArrayList

class CriteriaDepartureDate extends Criteria {
	
	Date wantedDate
	
	new(){
		
	}
	
	new(Date date){
		this.wantedDate = date
	}
	
	override search(Airline airline){
		var list = new ArrayList<Flight>()
		for(flight : airline.flights){
			if(flight.departureDate == wantedDate){
				list.add(flight)
			}
		}
		list
	}
	
}