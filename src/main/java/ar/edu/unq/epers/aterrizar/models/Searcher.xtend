package ar.edu.unq.epers.aterrizar.models

import java.util.List
import java.util.ArrayList
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class Searcher {
	
	List<Airline> airlines
	
	new(){
		airlines = new ArrayList<Airline>()
	}
	
	def search(Criteria criteria){
		//TODO...
	}
	def reserve(){
		//TODO...
	}
	
}