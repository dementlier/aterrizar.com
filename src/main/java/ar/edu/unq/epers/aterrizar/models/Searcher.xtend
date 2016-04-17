package ar.edu.unq.epers.aterrizar.models

import java.util.List
import java.util.ArrayList
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class Searcher {
	
	List<Airline> airlines
	private int id
	
	new(){
		airlines = new ArrayList<Airline>()
	}
	
	new(List<Airline> aerolineas){
		airlines = aerolineas
	}
	
	def search(Search searchCriterias){
		var list = new ArrayList<Flight>()
		for(airline : airlines){
			list.addAll(searchCriterias.search(airline))
		}
		list
	}
	
	def reserve(){
		//TODO... 
	}
	
}