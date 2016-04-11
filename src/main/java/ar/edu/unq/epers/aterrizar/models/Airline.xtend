package ar.edu.unq.epers.aterrizar.models

import org.eclipse.xtend.lib.annotations.Accessors
import java.util.List

@Accessors
class Airline {
	private List<Flight> flights
	private int id
	
	new(){}
	
	new(List<Flight> someFlights){
		this.flights = someFlights
	}
	
	def search(Criteria criteria){
		//TODO...
	}
}