package ar.edu.unq.epers.aterrizar.models.social

import java.util.List

class Profile {
	String name
	List<Destination> destinations
	
	new(String name, List<Destination> destinations){
		this.name = name
		this.destinations = destinations
	}
}