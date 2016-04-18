package ar.edu.unq.epers.aterrizar.models

import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class Airline {
	private List<Flight> flights
	private int id
	String name
	
	new(){}
	
	new(String someName, List<Flight> someFlights){
		this.flights = someFlights
		this.name = someName
	}
		

}