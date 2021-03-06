package ar.edu.unq.epers.aterrizar.models.airlines

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
	}
	
	new(List<Section> someSections){
		setSections(someSections)
	}
	
	def refreshDurationAndLocations() {
		origin = this.sections.get(0).getOrigin()
		destination = this.sections.get(0).getDestination()
		departureDate = this.sections.get(0).getDepartureTime()
		arrivalDate = this.sections.get(0).getArrivalTime()
		for(section : this.sections){
			if(section.arrivalTime.after(arrivalDate)){
				arrivalDate = section.arrivalTime
				destination = section.destination
			}
			if(section.departureTime.before(departureDate)){
				departureDate = section.departureTime
				origin = section.origin
			}		
		}
	}
	
	def hasSeatsOfCategory(SeatCategory category){
		var bool = true
		bool = sections.forall[section | section.hasSeatsOfCategory(category)]
		return bool
	}

	def setSections(List<Section> someSections){
		this.sections = someSections
		refreshPrice()
		refreshDurationAndLocations()
	}
	
	def refreshPrice(){
		price = 0
		for(section : sections){
			price = price + section.price
		}				
	}
	
	def addSection(Section section){
		this.sections.add(section)
		refreshPrice()
		refreshDurationAndLocations()
	}
	
}