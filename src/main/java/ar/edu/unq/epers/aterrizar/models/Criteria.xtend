package ar.edu.unq.epers.aterrizar.models

import org.eclipse.xtend.lib.annotations.Accessors
import java.util.List
import java.util.ArrayList

@Accessors
abstract class Criteria {
	private int id
	
	def List<Flight> search(Airline airline){
		return new ArrayList<Flight>()
	}
}