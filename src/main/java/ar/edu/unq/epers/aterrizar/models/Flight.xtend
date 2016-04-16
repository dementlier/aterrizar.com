package ar.edu.unq.epers.aterrizar.models

import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors
import java.sql.Date
import java.util.ArrayList

@Accessors
class Flight {
	private List<Section> sections
	private int id;
	String origin
	String destination
	Date departureDate
	Date arrivalDate

	new(){
		
	}
	
	new(List<Section> someSections){
		this.sections = someSections
	}
	
	def hasSeatsOfCategory(SeatCategory category){
		var bool = true
		for(section : sections){
			bool = bool && section.hasSeatsOfCategory(category)
		}
		return bool
	}
	
	def search(Criteria criteria){
		//TODO...
	}
	
}