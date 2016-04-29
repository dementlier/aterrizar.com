package ar.edu.unq.epers.aterrizar.models

import java.sql.Date
import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors
import java.util.ArrayList

@Accessors
class Flight {
	private List<Section> sections
	private int id;
	String origin
	String destination
	Date departureDate
	Date arrivalDate
	int price

	new(){
		sections = new ArrayList<Section>()
		price = 0
	}
	
	new(List<Section> someSections){
		this.sections = someSections
		refreshPrice()
	}
	
	def hasSeatsOfCategory(SeatCategory category){
		var bool = true
		for(section : sections){
			bool = bool && section.hasSeatsOfCategory(category)
		}
		return bool
	}

	def setSections(List<Section> someSections){
		this.sections = someSections
		refreshPrice()
	}
	
	def refreshPrice(){
		for(section : sections){
			price = price + section.price
		}				
	}
	
}