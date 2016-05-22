package ar.edu.unq.epers.aterrizar.models.airlines

import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors
import java.util.ArrayList

@Accessors
class Airline {
	private List<Flight> flights
	private int id
	String name
	
	new(){
		flights = new ArrayList<Flight>()
	}
	
	new(String someName, List<Flight> someFlights){
		this.flights = someFlights
		this.name = someName
	}
		
}